class_name InterruptingDecisionCommitCoordinator
extends RefCounted

const MutationResult = preload("res://src/domain/core/mutation_result.gd")

## Coordinates an already-selected intention replacement with the actor's current
## ActionExecution. Cognition still owns selection and the wrapped commit service
## still owns CurrentIntentionStore mutation; this bridge only prevents a replaced
## intention from leaving a second active execution behind.
##
## Reconsidering into the exact same semantic intention + bindings while an action
## is still active is continuity, not a fresh commitment. Once that action becomes
## terminal, active_execution_id() is empty and the same semantic intention may be
## committed again with a fresh selected_step_id so a repeated action cycle can
## begin without forking concurrent executions.
##
## Grounded intention completion may clear CurrentIntention at an action's commit
## point while that action still has an active post-commit tail. Such an execution
## is still actor activity and must be interrupted (when permitted) before a fresh
## intention is committed; otherwise two actor-bound actions can overlap.

var _activity_query
var _action_execution
var _decision_commit


func _init(activity_query, action_execution, decision_commit) -> void:
	assert(activity_query != null and activity_query.has_method("active_execution_id"), "Interrupting decision commit requires activity query")
	assert(activity_query.has_method("current_intention"), "Interrupting decision commit requires current intention query")
	assert(action_execution != null and action_execution.has_method("can_interrupt"), "Interrupting decision commit requires ActionExecutionService")
	assert(action_execution.has_method("interrupt"), "Interrupting decision commit requires action interruption")
	assert(decision_commit != null and decision_commit.has_method("apply"), "Interrupting decision commit requires wrapped commit coordinator")
	_activity_query = activity_query
	_action_execution = action_execution
	_decision_commit = decision_commit


func apply(decision_result, step_id: StringName):
	assert(decision_result != null, "apply requires DecisionSelectionResult")
	if not decision_result.has_selection():
		return null

	var current = _activity_query.current_intention()
	var selected = decision_result.selected_candidate
	var execution_id: StringName = _activity_query.active_execution_id()

	if current != null and _same_intention_state(current, selected):
		if execution_id != &"":
			return MutationResult.success(&"current_intention_continued", current)
		return _decision_commit.apply(decision_result, step_id)

	# An active execution remains authoritative actor activity even if grounded
	# completion already cleared CurrentIntention at its commit point. Any fresh
	# commitment must therefore terminate the old execution first unless the exact
	# same current intention was recognized as continuity above.
	if execution_id != &"":
		if not _action_execution.can_interrupt(execution_id):
			return MutationResult.failure(
				&"active_execution_not_interruptible",
				["Cannot commit replacement while execution %s is not interruptible" % String(execution_id)] as Array[String]
			)
		if not _action_execution.interrupt(execution_id):
			return MutationResult.failure(
				&"active_execution_interruption_failed",
				["Failed to interrupt execution %s before intention replacement" % String(execution_id)] as Array[String]
			)

	return _decision_commit.apply(decision_result, step_id)


func _same_intention_state(current, selected) -> bool:
	if current == null or selected == null:
		return false
	if current.intention_id == null or selected.intention_id == null:
		return false
	if not current.intention_id.equals(selected.intention_id):
		return false
	if current.bindings == null or selected.bindings == null:
		return current.bindings == selected.bindings
	return current.bindings.stable_key() == selected.bindings.stable_key()
