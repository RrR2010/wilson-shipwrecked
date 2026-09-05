extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const PhysicalObservation = preload("res://src/application/simulation/physical_observation.gd")
const WilsonBodyImpactRule = preload("res://src/application/simulation/wilson_body_impact_rule.gd")
const WilsonBodyImpactConsequenceResolver = preload("res://src/application/simulation/wilson_body_impact_consequence_resolver.gd")
const WilsonBodyState = preload("res://src/domain/world/wilson_body_state.gd")
const RunLifecycleState = preload("res://src/application/lifecycle/run_lifecycle_state.gd")
const GroundedDeathLifecycleCoordinator = preload("res://src/application/lifecycle/grounded_death_lifecycle_coordinator.gd")
const RoleBinding = preload("res://src/domain/actions/role_binding.gd")
const WorldEvent = preload("res://src/domain/actions/world_event.gd")

var _failures: Array[String] = []
var _completed := false


func _init() -> void:
	_run_slice()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS grounded_death_lifecycle_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL grounded_death_lifecycle_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_slice() -> void:
	var wilson_ref: RuntimeWorldRef = RuntimeWorldRef.wilson()
	var rock_ref: RuntimeWorldRef = RuntimeWorldRef.entity(DomainId.entity(&"death_test_rock"))
	var vitality_property = DomainId.property(&"wilson_vitality")
	var injury_event = DomainId.event_definition(&"wilson_injured")
	var death_event = DomainId.event_definition(&"wilson_died")
	var run_state = RunLifecycleState.new(&"death_lifecycle_run")
	var coordinator = GroundedDeathLifecycleCoordinator.new(run_state, wilson_ref, death_event)

	var injury_bindings = RoleBinding.new()
	injury_bindings.bind(&"subject", wilson_ref)
	var injury = WorldEvent.new(injury_event, null, injury_bindings, &"injury_fixture")
	var injury_result = coordinator.process([injury])
	_expect_true(injury_result.ok, "ordinary injury event is accepted as a non-death lifecycle batch")
	_expect_equal(run_state.lifecycle, RunLifecycleState.Lifecycle.ACTIVE, "ordinary injury event leaves run ACTIVE")
	_expect_equal(run_state.death_count, 0, "ordinary injury event does not increment death count")

	var other_bindings = RoleBinding.new()
	other_bindings.bind(&"subject", rock_ref)
	var other_death = WorldEvent.new(death_event, null, other_bindings, &"other_death_fixture")
	coordinator.process([other_death])
	_expect_equal(run_state.lifecycle, RunLifecycleState.Lifecycle.ACTIVE, "death event for a non-Wilson subject is ignored")

	var body = WilsonBodyState.new(0.2)
	var impact_rule = WilsonBodyImpactRule.new(
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
		[impact_rule]
	)
	var impact = PhysicalObservation.new(PhysicalObservation.Kind.CONTACT, wilson_ref, rock_ref, 4.5)
	var physical_resolution = resolver.resolve_result([impact], &"lethal_contact")

	_expect_true(not body.alive, "lethal body mutation commits before lifecycle propagation")
	_expect_equal(body.vitality, 0.0, "lethal body mutation clamps vitality to zero")
	_expect_equal(physical_resolution.events.size(), 1, "lethal body mutation emits exactly one committed death event")
	_expect_equal(physical_resolution.change_set.changes.size(), 1, "lethal body mutation reports one vitality semantic change")
	if physical_resolution.events.size() == 1:
		_expect_true(physical_resolution.events[0].event_type.equals(death_event), "committed body event uses authored death semantics")

	var death_result = coordinator.process(physical_resolution.events)
	_expect_true(death_result.ok, "grounded Wilson death is admitted into run lifecycle")
	_expect_equal(run_state.lifecycle, RunLifecycleState.Lifecycle.DEAD, "grounded Wilson death transitions run to DEAD")
	_expect_equal(run_state.death_count, 1, "grounded Wilson death increments death count once")
	_expect_equal(run_state.last_death_cause, &"wilson_died", "run lifecycle records semantic death cause")

	var duplicate_result = coordinator.process(physical_resolution.events)
	_expect_true(duplicate_result.ok, "duplicate committed death fact is idempotently accepted")
	_expect_equal(run_state.death_count, 1, "duplicate committed death fact does not increment death count again")

	_completed = true


func _expect_true(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _expect_equal(actual: Variant, expected: Variant, message: String) -> void:
	if actual != expected:
		_failures.append("%s (expected=%s actual=%s)" % [message, expected, actual])
