class_name ActorStateStore
extends RefCounted

var _states: Dictionary = {}


func add(state) -> bool:
	assert(state != null, "ActorStateStore.add requires state")
	var key: String = state.actor.sort_key()
	if _states.has(key):
		return false
	_states[key] = state
	return true


func get_state(actor):
	assert(actor != null, "ActorStateStore.get_state requires actor")
	return _states.get(actor.sort_key())


func states() -> Array:
	var result: Array = _states.values()
	result.sort_custom(func(a, b): return a.actor.sort_key() < b.actor.sort_key())
	return result
