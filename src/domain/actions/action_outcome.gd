class_name ActionOutcome
extends RefCounted

## Immutable committed semantic result emitted by ActionExecution.
## Effects are proposals for the owning World command port; no mutation occurs here.

var execution_id: StringName
var action_id
var bindings
var effects: Array
var event_type: StringName


func _init(
	p_execution_id: StringName,
	p_action_id,
	p_bindings,
	p_effects: Array,
	p_event_type: StringName
) -> void:
	assert(p_execution_id != &"", "ActionOutcome requires execution id")
	assert(p_action_id != null, "ActionOutcome requires action id")
	assert(p_bindings != null, "ActionOutcome requires bindings")
	assert(p_event_type != &"", "ActionOutcome requires event type")
	execution_id = p_execution_id
	action_id = p_action_id
	bindings = p_bindings
	effects = p_effects.duplicate()
	event_type = p_event_type
