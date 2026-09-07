extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RoleBinding = preload("res://src/domain/actions/role_binding.gd")
const ActionProgressResult = preload("res://src/domain/actions/action_progress_result.gd")
const BeliefStore = preload("res://src/domain/cognition/belief_store.gd")
const CurrentIntentionStore = preload("res://src/domain/cognition/current_intention_store.gd")
const DecisionCandidate = preload("res://src/domain/cognition/decision_candidate.gd")
const DecisionRouter = preload("res://src/domain/cognition/decision_router.gd")
const PerceptionResult = preload("res://src/domain/cognition/perception_result.gd")
const DecisionCommitCoordinator = preload("res://src/application/simulation/decision_commit_coordinator.gd")
const ReconsiderationGate = preload("res://src/application/simulation/reconsideration_gate.gd")
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

	var advance_count := 0

	func advance(execution_id: StringName, _elapsed: float):
		advance_count += 1
		if advance_count == 1:
			# A commit checkpoint may precede the terminal end of an action.
			return ActionProgressResult.new(execution_id, 0.6, true, false, null)
		return ActionProgressResult.new(execution_id, 1.0, true, true, null)


class WorldCommandsStub:
	extends RefCounted

	func apply_outcome(_outcome):
		return null


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
		return &"post_commit_tail"

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


class StaticCandidateSource:
	extends RefCounted

	var candidate

	func _init(p_candidate) -> void:
		candidate = p_candidate

	func generate() -> Array:
		return [candidate]


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
		print("PASS action_completion_reconsideration_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL action_completion_reconsideration_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_slice() -> void:
	var next_intention = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"next_activity")
	var candidate = DecisionCandidate.new(
		next_intention,
		RoleBinding.new(),
		DecisionCandidate.Scope.INTENTIONAL,
		0.5,
		0.0,
		0.0,
		0.0,
		0.0,
		{"source": "completion_regression"}
	)
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
		null,
		null,
		null,
		null,
		[StaticCandidateSource.new(candidate)]
	)

	var committed_tail = orchestrator.advance(SimulationStepContext.new(
		&"committed_but_not_completed",
		0.1,
		0.1,
		null,
		[]
	))
	_expect_true(committed_tail.action_progress.committed, "first fixture step is already committed")
	_expect_true(not committed_tail.action_progress.completed, "first fixture step remains in post-commit tail")
	_expect_equal(committed_tail.candidates.size(), 0, "commit alone does not open broad reconsideration")
	_expect_true(committed_tail.decision == null, "post-commit tail continues without a new decision")
	_expect_true(not intentions.has_current(), "commit alone does not synthesize a new intention")
	_expect_trace_trigger_absent(trace_sink, 0, ReconsiderationGate.Trigger.ACTION_OR_INTENTION_COMPLETION, "commit is not completion")

	var completed_action = orchestrator.advance(SimulationStepContext.new(
		&"completed_without_external_trigger",
		0.1,
		0.2,
		null,
		[]
	))
	_expect_true(completed_action.action_progress.completed, "second fixture step reaches terminal completion")
	_expect_equal(completed_action.candidates.size(), 1, "completion opens reconsideration without an external trigger")
	_expect_true(completed_action.decision != null and completed_action.decision.has_selection(), "completion-derived reconsideration routes candidate")
	_expect_true(intentions.has_current(), "completion-derived selection commits through intention owner")
	if intentions.has_current():
		_expect_equal(intentions.current().intention_id.key(), next_intention.key(), "next intention comes from ordinary competition")
	_expect_trace_trigger_present(trace_sink, 1, ReconsiderationGate.Trigger.ACTION_OR_INTENTION_COMPLETION, "terminal completion derives reconsideration")

	_completed = true


func _expect_trace_trigger_present(trace_sink, index: int, trigger: int, label: String) -> void:
	if trace_sink.traces.size() <= index:
		_failures.append("%s | trace index missing" % label)
		return
	var triggers: Array = trace_sink.traces[index].stage_results[&"reconsideration_triggers"]
	_expect_true(triggers.has(trigger), label)


func _expect_trace_trigger_absent(trace_sink, index: int, trigger: int, label: String) -> void:
	if trace_sink.traces.size() <= index:
		_failures.append("%s | trace index missing" % label)
		return
	var triggers: Array = trace_sink.traces[index].stage_results[&"reconsideration_triggers"]
	_expect_true(not triggers.has(trigger), label)


func _expect_true(actual: bool, label: String) -> void:
	if not actual:
		_failures.append("Expected true: %s" % label)


func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
