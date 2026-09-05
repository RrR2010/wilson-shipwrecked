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
const DueElapsedGate = preload("res://src/application/simulation/due_elapsed_gate.gd")
const SemanticDueScheduler = preload("res://src/application/simulation/semantic_due_scheduler.gd")
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
	var scheduler = SemanticDueScheduler.new()
	scheduler.register(&"drives", 1.0, 0.0)
	var drive_due_gate = DueElapsedGate.new(scheduler, &"drives")
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
		drive_source,
		null,
		null,
		[],
		null,
		null,
		null,
		null,
		null,
		null,
		drive_due_gate
	)

	for index in range(9):
		var simulation_time: float = float(index + 1) * 0.1
		var quiet = orchestrator.advance(SimulationStepContext.new(
			StringName("drive_quiet_%02d" % index), 0.1, simulation_time, null, []
		))
		_expect_true(is_equal_approx(drives.value(DriveState.HUNGER), 0.54), "sub-second semantic heartbeat does not progress drives")
		_expect_equal(quiet.candidates.size(), 0, "not-due drive step does not open decision competition")
		_expect_true(quiet.decision == null, "not-due drive step keeps cognition quiet")

	var result = orchestrator.advance(SimulationStepContext.new(&"drive_due_1", 0.1, 1.0, null, []))
	_expect_true(is_equal_approx(drives.value(DriveState.HUNGER), 0.56), "due drive invocation conserves the full accumulated second")
	_expect_equal(drives.band(DriveState.HUNGER), DriveState.UrgencyBand.PRESSING, "due progression crosses the existing urgency boundary")
	_expect_equal(result.candidates.size(), 1, "due urgency crossing opens drive candidate competition")
	if result.candidates.size() == 1:
		_expect_equal(result.candidates[0].intention_id.key(), seek_food.key(), "drive candidate retains semantic intention")
	_expect_true(result.decision != null and result.decision.has_selection(), "drive-only competition selects candidate")
	_expect_true(intentions.has_current(), "selected drive intention commits through cognition owner")
	if intentions.has_current():
		_expect_equal(intentions.current().intention_id.key(), seek_food.key(), "committed intention comes from drive candidate")
	_expect_equal(trace_sink.traces.size(), 10, "every semantic heartbeat remains traceable")
	if trace_sink.traces.size() == 10:
		_expect_true(is_equal_approx(float(trace_sink.traces[8].stage_results[&"drive_due_elapsed"]), 0.0), "trace exposes zero due elapsed before deadline")
		_expect_true(is_equal_approx(float(trace_sink.traces[9].stage_results[&"drive_due_elapsed"]), 1.0), "trace exposes accumulated due elapsed at deadline")

	_completed = true

func _expect_true(actual: bool, label: String) -> void:
	if not actual:
		_failures.append("Expected true: %s" % label)

func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
