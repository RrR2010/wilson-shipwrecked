class_name SimulationStepResult
extends RefCounted

## Structured output from one orchestrated simulation step.
## This is intentionally explicit rather than a generic Dictionary so headless
## regression code can inspect each stage independently.

var step_id
var world_advance
var action_progress
var perception
var immediate_learning
var decision
var owner_commands


func _init(
	p_step_id,
	p_world_advance,
	p_action_progress,
	p_perception,
	p_immediate_learning,
	p_decision,
	p_owner_commands
) -> void:
	step_id = p_step_id
	world_advance = p_world_advance
	action_progress = p_action_progress
	perception = p_perception
	immediate_learning = p_immediate_learning
	decision = p_decision
	owner_commands = p_owner_commands
