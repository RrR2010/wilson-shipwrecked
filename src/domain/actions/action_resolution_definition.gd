class_name ActionResolutionDefinition
extends RefCounted

## Deterministic resolution envelope for one action verb.
## `commit_fraction` marks the irreversible physical checkpoint.

var action_id
var duration: float
var commit_fraction: float
var effects: Array
var event_type: StringName


func _init(
	p_action_id,
	p_duration: float,
	p_commit_fraction: float,
	p_effects: Array,
	p_event_type: StringName
) -> void:
	assert(p_action_id != null, "ActionResolutionDefinition requires ActionId")
	assert(p_duration > 0.0, "ActionResolutionDefinition duration must be > 0")
	assert(p_commit_fraction >= 0.0 and p_commit_fraction <= 1.0, "commit_fraction must be within [0,1]")
	assert(p_event_type != &"", "ActionResolutionDefinition requires event_type")
	action_id = p_action_id
	duration = p_duration
	commit_fraction = p_commit_fraction
	effects = p_effects.duplicate()
	event_type = p_event_type
