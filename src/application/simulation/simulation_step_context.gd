class_name SimulationStepContext
extends RefCounted

## Immutable-by-convention input envelope for one authoritative simulation step.
## Keep this small: do not turn it into a bag containing every store in the game.

var step_id
var elapsed: float
var simulation_time: float
var random_streams
var trigger_set


func _init(
	p_step_id,
	p_elapsed: float,
	p_simulation_time: float,
	p_random_streams,
	p_trigger_set
) -> void:
	step_id = p_step_id
	elapsed = p_elapsed
	simulation_time = p_simulation_time
	random_streams = p_random_streams
	trigger_set = p_trigger_set
