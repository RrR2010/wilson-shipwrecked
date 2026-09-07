extends SceneTree

const FIXTURE_PATH := "res://tests/scenes/spatial_navigation_perception/spatial_navigation_perception.tscn"

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const BeliefStore = preload("res://src/domain/cognition/belief_store.gd")
const CurrentIntentionStore = preload("res://src/domain/cognition/current_intention_store.gd")
const DecisionRouter = preload("res://src/domain/cognition/decision_router.gd")
const DecisionCandidate = preload("res://src/domain/cognition/decision_candidate.gd")
const PerceptionAccess = preload("res://src/domain/cognition/perception_access.gd")
const PerceptionResult = preload("res://src/domain/cognition/perception_result.gd")
const PerceptionService = preload("res://src/domain/cognition/perception_service.gd")
const ThreatInterpretationRule = preload("res://src/domain/cognition/threat_interpretation_rule.gd")
const PerceivedThreatService = preload("res://src/domain/cognition/perceived_threat_service.gd")
const DefensiveCandidateDefinition = preload("res://src/domain/cognition/defensive_candidate_definition.gd")
const ImmediateThreatCandidateSource = preload("res://src/domain/cognition/immediate_threat_candidate_source.gd")
const DecisionCommitCoordinator = preload("res://src/application/simulation/decision_commit_coordinator.gd")
const DefensiveMotionExecutionCoordinator = preload("res://src/application/simulation/defensive_motion_execution_coordinator.gd")
const EscapeDestinationResolver = preload("res://src/application/simulation/escape_destination_resolver.gd")
const MotionPort = preload("res://src/application/simulation/motion_port.gd")
const PerceivedThreatTriggerSource = preload("res://src/application/simulation/perceived_threat_trigger_source.gd")
const PhysicalObservation = preload("res://src/application/simulation/physical_observation.gd")
const PhysicalObservationConsequenceRule = preload("res://src/application/simulation/physical_observation_consequence_rule.gd")
const PhysicalObservationConsequenceResolver = preload("res://src/application/simulation/physical_observation_consequence_resolver.gd")
const SimulationOrchestrator = preload("res://src/application/simulation/simulation_orchestrator.gd")
const SimulationStepContext = preload("res://src/application/simulation/simulation_step_context.gd")
const WorldAdvanceResult = preload("res://src/application/simulation/world_advance_result.gd")
const GodotDynamicFallObserver = preload("res://src/infrastructure/spatial/godot_dynamic_fall_observer.gd")
const GodotPhysicalObservationBuffer = preload("res://src/infrastructure/spatial/godot_physical_observation_buffer.gd")

var _failures: Array[String] = []


class WorldAdvanceStub:
	extends RefCounted
	func advance(_elapsed: float, _step):
		return WorldAdvanceResult.new()


class ActionExecutionStub:
	extends RefCounted
	func advance(_execution_id: StringName, _elapsed: float):
		return null


class WorldCommandsStub:
	extends RefCounted
	func apply_outcome(_outcome):
		return null


class DerivedInvalidatorStub:
	extends RefCounted
	func apply(_change_set):
		return null


class ActivityQueryStub:
	extends RefCounted
	var intentions
	func _init(p_intentions) -> void:
		intentions = p_intentions
	func active_execution_id() -> StringName:
		return &""
	func current_intention():
		return intentions.current() if intentions.has_current() else null


class PerceptionAccessStub:
	extends RefCounted
	func resolve(_events: Array, _step) -> Dictionary:
		return {}


class MutablePerceptionStub:
	extends RefCounted
	var result = PerceptionResult.new()
	func perceive(_events: Array, _access: Dictionary):
		return result


class LearningStub:
	extends RefCounted
	func process(perception_result) -> Dictionary:
		return {"evidence_count": perception_result.evidence.size()}


class OpportunityStub:
	extends RefCounted
	func generate(_perception_result, _belief_store, _definitions: Array) -> Array:
		return []


class TraceSinkStub:
	extends RefCounted
	var traces: Array = []
	func record(trace) -> void:
		traces.append(trace)


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var packed: PackedScene = load(FIXTURE_PATH)
	_expect_true(packed != null, "spatial fixture loads")
	if packed == null:
		_finish()
		return

	var fixture = packed.instantiate()
	fixture.auto_start = false
	fixture.pause_at_checkpoints = false
	fixture.movement_speed_mps = 1.5
	root.add_child(fixture)
	for _frame in range(3):
		await physics_frame
	fixture._setup_runtime_adapters()

	var wilson_ref: RuntimeWorldRef = fixture._wilson_ref
	var original_target_ref: RuntimeWorldRef = fixture._target_ref
	var escape_ref: RuntimeWorldRef = fixture._escape_ref
	var palm_ref: RuntimeWorldRef = RuntimeWorldRef.entity(DomainId.entity(&"physical_threat_palm"))
	var palm_falling = DomainId.event_definition(&"palm_started_falling")
	var dodge = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"dodge_threat")

	var palm: RigidBody3D = RigidBody3D.new()
	palm.name = "PhysicalThreatPalm"
	palm.position = Vector3(-1.5, 6.0, 0.0)
	palm.freeze = true
	var palm_shape: CollisionShape3D = CollisionShape3D.new()
	var box: BoxShape3D = BoxShape3D.new()
	box.size = Vector3(1.0, 1.0, 1.0)
	palm_shape.shape = box
	palm.add_child(palm_shape)
	fixture.add_child(palm)
	_expect_true(fixture._registry.bind(palm_ref, palm), "falling palm binds to explicit RuntimeWorldRef")

	var observation_buffer = GodotPhysicalObservationBuffer.new()
	var fall_observer = GodotDynamicFallObserver.new(fixture._registry, observation_buffer, 0.5)
	var admission = PhysicalObservationConsequenceResolver.new([
		PhysicalObservationConsequenceRule.new(
			PhysicalObservation.Kind.FALL,
			palm_falling,
			0.5,
			&"source",
			&"other",
			false
		)
	])
	var perception_service = PerceptionService.new()
	var threat_service = PerceivedThreatService.new([
		ThreatInterpretationRule.new(palm_falling, &"source", 0.9, 0.95, 0.5),
	])
	var threat_candidates = ImmediateThreatCandidateSource.new(
		threat_service,
		[DefensiveCandidateDefinition.new(dodge, 0.4)]
	)
	var threat_triggers = PerceivedThreatTriggerSource.new(threat_service)
	var escape_resolver = EscapeDestinationResolver.new(fixture._spatial, [escape_ref], 0.25)
	var motion_executor = DefensiveMotionExecutionCoordinator.new(
		fixture._motion,
		escape_resolver,
		wilson_ref,
		[dodge]
	)

	var intentions = CurrentIntentionStore.new()
	var perception = MutablePerceptionStub.new()
	var traces = TraceSinkStub.new()
	var orchestrator = SimulationOrchestrator.new(
		WorldAdvanceStub.new(),
		ActionExecutionStub.new(),
		WorldCommandsStub.new(),
		DerivedInvalidatorStub.new(),
		ActivityQueryStub.new(intentions),
		PerceptionAccessStub.new(),
		perception,
		LearningStub.new(),
		OpportunityStub.new(),
		BeliefStore.new(),
		[],
		DecisionRouter.new(),
		DecisionCommitCoordinator.new(intentions),
		traces,
		null, null, null, null, [],
		threat_candidates,
		null,
		null,
		threat_triggers,
		null,
		motion_executor
	)

	fixture.wilson.global_position = fixture.START_POSITION
	fixture.wilson.velocity = Vector3.ZERO
	fixture.target.global_position = fixture.TARGET_POSITION
	fixture.escape_target.global_position = fixture.ESCAPE_POSITION
	for _frame in range(2):
		await physics_frame

	_expect_true(fixture._motion.request_move(wilson_ref, original_target_ref), "pre-threat movement starts")
	_expect_equal(fixture._motion.get_status(wilson_ref), MotionPort.MotionStatus.MOVING, "Wilson begins MOVING toward original target")
	_expect_ref(fixture._motion.get_target(wilson_ref), original_target_ref, "pre-threat motion targets original destination")

	palm.freeze = false
	var observed_fall: PhysicalObservation = null
	for _frame in range(120):
		fixture.wilson.velocity.y = -0.5
		fixture._motion.physics_tick(1.0 / 60.0)
		fall_observer.sample_body(palm)
		if observation_buffer.pending_count() > 0:
			var observations = observation_buffer.drain_observations()
			if not observations.is_empty():
				observed_fall = observations[0]
				break
		await physics_frame

	_expect_true(observed_fall != null, "real Godot gravity produces a FALL observation")
	if observed_fall == null:
		fixture.queue_free()
		_finish()
		return
	_expect_true(observed_fall.subject.equals(palm_ref), "FALL observation preserves palm semantic identity")
	_expect_true(observed_fall.magnitude >= 0.5, "FALL observation carries threshold-crossing downward speed")

	var admitted = admission.resolve([observed_fall], &"physical_fall_threat")
	_expect_equal(admitted.size(), 1, "authored FALL rule admits one semantic event")
	if admitted.is_empty():
		fixture.queue_free()
		_finish()
		return
	var event = admitted[0]
	_expect_true(event.event_type.equals(palm_falling), "admitted event is palm_started_falling")
	_expect_true(event.bindings.get_subject(&"source").equals(palm_ref), "admitted event binds falling palm as source")

	var access: PerceptionAccess = PerceptionAccess.new(true, [&"vision"], [&"source"], 0.8)
	var perceived = perception_service.perceive(admitted, {event.execution_id: access})
	_expect_equal(perceived.evidence.size(), 1, "accessible falling event produces one perceptual evidence item")
	var threats = threat_service.derive(perceived)
	_expect_equal(threats.size(), 1, "perceived falling event derives one immediate threat")
	if threats.is_empty():
		fixture.queue_free()
		_finish()
		return
	_expect_true(threats[0].source_subject.equals(palm_ref), "threat remains grounded in perceived falling palm")

	var distance_before: float = fixture._spatial.metric_distance(wilson_ref, palm_ref)
	perception.result = perceived
	var threat_step = orchestrator.advance(SimulationStepContext.new(
		&"physical_fall_reconsideration",
		0.1,
		0.1,
		null,
		[]
	))
	_expect_true(threat_step.decision != null, "real perceived fall wakes reconsideration")
	if threat_step.decision != null:
		_expect_equal(threat_step.decision.regime, &"immediate_threat", "real perceived fall routes through immediate-threat regime")
		_expect_true(threat_step.decision.selected_candidate != null, "immediate threat selects a defensive candidate")
		if threat_step.decision.selected_candidate != null:
			_expect_equal(threat_step.decision.selected_candidate.scope, DecisionCandidate.Scope.IMMEDIATE_THREAT, "selected defense remains immediate-threat scoped")
	_expect_ref(fixture._motion.get_target(wilson_ref), escape_ref, "defensive commitment redirects real Godot motion to escape")
	_expect_equal(fixture._motion.get_status(wilson_ref), MotionPort.MotionStatus.MOVING, "redirect remains a live Godot MOVING request")

	var redirect_position: Vector3 = fixture.wilson.global_position
	var escaped: bool = false
	var max_displacement: float = 0.0
	for _frame in range(600):
		fixture.wilson.velocity.y = -0.5
		fixture._motion.physics_tick(1.0 / 60.0)
		var displacement: float = Vector2(
			fixture.wilson.global_position.x - redirect_position.x,
			fixture.wilson.global_position.z - redirect_position.z
		).length()
		max_displacement = maxf(max_displacement, displacement)
		var status: int = fixture._motion.get_status(wilson_ref)
		if status == MotionPort.MotionStatus.ARRIVED:
			escaped = true
			break
		if status == MotionPort.MotionStatus.BLOCKED or status == MotionPort.MotionStatus.ROUTE_INVALID:
			break
		await physics_frame

	var distance_after: float = fixture._spatial.metric_distance(wilson_ref, palm_ref)
	_expect_true(escaped, "defensive redirect reaches authored escape destination")
	_expect_true(max_displacement > 1.0, "defensive redirect produces concrete physical displacement")
	_expect_true(is_finite(distance_before) and is_finite(distance_after) and distance_after > distance_before, "escape increases distance from perceived falling palm")
	_expect_equal(traces.traces.size(), 1, "only the threat-bearing semantic boundary runs cognition")

	fixture.queue_free()
	_finish()


func _finish() -> void:
	if _failures.is_empty():
		print("PASS physical_fall_immediate_threat_scenario_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL physical_fall_immediate_threat_scenario_test: %d failure(s)" % _failures.size())
	quit(1)


func _expect_true(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _expect_equal(actual: Variant, expected: Variant, message: String) -> void:
	if actual != expected:
		_failures.append("%s (expected=%s actual=%s)" % [message, expected, actual])


func _expect_ref(actual, expected, message: String) -> void:
	if actual == null or expected == null or not actual.equals(expected):
		_failures.append(message)
