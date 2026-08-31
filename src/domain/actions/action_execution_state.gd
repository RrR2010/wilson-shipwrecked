class_name ActionExecutionState
extends RefCounted

## Durable-in-owner execution state for one action lifecycle.

var execution_id: StringName
var action_definition
var resolution_definition
var bindings
var elapsed: float = 0.0
var committed: bool = false
var completed: bool = false
var interrupted: bool = false
var outcome_emitted: bool = false


func _init(p_execution_id: StringName, p_action_definition, p_resolution_definition, p_bindings) -> void:
	assert(p_execution_id != &"", "ActionExecutionState requires execution id")
	assert(p_action_definition != null, "ActionExecutionState requires action definition")
	assert(p_resolution_definition != null, "ActionExecutionState requires resolution definition")
	assert(p_bindings != null, "ActionExecutionState requires bindings")
	assert(p_resolution_definition.action_id.equals(p_action_definition.id), "Resolution action id must match ActionDefinition")
	execution_id = p_execution_id
	action_definition = p_action_definition
	resolution_definition = p_resolution_definition
	bindings = p_bindings


func is_terminal() -> bool:
	return completed or interrupted


func is_active() -> bool:
	return not is_terminal()
