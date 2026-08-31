class_name ObservedEvent
extends RefCounted

## Wilson-accessible projection of an authoritative WorldEvent.
## This object is not World truth and may omit roles/details the world knows.

var event_type: StringName
var action_id
var execution_id: StringName
var perceived_bindings: Dictionary
var modalities: Array[StringName]


func _init(
	p_event_type: StringName,
	p_action_id,
	p_execution_id: StringName,
	p_perceived_bindings: Dictionary,
	p_modalities: Array[StringName]
) -> void:
	assert(p_event_type != &"", "ObservedEvent requires event_type")
	assert(p_action_id != null, "ObservedEvent requires action_id")
	assert(p_execution_id != &"", "ObservedEvent requires execution_id")
	event_type = p_event_type
	action_id = p_action_id
	execution_id = p_execution_id
	perceived_bindings = p_perceived_bindings.duplicate()
	modalities = p_modalities.duplicate()
	modalities.sort_custom(func(a, b): return String(a) < String(b))
