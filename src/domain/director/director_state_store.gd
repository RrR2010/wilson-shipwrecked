class_name DirectorStateStore
extends RefCounted

const DirectorOpportunityState = preload("res://src/domain/director/director_opportunity_state.gd")

var _states: Dictionary = {}

func add(state: DirectorOpportunityState) -> bool:
	if _states.has(state.definition_id):
		return false
	_states[state.definition_id] = state
	return true

func get_state(definition_id: StringName):
	return _states.get(definition_id)

func states() -> Array:
	var result: Array = _states.values()
	result.sort_custom(func(a, b): return String(a.definition_id) < String(b.definition_id))
	return result
