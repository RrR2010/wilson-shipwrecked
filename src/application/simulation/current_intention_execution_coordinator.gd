class_name CurrentIntentionExecutionCoordinator
extends RefCounted

## Re-applies the already-authoritative current intention to an outer execution
## adapter after bootstrap/restore. This coordinator owns no cognition state and
## does not select or mutate intentions.

var _activity_query
var _selected_intention_executor


func _init(activity_query, selected_intention_executor) -> void:
	assert(activity_query != null and activity_query.has_method("current_intention"), "CurrentIntentionExecutionCoordinator requires activity query")
	assert(selected_intention_executor != null and selected_intention_executor.has_method("apply"), "CurrentIntentionExecutionCoordinator requires intention executor")
	_activity_query = activity_query
	_selected_intention_executor = selected_intention_executor


func resume_current() -> Dictionary:
	var current = _activity_query.current_intention()
	if current == null:
		return {
			"handled": false,
			"resumed": false,
			"reason": &"no_current_intention",
		}
	var execution_result = _selected_intention_executor.apply(current)
	return {
		"handled": bool(execution_result.get("handled", false)),
		"resumed": _execution_started(execution_result),
		"reason": execution_result.get("reason", &"unknown"),
		"execution": execution_result,
	}


func _execution_started(execution_result: Dictionary) -> bool:
	if execution_result.has("moving"):
		return bool(execution_result["moving"])
	if execution_result.has("redirected"):
		return bool(execution_result["redirected"])
	return false
