class_name CurrentIntentionStore
extends RefCounted

const MutationResult = preload("res://src/domain/core/mutation_result.gd")
const CurrentIntentionState = preload("res://src/domain/cognition/current_intention_state.gd")

## Wilson cognition owner for the currently committed intention.
## A single suspended intention preserves autonomous continuity across a temporary
## authored interruption such as an immediate defensive response.

var _current = null
var _suspended = null


func current():
	return _current


func has_current() -> bool:
	return _current != null


func suspended():
	return _suspended


func has_suspended() -> bool:
	return _suspended != null


func select(intention_id, bindings, selected_step_id: StringName):
	_current = CurrentIntentionState.new(intention_id, bindings, selected_step_id)
	return MutationResult.success(&"current_intention_selected", _current)


func suspend_current():
	if _current == null:
		return MutationResult.failure(&"no_current_intention", ["No current intention is available to suspend"])
	if _suspended != null:
		return MutationResult.failure(&"suspended_intention_occupied", ["A suspended intention already exists"])
	_suspended = _current
	_current = null
	return MutationResult.success(&"current_intention_suspended", _suspended)


func resume_suspended():
	if _current != null:
		return MutationResult.failure(&"current_intention_occupied", ["Current intention must be empty before resuming"])
	if _suspended == null:
		return MutationResult.failure(&"no_suspended_intention", ["No suspended intention is available to resume"])
	_current = _suspended
	_suspended = null
	return MutationResult.success(&"suspended_intention_resumed", _current)


func clear():
	var previous = _current
	_current = null
	return MutationResult.success(&"current_intention_cleared", previous)


func clear_suspended():
	var previous = _suspended
	_suspended = null
	return MutationResult.success(&"suspended_intention_cleared", previous)
