class_name SimulationStepResult
extends RefCounted

## Structured output from one orchestrated simulation step.
## Explicit stages keep headless regressions and traces inspectable.

var step_id
var world_advance
var action_progress
var perception
var immediate_learning
var candidates: Array
var decision
var world_commit


func _init(
	p_step_id,
	p_world_advance,
	p_action_progress,
	p_perception,
	p_immediate_learning,
	p_candidates: Array,
	p_decision,
	p_world_commit
) -> void:
	step_id = p_step_id
	world_advance = p_world_advance
	action_progress = p_action_progress
	perception = p_perception
	immediate_learning = p_immediate_learning
	candidates = p_candidates.duplicate()
	decision = p_decision
	world_commit = p_world_commit
