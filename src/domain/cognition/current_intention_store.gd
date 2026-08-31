class_name CurrentIntentionStore
extends RefCounted

const MutationResult = preload("res://src/domain/core/mutation_result.gd")
const CurrentIntentionState = preload("res://src/domain/cognition/current_intention_state.gd")

## Wilson cognition owner for the currently committed intention.

var _current = null


func current():
	return _current


func has_current() -> bool:
	return _current != null


func select(intention_id, bindings, selected_step_id: StringName):
	_current = CurrentIntentionState.new(intention_id, bindings, selected_step_id)
	return MutationResult.success(&"current_intention_selected", _current)


func clear():
	var previous = _current
	_current = null
	return MutationResult.success(&"current_intention_cleared", previous)
