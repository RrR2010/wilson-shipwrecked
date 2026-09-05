extends SceneTree

const FIXTURE_PATH := "res://tests/scenes/spatial_navigation_perception/spatial_navigation_perception.tscn"

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const BeliefStore = preload("res://src/domain/cognition/belief_store.gd")
const CurrentIntentionStore = preload("res://src/domain/cognition/current_intention_store.gd")
const DecisionRouter = preload("res://src/domain/cognition/decision_router.gd")
const EpistemicClaim = preload("res://src/domain/cognition/epistemic_claim.gd")
const PerceptualEvidence = preload("res://src/domain/cognition/perceptual_evidence.gd")
const PerceptionResult = preload("res://src/domain/cognition/perception_result.gd")
const ThreatInterpretationRule = preload("res://src/domain/cognition/threat_interpretation_rule.gd")
const PerceivedThreatService = preload("res://src/domain/cognition/perceived_threat_service.gd")
const DefensiveCandidateDefinition = preload("res://src/domain/cognition/defensive_candidate_definition.gd")
const ImmediateThreatCandidateSource = preload("res://src/domain/cognition/immediate_threat_candidate_source.gd")
const DecisionCandidate = preload("res://src/domain/cognition/decision_candidate.gd")
const DecisionCommitCoordinator = preload("res://src/application/simulation/decision_commit_coordinator.gd")
const DueElapsedGate = preload("res://src/application/simulation/due_elapsed_gate.gd")
const EscapeDestinationResolver = preload("res://src/application/simulation/escape_destination_resolver.gd")
const DefensiveMotionExecutionCoordinator = preload("res://src/application/simulation/defensive_motion_execution_coordinator.gd")
const MotionPort = preload("res://src/application/simulation/motion_port.gd")
const PerceivedThreatTriggerSource = preload("res://src/application/simulation/perceived_threat_trigger_source.gd")
const ReconsiderationGate = preload("res://src/application/simulation/reconsideration_gate.gd")
const SemanticDueScheduler = preload("res://src/application/simulation/semantic_due_scheduler.gd")
const SimulationOrchestrator = preload("res://src/application/simulation/simulation_orchestrator.gd")
const SimulationStepContext = preload("res://src/application/simulation/simulation_step_context.gd")
const WorldAdvanceResult = preload("res://src/application/simulation/world_advance_result.gd")

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


class LearningRecordingStub:
	extends RefCounted
	var evidence_counts: Array[int] = []
	func process(perception_result) -> Dictionary:
		evidence_counts.append(perception_result.evidence.size())
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


class RecordingDueOwner:
	extends RefCounted
	var elapsed_calls: Array[float] = []
	var due_times: Array[float] = []
	func advance(elapsed: float, simulation_time: float) -> void:
		elapsed_calls.append(elapsed)
		due_times.append(simulation_time)


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var packed: PackedScene = load(FIXTURE_PATH)
	if packed == null:
		_failures.append("Representative 3D fixture failed to load")
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
	var gerald_ref: RuntimeWorldRef = fixture._perceptible_ref
	var palm_ref: RuntimeWorldRef = original_target_ref

	fixture.wilson.global_position = fixture.START_POSITION
	fixture.wilson.velocity = Vector3.ZERO
	fixture.target.global_position = fixture.TARGET_POSITION
	fixture.escape_target.global_position = fixture.ESCAPE_POSITION
	fixture.perceptible.global_position = fixture.PERCEPTIBLE_ROUTE_POSITION
	for _frame in range(2):
		await physics_frame

	var palm_falling = DomainId.event_definition(&"palm_started_falling")
	var dodge = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"dodge_threat")
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
	var learning = LearningRecordingStub.new()
	var traces = TraceSinkStub.new()
	var orchestrator = SimulationOrchestrator.new(
		WorldAdvanceStub.new(),
		ActionExecutionStub.new(),
		WorldCommandsStub.new(),
		DerivedInvalidatorStub.new(),
		ActivityQueryStub.new(intentions),
		PerceptionAccessStub.new(),
		perception,
		learning,
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

	var scheduler = SemanticDueScheduler.new()
	scheduler.register(&"drives", 1.0, 0.0)
	scheduler.register(&"dynamic_processes", 2.0, 0.0)
	var drive_gate = DueElapsedGate.new(scheduler, &"drives")
	var process_gate = DueElapsedGate.new(scheduler, &"dynamic_processes")
	var drive_owner = RecordingDueOwner.new()
	var process_owner = RecordingDueOwner.new()

	_expect_true(fixture._motion.request_move(wilson_ref, original_target_ref), "long pre-threat movement starts")
	_expect_equal(fixture._motion.get_status(wilson_ref), MotionPort.MotionStatus.MOVING, "Wilson starts the integrated trace MOVING")
	var initial_target = fixture._motion.get_target(wilson_ref)
	_expect_ref(initial_target, original_target_ref, "long movement initially targets the palm/tree destination")

	var gerald_time: float = -1.0
	var threat_time: float = -1.0
	var semantic_steps: int = 0
	var cognition_steps: int = 0
	var gerald_seen: bool = false
	var threat_redirected: bool = false
	var redirect_position := Vector3.ZERO
	var threat_distance_before: float = INF

	for physics_index in range(720):
		fixture.wilson.velocity.y = -0.5
		fixture._motion.physics_tick(1.0 / 60.0)

		if (physics_index + 1) % 6 == 0:
			semantic_steps += 1
			var simulation_time: float = float(semantic_steps) * 0.1
			var drive_elapsed: float = drive_gate.elapsed_for_step(0.1, simulation_time)
			if drive_elapsed > 0.0:
				drive_owner.advance(drive_elapsed, simulation_time)
			var process_elapsed: float = process_gate.elapsed_for_step(0.1, simulation_time)
			if process_elapsed > 0.0:
				process_owner.advance(process_elapsed, simulation_time)

			if not gerald_seen and fixture._motion.get_status(wilson_ref) == MotionPort.MotionStatus.MOVING and fixture._sensor.has_pending_refresh():
				var passive_result = fixture._passive.collect()
				if not passive_result.evidence.is_empty():
					gerald_seen = true
					gerald_time = simulation_time
					perception.result = passive_result
					var gerald_step = orchestrator.advance(SimulationStepContext.new(
						StringName("gerald_%03d" % semantic_steps),
						0.1,
						simulation_time,
						null,
						[]
					))
					cognition_steps += 1
					_expect_true(gerald_step.decision == null, "ordinary Gerald evidence does not force broad reconsideration")
					_expect_equal(gerald_step.candidates.size(), 0, "ordinary Gerald evidence produces no decision candidates without a trigger")
					_expect_equal(fixture._motion.get_status(wilson_ref), MotionPort.MotionStatus.MOVING, "Wilson remains MOVING after noticing Gerald")
					_expect_ref(fixture._motion.get_target(wilson_ref), original_target_ref, "Gerald perception preserves the original movement target")

			if gerald_seen and not threat_redirected and simulation_time >= 6.0 - 1.0e-9:
				threat_time = simulation_time
				threat_distance_before = fixture._spatial.metric_distance(wilson_ref, palm_ref)
				var threat_evidence = PerceptualEvidence.new(
					EpistemicClaim.event_claim(palm_ref, palm_falling, &"source"),
					0.8,
					&"falling_palm_visible",
					&"vision"
				)
				perception.result = PerceptionResult.new([], [threat_evidence])
				var threat_step = orchestrator.advance(SimulationStepContext.new(
					StringName("palm_%03d" % semantic_steps),
					0.1,
					simulation_time,
					null,
					[]
				))
				cognition_steps += 1
				threat_redirected = threat_step.decision != null
				_expect_true(threat_step.decision != null, "falling-palm evidence wakes reconsideration at the semantic boundary")
				if threat_step.decision != null:
					_expect_equal(threat_step.decision.regime, &"immediate_threat", "falling palm enters immediate-threat routing")
					_expect_true(threat_step.decision.selected_candidate != null, "falling palm selects a defensive candidate")
					if threat_step.decision.selected_candidate != null:
						_expect_equal(threat_step.decision.selected_candidate.scope, DecisionCandidate.Scope.IMMEDIATE_THREAT, "selected palm defense has immediate-threat scope")
				_expect_ref(fixture._motion.get_target(wilson_ref), escape_ref, "committed defense redirects real Godot motion to escape")
				_expect_equal(fixture._motion.get_status(wilson_ref), MotionPort.MotionStatus.MOVING, "redirect continues as a real MOVING request")
				redirect_position = fixture.wilson.global_position
				break

		var status: int = fixture._motion.get_status(wilson_ref)
		if status == MotionPort.MotionStatus.ARRIVED or status == MotionPort.MotionStatus.BLOCKED or status == MotionPort.MotionStatus.ROUTE_INVALID:
			break
		await physics_frame

	_expect_true(gerald_seen, "Gerald becomes perceptible during the long movement")
	_expect_true(gerald_time > 0.0 and gerald_time < 6.0, "Gerald evidence precedes the falling-palm boundary")
	_expect_true(threat_redirected, "falling-palm threat redirects motion before original arrival")
	_expect_true(threat_time >= 6.0, "palm threat is admitted at the later representative boundary")
	_expect_equal(cognition_steps, 2, "only Gerald and palm semantic boundaries run cognition during the heartbeat trace")
	_expect_equal(drive_owner.elapsed_calls.size(), 6, "1 Hz drive owner advances only at six due boundaries before the threat")
	_expect_equal(process_owner.elapsed_calls.size(), 3, "2 s environment owner advances only at three due boundaries before the threat")
	_expect_true(semantic_steps >= 60, "semantic bridge advances independently for at least sixty 0.1 s boundaries")

	var escaped: bool = false
	var max_escape_displacement: float = 0.0
	for _frame in range(600):
		fixture.wilson.velocity.y = -0.5
		fixture._motion.physics_tick(1.0 / 60.0)
		var escape_displacement: float = Vector2(
			fixture.wilson.global_position.x - redirect_position.x,
			fixture.wilson.global_position.z - redirect_position.z
		).length()
		max_escape_displacement = maxf(max_escape_displacement, escape_displacement)
		var status: int = fixture._motion.get_status(wilson_ref)
		if status == MotionPort.MotionStatus.ARRIVED:
			escaped = true
			break
		if status == MotionPort.MotionStatus.BLOCKED or status == MotionPort.MotionStatus.ROUTE_INVALID:
			break
		await physics_frame

	var threat_distance_after: float = fixture._spatial.metric_distance(wilson_ref, palm_ref)
	_expect_true(escaped, "redirected real Godot motion reaches the authored escape destination")
	_expect_true(max_escape_displacement > 1.0, "defensive redirect produces concrete physical escape displacement")
	_expect_true(is_finite(threat_distance_before) and is_finite(threat_distance_after) and threat_distance_after > threat_distance_before, "escape increases metric distance from the falling palm")
	_expect_equal(traces.traces.size(), 2, "integrated causal trace contains only the two cognition-bearing semantic boundaries")
	_expect_equal(learning.evidence_counts, [1, 1], "Gerald and palm evidence both pass through learning before routing")

	print("[INTEGRATED_TIMING] gerald=%.1fs threat=%.1fs semantic_steps=%d drive_due=%d process_due=%d escape_displacement=%.3f" % [
		gerald_time,
		threat_time,
		semantic_steps,
		drive_owner.elapsed_calls.size(),
		process_owner.elapsed_calls.size(),
		max_escape_displacement,
	])

	fixture.queue_free()
	await process_frame
	_finish()


func _expect_true(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _expect_equal(actual: Variant, expected: Variant, message: String) -> void:
	if actual != expected:
		_failures.append("%s (expected=%s actual=%s)" % [message, expected, actual])


func _expect_ref(actual, expected, message: String) -> void:
	if actual == null or expected == null or not actual.equals(expected):
		_failures.append("%s (expected=%s actual=%s)" % [message, expected, actual])


func _finish() -> void:
	if _failures.is_empty():
		print("PASS integrated_gerald_palm_timing_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL integrated_gerald_palm_timing_test: %d failure(s)" % _failures.size())
	quit(1)
