class_name WorldEvent
extends RefCounted

const DomainId = preload("res://src/domain/core/domain_id.gd")

## Semantic fact emitted only after authoritative mutation commits.

var event_type
var action_id
var bindings
var execution_id: StringName


func _init(p_event_type, p_action_id, p_bindings, p_execution_id: StringName) -> void:
	assert(p_event_type != null, "WorldEvent requires event_type")
	assert(p_action_id != null, "WorldEvent requires action id")
	assert(p_bindings != null, "WorldEvent requires bindings")
	assert(p_bindings.has_method("duplicate_binding"), "WorldEvent bindings must support snapshot duplication")
	assert(p_execution_id != &"", "WorldEvent requires execution id")
	event_type = _normalize_event_type(p_event_type)
	action_id = p_action_id
	bindings = p_bindings.duplicate_binding()
	execution_id = p_execution_id


func _normalize_event_type(value):
	if value is StringName:
		assert(value != &"", "WorldEvent event_type cannot be empty")
		return DomainId.event_definition(value)
	assert(value is Object and value.has_method("assert_kind"), "event_type must be EventDefinitionId or StringName")
	value.assert_kind(DomainId.Kind.EVENT_DEFINITION)
	return value
