extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const RoleBinding = preload("res://src/domain/actions/role_binding.gd")
const BeliefStore = preload("res://src/domain/cognition/belief_store.gd")
const CurrentIntentionStore = preload("res://src/domain/cognition/current_intention_store.gd")
const DecisionRouter = preload("res://src/domain/cognition/decision_router.gd")
const PerceptionResult = preload("res://src/domain/cognition/perception_result.gd")
const SemanticChangeSet = preload("res://src/domain/world/semantic_change_set.gd")
const WorldCommitResult = preload("res://src/domain/world/world_commit_result.gd")
const DecisionCommitCoordinator = preload("res://src/application/simulation/decision_commit_coordinator.gd")
const SimulationOrchestrator = preload("res://src/application/simulation/simulation_orchestrator.gd")
const SimulationStepContext = preload("res://src/application/simulation/simulation_step_context.gd")
const WorldAdvanceResult = preload("res://src/application/simulation/world_advance_result.gd")

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
		return WorldCommitResult.new(true, [], [], [], SemanticChangeSet.new())


class DerivedInvalidatorStub:
	extends RefCounted
	func apply(_change_set):
		return {}


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


class IntentionExecutorStub:
	extends RefCounted
	var apply_count := 0
	var advance_count := 0
	var last_advanced = null

	func apply(_current_intention) -> Dictionary:
		apply_count += 1
		return {"handled": true, "reason": &"applied"}

	func advance(current_intention) -> Dictionary:
		advance_count += 1
		last_advanced = current_intention
		return {"handled": current_intention != null, "reason": &"advanced"}


func _init() -> void:
	_run_slice()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS intention_execution_progression_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL intention_execution_progression_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_slice() -> void:
	var intentions = CurrentIntentionStore.new()
	var target = RuntimeWorldRef.entity(DomainId.entity(&"food_1"))
	var bindings = RoleBinding.new()
	bindings.bind(&"target", target)
	var seek_food = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"seek_food")
	intentions.select(seek_food, bindings, &"selection_1")

	var executor = IntentionExecutorStub.new()
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
		null,
		null,
		null,
		null,
		[],
		null,
		null,
		null,
		null,
		null,
		executor
	)

	orchestrator.advance(SimulationStepContext.new(
		&"step_1",
		0.1,
		0.1,
		null,
		[]
	))

	_expect_equal(executor.advance_count, 1, "current intention executor advances once per semantic step")
	_expect_equal(executor.apply_count, 0, "executor apply is reserved for a newly committed intention")
	_expect_true(executor.last_advanced != null, "authoritative current intention is supplied to progression")
	if executor.last_advanced != null:
		_expect_equal(executor.last_advanced.intention_id.key(), seek_food.key(), "progression receives current semantic intention")
	_expect_equal(trace_sink.traces.size(), 1, "progression remains traceable")
	if trace_sink.traces.size() == 1:
		_expect_true(trace_sink.traces[0].stage_results.has(&"intention_execution_progression"), "trace records per-step intention execution progression")
		var progress = trace_sink.traces[0].stage_results[&"intention_execution_progression"]
		_expect_equal(progress.reason, &"advanced", "trace exposes executor progression result")

	_completed = true


func _expect_true(actual: bool, label: String) -> void:
	if not actual:
		_failures.append("Expected true: %s" % label)


func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
