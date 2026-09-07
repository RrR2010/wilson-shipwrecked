extends SceneTree

const FIXTURE_PATH := "res://tests/scenes/spatial_navigation_perception/spatial_navigation_perception.tscn"

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const RoleBinding = preload("res://src/domain/actions/role_binding.gd")
const WorldEvent = preload("res://src/domain/actions/world_event.gd")
const BeliefStore = preload("res://src/domain/cognition/belief_store.gd")
const CurrentIntentionStore = preload("res://src/domain/cognition/current_intention_store.gd")
const DecisionRouter = preload("res://src/domain/cognition/decision_router.gd")
const PerceptionAccess = preload("res://src/domain/cognition/perception_access.gd")
const PerceptionService = preload("res://src/domain/cognition/perception_service.gd")
const ThreatInterpretationRule = preload("res://src/domain/cognition/threat_interpretation_rule.gd")
const PerceivedThreatService = preload("res://src/domain/cognition/perceived_threat_service.gd")
const DefensiveCandidateDefinition = preload("res://src/domain/cognition/defensive_candidate_definition.gd")
const ImmediateThreatCandidateSource = preload("res://src/domain/cognition/immediate_threat_candidate_source.gd")
const DecisionCommitCoordinator = preload("res://src/application/simulation/decision_commit_coordinator.gd")
const DefensiveMotionExecutionCoordinator = preload("res://src/application/simulation/defensive_motion_execution_coordinator.gd")
const DirectTargetMotionExecutionCoordinator = preload("res://src/application/simulation/direct_target_motion_execution_coordinator.gd")
const EscapeDestinationResolver = preload("res://src/application/simulation/escape_destination_resolver.gd")
const InterruptedIntentionResumeCoordinator = preload("res://src/application/simulation/interrupted_intention_resume_coordinator.gd")
const MotionPort = preload("res://src/application/simulation/motion_port.gd")
const ReconsiderationGate = preload("res://src/application/simulation/reconsideration_gate.gd")
const SimulationOrchestrator = preload("res://src/application/simulation/simulation_orchestrator.gd")
const SimulationStepContext = preload("res://src/application/simulation/simulation_step_context.gd")
const WorldAdvanceResult = preload("res://src/application/simulation/world_advance_result.gd")

var _failures: Array[String] = []


class SingleEventWorldAdvance:
	extends RefCounted
	var event
	var emitted := false
	func _init(p_event) -> void:
		event = p_event
	func advance(_elapsed: float, _step):
		if emitted:
			return WorldAdvanceResult.new()
		emitted = true
		return WorldAdvanceResult.new([event])


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


class FixedPerceptionAccess:
	extends RefCounted
	var execution_id: StringName
	func _init(p_execution_id: StringName) -> void:
		execution_id = p_execution_id
	func resolve(_events: Array, _step) -> Dictionary:
		return {
			execution_id: PerceptionAccess.new(true, [&"vision"], [&"source"], 0.9),
		}


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
	func record(_trace) -> void:
		pass


class CompositeIntentionExecutor:
	extends RefCounted
	var defensive
	var direct
	func _init(p_defensive, p_direct) -> void:
		defensive = p_defensive
		direct = p_direct
	func apply(intention_state) -> Dictionary:
		var defensive_result: Dictionary = defensive.apply(intention_state)
		if bool(defensive_result.get("handled", false)):
			return defensive_result
		return direct.apply(intention_state)


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
	var forage_target_ref: RuntimeWorldRef = fixture._target_ref
	var escape_ref: RuntimeWorldRef = fixture._escape_ref
	var threat_ref: RuntimeWorldRef = RuntimeWorldRef.entity(DomainId.entity(&"interruption_threat"))
	var threat_event_type = DomainId.event_definition(&"interruption_threat_started")
	var forage = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"forage_coconuts")
	var dodge = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"dodge_threat")

	var threat_bindings = RoleBinding.new()
	threat_bindings.bind(&"source", threat_ref)
	var threat_event = WorldEvent.new(threat_event_type, null, threat_bindings, &"exec_interruption_threat")

	var intentions = CurrentIntentionStore.new()
	var forage_bindings = RoleBinding.new()
	forage_bindings.bind(&"target", forage_target_ref)
	intentions.select(forage, forage_bindings, &"routine_started")

	var direct_executor = DirectTargetMotionExecutionCoordinator.new(
		fixture._motion,
		wilson_ref,
		[forage]
	)
	var defensive_executor = DefensiveMotionExecutionCoordinator.new(
		fixture._motion,
		EscapeDestinationResolver.new(fixture._spatial, [escape_ref], 0.25),
		wilson_ref,
		[dodge]
	)
	var executor = CompositeIntentionExecutor.new(defensive_executor, direct_executor)
	var resume = InterruptedIntentionResumeCoordinator.new(intentions, executor, [dodge])

	fixture.wilson.global_position = fixture.START_POSITION
	fixture.target.global_position = fixture.TARGET_POSITION
	fixture.escape_target.global_position = fixture.ESCAPE_POSITION
	fixture.wilson.velocity = Vector3.ZERO
	for _frame in range(2):
		await physics_frame

	var initial_execution: Dictionary = executor.apply(intentions.current())
	_expect_true(bool(initial_execution.get("moving", false)), "routine begins physical movement")
	_expect_ref(fixture._motion.get_target(wilson_ref), forage_target_ref, "routine initially targets forage destination")

	for _frame in range(60):
		fixture.wilson.velocity.y = -0.5
		fixture._motion.physics_tick(1.0 / 60.0)
		await physics_frame
	var position_before_interrupt: Vector3 = fixture.wilson.global_position

	var threat_marker := Node3D.new()
	threat_marker.name = "InterruptionThreatSpatialReference"
	threat_marker.global_position = position_before_interrupt + Vector3(0.5, 0.0, 0.0)
	fixture.add_child(threat_marker)
	_expect_true(fixture._registry.bind(threat_ref, threat_marker), "threat binds to explicit RuntimeWorldRef for escape geometry")

	var threat_service = PerceivedThreatService.new([
		ThreatInterpretationRule.new(threat_event_type, &"source", 0.9, 0.95, 0.5),
	])
	var threat_candidates = ImmediateThreatCandidateSource.new(
		threat_service,
		[DefensiveCandidateDefinition.new(dodge, 0.4)]
	)
	var orchestrator = SimulationOrchestrator.new(
		SingleEventWorldAdvance.new(threat_event),
		ActionExecutionStub.new(),
		WorldCommandsStub.new(),
		DerivedInvalidatorStub.new(),
		ActivityQueryStub.new(intentions),
		FixedPerceptionAccess.new(threat_event.execution_id),
		PerceptionService.new(),
		LearningStub.new(),
		OpportunityStub.new(),
		BeliefStore.new(),
		[],
		DecisionRouter.new(),
		DecisionCommitCoordinator.new(intentions),
		TraceSinkStub.new(),
		null, null, null, null, [],
		threat_candidates,
		null,
		null,
		null,
		null,
		executor
	)

	var threat_step = orchestrator.advance(SimulationStepContext.new(
		&"threat_interrupt_step",
		0.1,
		0.1,
		null,
		[ReconsiderationGate.Trigger.THREAT]
	))
	_expect_true(threat_step.decision != null and threat_step.decision.has_selection(), "perceived threat produces a selected defense")
	_expect_true(intentions.has_suspended(), "routine remains explicitly suspended during defense")
	_expect_equal(intentions.current().intention_id.sort_key(), dodge.sort_key(), "defensive intention occupies current slot")
	_expect_ref(fixture._motion.get_target(wilson_ref), escape_ref, "defense redirects physical movement to escape")

	var escaped := false
	for _frame in range(600):
		fixture.wilson.velocity.y = -0.5
		fixture._motion.physics_tick(1.0 / 60.0)
		var status: int = fixture._motion.get_status(wilson_ref)
		if status == MotionPort.MotionStatus.ARRIVED:
			escaped = true
			break
		if status == MotionPort.MotionStatus.BLOCKED or status == MotionPort.MotionStatus.ROUTE_INVALID:
			break
		await physics_frame
	_expect_true(escaped, "defensive movement reaches escape destination")
	_expect_ref(fixture._motion.get_target(wilson_ref), escape_ref, "defensive ARRIVED belongs to escape target")

	var resume_result: Dictionary = resume.complete_and_resume()
	_expect_true(bool(resume_result.get("resumed", false)), "completed defense resumes suspended routine execution")
	_expect_true(not intentions.has_suspended(), "resume consumes the suspended slot")
	_expect_equal(intentions.current().intention_id.sort_key(), forage.sort_key(), "original routine returns as current intention")
	_expect_ref(fixture._motion.get_target(wilson_ref), forage_target_ref, "resumed routine physically retargets original forage destination")

	var resumed_position: Vector3 = fixture.wilson.global_position
	var reached_original_target := false
	var resumed_displacement := 0.0
	for _frame in range(900):
		fixture.wilson.velocity.y = -0.5
		fixture._motion.physics_tick(1.0 / 60.0)
		resumed_displacement = maxf(resumed_displacement, Vector2(
			fixture.wilson.global_position.x - resumed_position.x,
			fixture.wilson.global_position.z - resumed_position.z
		).length())
		var status: int = fixture._motion.get_status(wilson_ref)
		if status == MotionPort.MotionStatus.ARRIVED:
			reached_original_target = true
			break
		if status == MotionPort.MotionStatus.BLOCKED or status == MotionPort.MotionStatus.ROUTE_INVALID:
			break
		await physics_frame

	_expect_true(reached_original_target, "resumed routine reaches its original physical destination")
	_expect_true(resumed_displacement > 1.0, "resume produces concrete post-threat displacement")
	_expect_true(Vector2(
		fixture.wilson.global_position.x - position_before_interrupt.x,
		fixture.wilson.global_position.z - position_before_interrupt.z
	).length() > 0.5, "post-threat continuation is visibly distinct from interruption point")

	fixture.queue_free()
	_finish()


func _finish() -> void:
	if _failures.is_empty():
		print("PASS intention_interruption_physical_resume_scenario_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL intention_interruption_physical_resume_scenario_test: %d failure(s)" % _failures.size())
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
