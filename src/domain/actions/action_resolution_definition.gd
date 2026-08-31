class_name ActionResolutionDefinition
extends RefCounted

const DomainId = preload("res://src/domain/core/domain_id.gd")

## Deterministic authored resolution envelope for one action form.
## `definition_id` is stable content identity used by reconstruction; it is not
## runtime execution identity. `commit_fraction` marks the irreversible physical
## checkpoint.

var definition_id: StringName
var action_id
var duration: float
var commit_fraction: float
var effects: Array
var event_type


func _init(
	p_action_id,
	p_duration: float,
	p_commit_fraction: float,
	p_effects: Array,
	p_event_type,
	p_definition_id: StringName = &""
) -> void:
	assert(p_action_id != null, "ActionResolutionDefinition requires ActionId")
	assert(p_duration > 0.0, "ActionResolutionDefinition duration must be > 0")
	assert(p_commit_fraction >= 0.0 and p_commit_fraction <= 1.0, "commit_fraction must be within [0,1]")
	assert(p_event_type != null, "ActionResolutionDefinition requires EventDefinitionId")
	assert(p_event_type is Object and p_event_type.has_method("assert_kind"), "event_type must be EventDefinitionId")
	p_event_type.assert_kind(DomainId.Kind.EVENT_DEFINITION)
	action_id = p_action_id
	duration = p_duration
	commit_fraction = p_commit_fraction
	effects = p_effects.duplicate()
	event_type = p_event_type
	definition_id = p_definition_id
	if definition_id == &"":
		definition_id = StringName("%s_default" % String(action_id.value))
