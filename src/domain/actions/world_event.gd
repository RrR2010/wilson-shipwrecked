class_name WorldEvent
extends RefCounted

## Semantic fact emitted only after authoritative mutation commits.

var event_type: StringName
var action_id
var bindings
var execution_id: StringName


func _init(p_event_type: StringName, p_action_id, p_bindings, p_execution_id: StringName) -> void:
	assert(p_event_type != &"", "WorldEvent requires event_type")
	assert(p_action_id != null, "WorldEvent requires action id")
	assert(p_bindings != null, "WorldEvent requires bindings")
	assert(p_execution_id != &"", "WorldEvent requires execution id")
	event_type = p_event_type
	action_id = p_action_id
	bindings = p_bindings
	execution_id = p_execution_id
