extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const MutationResult = preload("res://src/domain/core/mutation_result.gd")
const InterruptingDecisionCommitCoordinator = preload("res://src/application/simulation/interrupting_decision_commit_coordinator.gd")

var _failures: Array[String] = []


class BindingStub:
	extends RefCounted
	var key: String
	func _init(p_key: String) -> void:
		key = p_key
	func stable_key() -> String:
		return key


class IntentionStub:
	extends RefCounted
	var intention_id
	var bindings
	var selected_step_id: StringName
	func _init(p_intention_id, p_bindings, p_selected_step_id: StringName = &"current_step") -> void:
		intention_id = p_intention_id
		bindings = p_bindings
		selected_step_id = p_selected_step_id


class CandidateStub:
	extends RefCounted
	var intention_id
	var bindings
	func _init(p_intention_id, p_bindings) -> void:
		intention_id = p_intention_id
		bindings = p_bindings


class DecisionStub:
	extends RefCounted
	var selected_candidate
	func _init(p_candidate) -> void:
		selected_candidate = p_candidate
	func has_selection() -> bool:
		return selected_candidate != null


class ActivityStub:
	extends RefCounted
	var current
	var execution_id: StringName
	func _init(p_current, p_execution_id: StringName) -> void:
		current = p_current
		execution_id = p_execution_id
	func current_intention():
		return current
	func active_execution_id() -> StringName:
		return execution_id


class ActionExecutionStub:
	extends RefCounted
	var interruptible := true
	var interrupted: Array[StringName] = []
	func can_interrupt(_execution_id: StringName) -> bool:
		return interruptible
	func interrupt(execution_id: StringName) -> bool:
		if not interruptible:
			return false
		interrupted.append(execution_id)
		return true


class CommitStub:
	extends RefCounted
	var calls := 0
	func apply(_decision_result, _step_id: StringName):
		calls += 1
		return MutationResult.success(&"committed")


func _init() -> void:
	_run()
	if _failures.is_empty():
		print("PASS interrupting_decision_commit_coordinator_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL interrupting_decision_commit_coordinator_test: %d failure(s)" % _failures.size())
	quit(1)


func _run() -> void:
	var project = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"continue_project")
	var cover = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"seek_cover")
	var target_a = BindingStub.new("target=A")
	var target_b = BindingStub.new("target=B")

	var actions = ActionExecutionStub.new()
	var commit = CommitStub.new()
	var coordinator = InterruptingDecisionCommitCoordinator.new(
		ActivityStub.new(IntentionStub.new(project, target_a), &"project_exec"),
		actions,
		commit
	)
	var result = coordinator.apply(DecisionStub.new(CandidateStub.new(cover, target_a)), &"weather_step")
	_expect_true(result != null and result.ok, "interruptible execution permits intention replacement")
	_expect_equal(actions.interrupted, [&"project_exec"], "active execution interrupts before replacement")
	_expect_equal(commit.calls, 1, "wrapped intention commit runs after interruption")

	var same_actions = ActionExecutionStub.new()
	var same_commit = CommitStub.new()
	var current_same = IntentionStub.new(project, target_a, &"original_step")
	var same = InterruptingDecisionCommitCoordinator.new(
		ActivityStub.new(current_same, &"project_exec_2"),
		same_actions,
		same_commit
	)
	var same_result = same.apply(DecisionStub.new(CandidateStub.new(project, target_a)), &"reconsider_step")
	_expect_true(same_result != null and same_result.ok, "same semantic intention continues while action is active")
	_expect_equal(same_result.code, &"current_intention_continued", "active same intention reports continuity")
	_expect_true(same_result.value == current_same, "continuity preserves current intention identity and selected step")
	_expect_true(same_actions.interrupted.is_empty(), "same active intention leaves execution untouched")
	_expect_equal(same_commit.calls, 0, "same active intention does not mint a fresh commitment")

	var cycle_actions = ActionExecutionStub.new()
	var cycle_commit = CommitStub.new()
	var cycle = InterruptingDecisionCommitCoordinator.new(
		ActivityStub.new(IntentionStub.new(project, target_a, &"completed_action_step"), &""),
		cycle_actions,
		cycle_commit
	)
	var cycle_result = cycle.apply(DecisionStub.new(CandidateStub.new(project, target_a)), &"next_action_step")
	_expect_true(cycle_result != null and cycle_result.ok, "same semantic intention may recommit after prior action becomes terminal")
	_expect_equal(cycle_result.code, &"committed", "completed action cycle reaches wrapped commit")
	_expect_true(cycle_actions.interrupted.is_empty(), "terminal prior action requires no interruption")
	_expect_equal(cycle_commit.calls, 1, "same intention gets a fresh selected step for the next repeated action")

	var retarget_actions = ActionExecutionStub.new()
	var retarget_commit = CommitStub.new()
	var retarget = InterruptingDecisionCommitCoordinator.new(
		ActivityStub.new(IntentionStub.new(project, target_a), &"project_exec_3"),
		retarget_actions,
		retarget_commit
	)
	var retarget_result = retarget.apply(DecisionStub.new(CandidateStub.new(project, target_b)), &"retarget_step")
	_expect_true(retarget_result != null and retarget_result.ok, "same intention with different bindings is a replacement")
	_expect_equal(retarget_actions.interrupted, [&"project_exec_3"], "retarget interrupts old execution")
	_expect_equal(retarget_commit.calls, 1, "retarget commits a fresh intention state")

	var blocked_actions = ActionExecutionStub.new()
	blocked_actions.interruptible = false
	var blocked_commit = CommitStub.new()
	var blocked = InterruptingDecisionCommitCoordinator.new(
		ActivityStub.new(IntentionStub.new(project, target_a), &"uninterruptible_exec"),
		blocked_actions,
		blocked_commit
	)
	var blocked_result = blocked.apply(DecisionStub.new(CandidateStub.new(cover, target_a)), &"blocked_step")
	_expect_true(blocked_result != null and not blocked_result.ok, "uninterruptible execution refuses replacement")
	_expect_equal(blocked_result.code, &"active_execution_not_interruptible", "refusal remains explicit")
	_expect_equal(blocked_commit.calls, 0, "refused replacement does not mutate current intention")


func _expect_true(actual: bool, label: String) -> void:
	if not actual:
		_failures.append("Expected true: %s" % label)


func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
