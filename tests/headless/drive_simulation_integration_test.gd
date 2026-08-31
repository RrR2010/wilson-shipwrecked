extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const BeliefStore = preload("res://src/domain/cognition/belief_store.gd")
const CurrentIntentionStore = preload("res://src/domain/cognition/current_intention_store.gd")
const DriveState = preload("res://src/domain/cognition/drive_state.gd")
const DriveProgressionService = preload("res://src/domain/cognition/drive_progression_service.gd")
const DriveCandidateDefinition = preload("res://src/domain/cognition/drive_candidate_definition.gd")
const DriveCandidateSource = preload("res://src/domain/cognition/drive_candidate_source.gd")
const DecisionRouter = preload("res://src/domain/cognition/decision_router.gd")
const DecisionCommitCoordinator = preload("res://src/application/simulation/decision_commit_coordinator.gd")
const SimulationOrchestrator = preload("res://src/application/simulation/simulation_orchestrator.gd")
const SimulationStepContext = preload("res://src/application/simulation/simulation_step_context.gd")
const WorldAdvanceResult = preload("res://src/application/simulation/world_advance_result.gd")
const PerceptionResult = preload("res://src/domain/cognition/perception_result.gd")

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
	var intention_store
	func _init(p_intention_store) -> void:
		intention_store = p_intention_store
	func active_execution_id() -> StringName:
		return &""
	func current_intention():
		return intention_store.current() if intention_store.has_current() else null

class PerceptionAccessStub:
	extends RefCounted
	func resolve(_events: Array, _step) -> Dictionary:
		return {}

class PerceptionStub:
	extends RefCounted
	func perceive(_events: Array, _access: Dictionary):
		return PerceptionResult.new([], [])

class LearningStub:
	extends RefCounted
	func process(_perception_result) -> Dictionary:
		return {}

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
		print("PASS drive_simulation_integration_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL drive_simulation_integration_test: %d failure(s)" % _failures.size())
	quit(1)

func _run_slice() -> void:
	var drives = DriveState.new({DriveState.HUNGER: 0.54})
	var progression = DriveProgressionService.new(drives, {DriveState.HUNGER: 0.02})
	var seek_food = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"seek_food")
	var drive_source = DriveCandidateSource.new(drives, [DriveCandidateDefinition.new(DriveState.HUNGER, seek_food, 0.2)])
	var intentions = CurrentIntentionStore.new()
	var trace_sink = TraceSinkStub.new()
	var orchestrator = SimulationOrchestrator.new(
		WorldAdvanceStub.new(),
		ActionExecutionStub.new(),
		WorldCommandsStub.new(),
		DerivedInvalidatorStub.new(),
		ActivityQueryStub.new(intentions),
		PerceptionAccessStub.new(),
		PerceptionStub.new(),
		LearningStub.new(),
		OpportunityStub.new(),
		BeliefStore.new(),
		[],
		DecisionRouter.new(),
		DecisionCommitCoordinator.new(intentions),
		trace_sink,
		progression,
		drive_source
	)

	var result = orchestrator.advance(SimulationStepContext.new(&"drive_step_1", 1.0, 1.0, null, []))
	_expect_equal(drives.band(DriveState.HUNGER), DriveState.UrgencyBand.PRESSING, "orchestrator progresses drive state before candidate generation")
	_expect_equal(result.candidates.size(), 1, "drive candidate joins decision competition")
	if result.candidates.size() == 1:
		_expect_equal(result.candidates[0].intention_id.key(), seek_food.key(), "drive candidate retains semantic intention")
	_expect_true(result.decision.has_selection(), "drive-only competition selects candidate")
	_expect_true(intentions.has_current(), "selected drive intention commits through cognition owner")
	if intentions.has_current():
		_expect_equal(intentions.current().intention_id.key(), seek_food.key(), "committed intention comes from drive candidate")
	_expect_equal(trace_sink.traces.size(), 1, "drive-integrated step remains traceable")
	if trace_sink.traces.size() == 1:
		_expect_true(trace_sink.traces[0].stage_results.has(&"drive_progression"), "trace records drive progression")
		_expect_true(trace_sink.traces[0].stage_results.has(&"decision_candidates"), "trace records combined candidate set")

	_completed = true

func _expect_true(actual: bool, label: String) -> void:
	if not actual:
		_failures.append("Expected true: %s" % label)

func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
