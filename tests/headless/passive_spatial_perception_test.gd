extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const BeliefStore = preload("res://src/domain/cognition/belief_store.gd")
const CurrentIntentionStore = preload("res://src/domain/cognition/current_intention_store.gd")
const DecisionRouter = preload("res://src/domain/cognition/decision_router.gd")
const DecisionCommitCoordinator = preload("res://src/application/simulation/decision_commit_coordinator.gd")
const SimulationOrchestrator = preload("res://src/application/simulation/simulation_orchestrator.gd")
const SimulationStepContext = preload("res://src/application/simulation/simulation_step_context.gd")
const WorldAdvanceResult = preload("res://src/application/simulation/world_advance_result.gd")
const PerceptionResult = preload("res://src/domain/cognition/perception_result.gd")
const PassiveSpatialPerceptionSource = preload("res://src/application/simulation/passive_spatial_perception_source.gd")
const GodotPassiveSpatialSensor = preload("res://src/infrastructure/spatial/godot_passive_spatial_sensor.gd")
const FakeSpatialQueryPort = preload("res://tests/fakes/fake_spatial_query_port.gd")
const FakeMotionPort = preload("res://tests/fakes/fake_motion_port.gd")
const MotionPort = preload("res://src/application/simulation/motion_port.gd")

var _failures: Array[String] = []
var _completed := false

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

class EventPerceptionStub:
	extends RefCounted
	func perceive(_events: Array, _access: Dictionary):
		return PerceptionResult.new()

class LearningRecordingStub:
	extends RefCounted
	var evidence_count := 0
	func process(perception_result) -> Dictionary:
		evidence_count = perception_result.evidence.size()
		return {"evidence_count": evidence_count}

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
	_run_slice()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS passive_spatial_perception_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL passive_spatial_perception_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_slice() -> void:
	var wilson_ref: RuntimeWorldRef = RuntimeWorldRef.wilson()
	var fruit_ref: RuntimeWorldRef = RuntimeWorldRef.entity(DomainId.entity(&"visible_fruit"))
	var nearby_relation = DomainId.relation_type(&"perceptibly_near")

	var sensor_area := Area3D.new()
	var fruit_body := StaticBody3D.new()
	var sensor := GodotPassiveSpatialSensor.new()
	sensor.configure(sensor_area)
	_expect_true(sensor.bind_candidate(fruit_ref, fruit_body), "candidate body binds to semantic identity")

	# Exercise the exact Godot signal path used by collision broadphase callbacks.
	sensor_area.body_entered.emit(fruit_body)
	_expect_equal(sensor.active_candidate_count(), 1, "body_entered adds collision candidate")
	_expect_true(sensor.has_pending_refresh(), "collision entry marks passive perception dirty")

	var spatial: Variant = FakeSpatialQueryPort.new()
	spatial.set_distance(wilson_ref, fruit_ref, 4.0)
	spatial.set_line_of_sight(wilson_ref, fruit_ref, true)
	var passive = PassiveSpatialPerceptionSource.new(sensor, spatial, wilson_ref, nearby_relation, 8.0)

	var motion: Variant = FakeMotionPort.new()
	_expect_true(motion.request_move(wilson_ref, fruit_ref), "Wilson can be in semantic movement")
	_expect_equal(motion.get_status(wilson_ref), MotionPort.MotionStatus.MOVING, "Wilson remains MOVING before passive refresh")

	var intentions = CurrentIntentionStore.new()
	var learning = LearningRecordingStub.new()
	var orchestrator = SimulationOrchestrator.new(
		WorldAdvanceStub.new(),
		ActionExecutionStub.new(),
		WorldCommandsStub.new(),
		DerivedInvalidatorStub.new(),
		ActivityQueryStub.new(intentions),
		PerceptionAccessStub.new(),
		EventPerceptionStub.new(),
		learning,
		OpportunityStub.new(),
		BeliefStore.new(),
		[],
		DecisionRouter.new(),
		DecisionCommitCoordinator.new(intentions),
		TraceSinkStub.new(),
		null, null, null, null, [], null, null,
		passive
	)

	var result = orchestrator.advance(SimulationStepContext.new(&"moving_passive_1", 0.1, 0.1, null, []))
	_expect_equal(motion.get_status(wilson_ref), MotionPort.MotionStatus.MOVING, "passive perception does not wait for ARRIVED")
	_expect_equal(result.perception.evidence.size(), 1, "visible overlap candidate becomes perceptual evidence")
	if result.perception.evidence.size() == 1:
		var claim = result.perception.evidence[0].claim
		_expect_equal(claim.semantic_id.key(), nearby_relation.key(), "passive evidence keeps configured Wilson-relative relation")
		_expect_true(claim.object.equals(fruit_ref), "passive evidence identifies perceived subject")
	_expect_equal(learning.evidence_count, 1, "passive evidence reaches immediate learning in same semantic chain")
	_expect_equal(result.candidates.size(), 0, "passive evidence alone does not force broad candidate generation")
	_expect_true(result.decision == null, "passive evidence alone keeps reconsideration NONE")

	# Bounded spatial refresh may revalidate a visible candidate repeatedly while moving,
	# but unchanged access must not spam duplicate positive evidence.
	sensor.request_refresh()
	var unchanged_visible = orchestrator.advance(SimulationStepContext.new(&"moving_passive_2", 0.1, 0.2, null, []))
	_expect_equal(unchanged_visible.perception.evidence.size(), 0, "unchanged visible access does not duplicate positive evidence")

	# Losing metric access rearms the transition. Returning to access can emit evidence again.
	spatial.set_distance(wilson_ref, fruit_ref, 12.0)
	sensor.request_refresh()
	var outside_access = orchestrator.advance(SimulationStepContext.new(&"moving_passive_3", 0.1, 0.3, null, []))
	_expect_equal(outside_access.perception.evidence.size(), 0, "candidate outside metric access emits no positive evidence")

	spatial.set_distance(wilson_ref, fruit_ref, 4.0)
	sensor.request_refresh()
	var regained_access = orchestrator.advance(SimulationStepContext.new(&"moving_passive_4", 0.1, 0.4, null, []))
	_expect_equal(regained_access.perception.evidence.size(), 1, "regained perceptual access emits a new positive transition")

	sensor_area.body_exited.emit(fruit_body)
	_expect_equal(sensor.active_candidate_count(), 0, "body_exited removes collision candidate")
	_expect_true(sensor.has_pending_refresh(), "collision exit marks passive set dirty")
	var after_exit = orchestrator.advance(SimulationStepContext.new(&"moving_passive_5", 0.1, 0.5, null, []))
	_expect_equal(after_exit.perception.evidence.size(), 0, "exit refresh does not fabricate positive evidence")

	sensor.unbind_candidate(fruit_ref, fruit_body)
	sensor.free()
	sensor_area.free()
	fruit_body.free()
	_completed = true


func _expect_true(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _expect_equal(actual: Variant, expected: Variant, message: String) -> void:
	if actual != expected:
		_failures.append("%s (expected=%s actual=%s)" % [message, expected, actual])
