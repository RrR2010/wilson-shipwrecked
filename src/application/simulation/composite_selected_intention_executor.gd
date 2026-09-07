class_name CompositeSelectedIntentionExecutor
extends RefCounted

## Deterministic composition boundary for intention executors.
##
## Delegates own the actual execution semantics and must return a Dictionary with
## `handled`. This compositor owns no gameplay policy: it simply asks authored
## delegates in stable construction order and returns the first handled result.

var _delegates: Array = []


func _init(p_delegates: Array) -> void:
	assert(not p_delegates.is_empty(), "CompositeSelectedIntentionExecutor requires delegates")
	for delegate in p_delegates:
		assert(delegate != null and delegate.has_method("apply"), "Intention executor delegates must implement apply()")
		assert(delegate.has_method("advance"), "Intention executor delegates must implement advance()")
		_delegates.append(delegate)


func apply(current_intention) -> Dictionary:
	return _dispatch(&"apply", current_intention)


func advance(current_intention) -> Dictionary:
	return _dispatch(&"advance", current_intention)


func _dispatch(method: StringName, current_intention) -> Dictionary:
	for delegate in _delegates:
		var result: Dictionary = delegate.call(method, current_intention)
		if bool(result.get("handled", false)):
			return result
	return {
		"handled": false,
		"started": false,
		"reason": &"not_handled",
	}
