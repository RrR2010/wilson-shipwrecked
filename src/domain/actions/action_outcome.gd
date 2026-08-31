class_name ActionOutcome
extends RefCounted

const DomainId = preload("res://src/domain/core/domain_id.gd")

## Immutable committed semantic result emitted by ActionExecution.
## Effects are proposals for the owning World command port; no mutation occurs here.

var execution_id: StringName
var action_id
var bindings
var effects: Array
var event_type


func _init(
	p_execution_id: StringName,
	p_action_id,
	p_bindings,
	p_effects: Array,
	p_event_type
) -> void:
	assert(p_execution_id != &"", "ActionOutcome requires execution id")
	assert(p_action_id != null, "ActionOutcome requires action id")
	assert(p_bindings != null, "ActionOutcome requires bindings")
	assert(p_bindings.has_method("duplicate_binding"), "ActionOutcome bindings must support snapshot duplication")
	assert(p_event_type != null, "ActionOutcome requires EventDefinitionId")
	assert(p_event_type is Object and p_event_type.has_method("assert_kind"), "event_type must be EventDefinitionId")
	p_event_type.assert_kind(DomainId.Kind.EVENT_DEFINITION)
	execution_id = p_execution_id
	action_id = p_action_id
	bindings = p_bindings.duplicate_binding()
	effects = p_effects.duplicate()
	event_type = p_event_type
