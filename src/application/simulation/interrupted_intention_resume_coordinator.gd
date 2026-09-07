class_name InterruptedIntentionResumeCoordinator
extends RefCounted

## Ends an authored temporary interrupting intention and restores the previously
## suspended autonomous intention. This coordinator never chooses a new intention;
## it only restores Wilson-owned cognition that was explicitly suspended earlier.

var _intention_store
var _selected_intention_executor
var _interrupting_keys: Dictionary = {}


func _init(intention_store, selected_intention_executor, interrupting_intention_ids: Array) -> void:
	assert(intention_store != null, "InterruptedIntentionResumeCoordinator requires CurrentIntentionStore")
	assert(selected_intention_executor != null and selected_intention_executor.has_method("apply"), "InterruptedIntentionResumeCoordinator requires intention executor")
	_intention_store = intention_store
	_selected_intention_executor = selected_intention_executor
	for intention_id in interrupting_intention_ids:
		assert(intention_id != null, "interrupting intention ids cannot contain null")
		_interrupting_keys[String(intention_id.sort_key())] = true


func complete_and_resume() -> Dictionary:
	var current = _intention_store.current()
	if current == null:
		return _result(false, false, &"no_current_intention", null)
	if not _interrupting_keys.has(String(current.intention_id.sort_key())):
		return _result(false, false, &"current_intention_not_interrupting", null)
	if not _intention_store.has_suspended():
		return _result(true, false, &"no_suspended_intention", null)

	_intention_store.clear()
	var resume_result = _intention_store.resume_suspended()
	if not resume_result.ok:
		return _result(true, false, resume_result.code, null)
	var execution = _selected_intention_executor.apply(_intention_store.current())
	return _result(true, _execution_started(execution), execution.get("reason", &"resumed"), execution)


func _execution_started(execution: Dictionary) -> bool:
	if execution.has("moving"):
		return bool(execution["moving"])
	if execution.has("redirected"):
		return bool(execution["redirected"])
	return bool(execution.get("handled", false))


func _result(handled: bool, resumed: bool, reason: StringName, execution) -> Dictionary:
	return {
		"handled": handled,
		"resumed": resumed,
		"reason": reason,
		"execution": execution,
	}
