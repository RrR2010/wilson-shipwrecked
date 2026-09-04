extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const PhysicalObservation = preload("res://src/application/simulation/physical_observation.gd")
const PhysicalObservationConsequenceRule = preload("res://src/application/simulation/physical_observation_consequence_rule.gd")
const PhysicalObservationConsequenceResolver = preload("res://src/application/simulation/physical_observation_consequence_resolver.gd")
const PhysicalConsequenceWorldAdvanceDecorator = preload("res://src/application/simulation/physical_consequence_world_advance_decorator.gd")
const SimulationStepContext = preload("res://src/application/simulation/simulation_step_context.gd")
const WorldAdvanceResult = preload("res://src/application/simulation/world_advance_result.gd")
const PerceptionAccess = preload("res://src/domain/cognition/perception_access.gd")
const PerceptionService = preload("res://src/domain/cognition/perception_service.gd")
const GodotPhysicalObservationBuffer = preload("res://src/infrastructure/spatial/godot_physical_observation_buffer.gd")
const GodotSimulationHost = preload("res://src/infrastructure/spatial/godot_simulation_host.gd")

var _failures: Array[String] = []
var _completed := false


class EmptyWorldAdvance:
	extends RefCounted
	func advance(_elapsed: float, _step):
		return WorldAdvanceResult.new()


class RecordingOrchestrator:
	extends RefCounted
	var steps: Array = []
	func advance(step):
		steps.append(step)
		return null


func _init() -> void:
	_run_slice()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS physical_observation_consequence_integration_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL physical_observation_consequence_integration_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_slice() -> void:
	var wilson_ref: RuntimeWorldRef = RuntimeWorldRef.wilson()
	var rock_ref: RuntimeWorldRef = RuntimeWorldRef.entity(DomainId.entity(&"impact_rock"))
	var hard_impact = DomainId.event_definition(&"hard_impact_occurred")
	var rule = PhysicalObservationConsequenceRule.new(
		PhysicalObservation.Kind.CONTACT,
		hard_impact,
		3.0,
		&"subject",
		&"other",
		true
	)
	var resolver = PhysicalObservationConsequenceResolver.new([rule])
	var weak = PhysicalObservation.new(PhysicalObservation.Kind.CONTACT, wilson_ref, rock_ref, 2.9)
	var strong = PhysicalObservation.new(PhysicalObservation.Kind.CONTACT, wilson_ref, rock_ref, 4.5)

	_expect_equal(resolver.resolve([weak], &"weak_contact").size(), 0, "below-threshold engine contact is not an authoritative event")
	var admitted: Array = resolver.resolve([strong], &"strong_contact")
	_expect_equal(admitted.size(), 1, "authored hard-contact rule admits exactly one World event")
	if admitted.size() == 1:
		var event = admitted[0]
		_expect_true(event.event_type.equals(hard_impact), "admitted event uses authored semantic type")
		_expect_true(event.action_id == null, "physical event does not invent ActionExecution provenance")
		_expect_true(event.bindings.get_subject(&"subject").equals(wilson_ref), "physical event preserves Wilson subject identity")
		_expect_true(event.bindings.get_subject(&"other").equals(rock_ref), "physical event preserves counterpart identity")

	var step = SimulationStepContext.new(&"physical_batch", 0.1, 1.0, null, [], [weak, strong])
	var decorated = PhysicalConsequenceWorldAdvanceDecorator.new(EmptyWorldAdvance.new(), resolver)
	var world_result = decorated.advance(0.1, step)
	_expect_equal(world_result.events.size(), 1, "World advance composition merges only admitted physical consequences")
	_expect_equal(world_result.diagnostics.size(), 1, "physical admission leaves bounded diagnostic trace")

	if world_result.events.size() == 1:
		var event = world_result.events[0]
		var access: Dictionary = {
			event.execution_id: PerceptionAccess.new(true, [&"tactile"], [&"subject"], 0.9)
		}
		var perception = PerceptionService.new().perceive(world_result.events, access)
		_expect_equal(perception.evidence.size(), 1, "admitted physical World event enters ordinary perception")
		if perception.evidence.size() == 1:
			_expect_true(perception.evidence[0].claim.semantic_id.equals(hard_impact), "perceptual evidence carries admitted impact semantics")
			_expect_true(perception.evidence[0].claim.subject.equals(wilson_ref), "perceptual evidence remains Wilson-relative")

	var buffer = GodotPhysicalObservationBuffer.new()
	_expect_true(buffer.enqueue(weak), "weak observation queues as engine fact before semantic admission")
	_expect_true(buffer.enqueue(strong), "strong observation queues as engine fact before semantic admission")
	var recording = RecordingOrchestrator.new()
	var host = GodotSimulationHost.new()
	host.configure(recording, null, 0.1, 0.0, buffer)
	_expect_equal(host.advance_engine_time_for_test(0.1), 1, "one semantic boundary becomes due")
	_expect_equal(recording.steps.size(), 1, "host invokes orchestrator once at semantic boundary")
	if recording.steps.size() == 1:
		_expect_equal(recording.steps[0].physical_observations.size(), 2, "host drains complete physical observation batch into semantic step")
		_expect_true(recording.steps[0].physical_observations[0] == weak and recording.steps[0].physical_observations[1] == strong, "host preserves engine observation order")
	_expect_equal(buffer.pending_count(), 0, "semantic-step drain consumes engine observations exactly once")
	host.free()

	_completed = true


func _expect_true(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _expect_equal(actual: Variant, expected: Variant, message: String) -> void:
	if actual != expected:
		_failures.append("%s (expected=%s actual=%s)" % [message, expected, actual])
