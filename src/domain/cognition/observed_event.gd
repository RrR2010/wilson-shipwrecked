class_name ObservedEvent
extends RefCounted

const DomainId = preload("res://src/domain/core/domain_id.gd")

## Wilson-accessible projection of an authoritative WorldEvent.
## This object is not World truth and may omit roles/details the world knows.
## `action_id` is optional because authoritative events can originate outside actions.

var event_type
var action_id
var execution_id: StringName
var perceived_bindings: Dictionary
var modalities: Array[StringName]


func _init(
	p_event_type,
	p_action_id,
	p_execution_id: StringName,
	p_perceived_bindings: Dictionary,
	p_modalities: Array[StringName]
) -> void:
	assert(p_event_type != null, "ObservedEvent requires event_type")
	assert(p_event_type is Object and p_event_type.has_method("assert_kind"), "ObservedEvent event_type must be EventDefinitionId")
	p_event_type.assert_kind(DomainId.Kind.EVENT_DEFINITION)
	assert(p_execution_id != &"", "ObservedEvent requires occurrence id")
	event_type = p_event_type
	action_id = p_action_id
	execution_id = p_execution_id
	perceived_bindings = p_perceived_bindings.duplicate()
	modalities = p_modalities.duplicate()
	modalities.sort_custom(func(a, b): return String(a) < String(b))
