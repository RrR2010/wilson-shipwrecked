extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const PhysicalObservation = preload("res://src/application/simulation/physical_observation.gd")
const WilsonBodyImpactRule = preload("res://src/application/simulation/wilson_body_impact_rule.gd")
const WilsonBodyImpactConsequenceResolver = preload("res://src/application/simulation/wilson_body_impact_consequence_resolver.gd")
const PhysicalConsequenceWorldAdvanceDecorator = preload("res://src/application/simulation/physical_consequence_world_advance_decorator.gd")
const SimulationStepContext = preload("res://src/application/simulation/simulation_step_context.gd")
const WorldAdvanceResult = preload("res://src/application/simulation/world_advance_result.gd")
const WilsonBodyState = preload("res://src/domain/world/wilson_body_state.gd")
const RunLifecycleState = preload("res://src/application/lifecycle/run_lifecycle_state.gd")
const ResurrectionService = preload("res://src/application/lifecycle/resurrection_service.gd")

var _failures: Array[String] = []
var _completed := false


class EmptyWorldAdvance:
	extends RefCounted
	func advance(_elapsed: float, _step):
		return WorldAdvanceResult.new()


func _init() -> void:
	_run_slice()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS wilson_body_impact_consequence_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL wilson_body_impact_consequence_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_slice() -> void:
	var wilson_ref: RuntimeWorldRef = RuntimeWorldRef.wilson()
	var rock_ref: RuntimeWorldRef = RuntimeWorldRef.entity(DomainId.entity(&"body_test_rock"))
	var vitality_property = DomainId.property(&"wilson_vitality")
	var injury_event = DomainId.event_definition(&"wilson_injured")
	var death_event = DomainId.event_definition(&"wilson_died")
	var body = WilsonBodyState.new(1.0)
	var rule = WilsonBodyImpactRule.new(
		PhysicalObservation.Kind.CONTACT,
		3.0,
		0.4,
		injury_event,
		death_event,
		true
	)
	var resolver = WilsonBodyImpactConsequenceResolver.new(
		wilson_ref,
		body,
		vitality_property,
		[rule]
	)
	var weak = PhysicalObservation.new(PhysicalObservation.Kind.CONTACT, wilson_ref, rock_ref, 2.9)
	var strong = PhysicalObservation.new(PhysicalObservation.Kind.CONTACT, wilson_ref, rock_ref, 4.5)

	_expect_true(is_equal_approx(body.vitality, 1.0), "raw engine observation does not mutate body before admission")
	var rejected = resolver.resolve_result([weak], &"weak")
	_expect_equal(rejected.events.size(), 0, "below-threshold impact produces no World event")
	_expect_equal(rejected.change_set.changes.size(), 0, "below-threshold impact produces no semantic change")
	_expect_true(is_equal_approx(body.vitality, 1.0) and body.alive, "below-threshold impact leaves authoritative body unchanged")

	var injured = resolver.resolve_result([strong], &"injury")
	_expect_equal(injured.events.size(), 1, "admitted nonlethal impact emits one event after body mutation")
	_expect_equal(injured.change_set.changes.size(), 1, "admitted impact reports one vitality semantic change")
	_expect_true(is_equal_approx(body.vitality, 0.6) and body.alive, "nonlethal impact reduces clamped vitality while Wilson remains alive")
	if injured.events.size() == 1:
		_expect_true(injured.events[0].event_type.equals(injury_event), "nonlethal body mutation emits injury semantics")
		_expect_true(injured.events[0].bindings.get_subject(&"subject").equals(wilson_ref), "injury event preserves Wilson identity")
		_expect_true(injured.events[0].bindings.get_subject(&"other").equals(rock_ref), "injury event preserves impact counterpart")

	var second = resolver.resolve_result([strong], &"injury_again")
	_expect_equal(second.events.size(), 1, "second admitted nonlethal impact remains a committed injury event")
	_expect_true(is_equal_approx(body.vitality, 0.2) and body.alive, "successive impacts accumulate only in authoritative body state")

	var lethal = resolver.resolve_result([strong], &"lethal")
	_expect_equal(lethal.events.size(), 1, "lethal impact emits exactly one committed event")
	_expect_equal(lethal.change_set.changes.size(), 1, "lethal impact reports committed vitality change")
	_expect_true(is_equal_approx(body.vitality, 0.0) and not body.alive, "lethal impact clamps vitality at zero and transitions body to dead")
	if lethal.events.size() == 1:
		_expect_true(lethal.events[0].event_type.equals(death_event), "alive-to-dead body mutation emits death semantics")

	var repeated_dead = resolver.resolve_result([strong], &"dead_again")
	_expect_equal(repeated_dead.events.size(), 0, "damage while already dead does not fabricate repeated death events")
	_expect_equal(repeated_dead.change_set.changes.size(), 0, "damage while already dead does not fabricate body changes")
	_expect_true(is_equal_approx(body.vitality, 0.0) and not body.alive, "dead body remains clamped at zero vitality")

	var decorated_body = WilsonBodyState.new(1.0)
	var decorated_resolver = WilsonBodyImpactConsequenceResolver.new(wilson_ref, decorated_body, vitality_property, [rule])
	var decorated = PhysicalConsequenceWorldAdvanceDecorator.new(EmptyWorldAdvance.new(), decorated_resolver)
	var step = SimulationStepContext.new(&"decorated_body", 0.1, 0.1, null, [], [strong])
	var world_result = decorated.advance(0.1, step)
	_expect_equal(world_result.events.size(), 1, "World advance exposes body event only after committed impact consequence")
	_expect_equal(world_result.change_set.changes.size(), 1, "World advance merges body SemanticChangeSet for normal derived invalidation")
	_expect_true(is_equal_approx(decorated_body.vitality, 0.6), "decorated World advance owns the body mutation before returning")

	var run_state = RunLifecycleState.new(&"body_test_run")
	_expect_true(run_state.mark_dead(&"impact").ok, "run lifecycle can admit the already-grounded body death for resurrection test")
	var resurrection = ResurrectionService.new(run_state, body)
	var resurrected = resurrection.resurrect()
	_expect_true(resurrected.ok, "existing resurrection service accepts World-owned WilsonBodyState as its physical port")
	_expect_true(body.alive and is_equal_approx(body.vitality, 1.0), "physical resurrection restores authoritative body truth before lifecycle revival")
	_expect_equal(run_state.lifecycle, RunLifecycleState.Lifecycle.ACTIVE, "run lifecycle revives only after physical body restoration succeeds")

	_completed = true


func _expect_true(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _expect_equal(actual: Variant, expected: Variant, message: String) -> void:
	if actual != expected:
		_failures.append("%s (expected=%s actual=%s)" % [message, expected, actual])
