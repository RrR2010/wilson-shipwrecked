class_name SimulationActivityQuery
extends RefCounted

## Narrow read port exposing only orchestration-relevant current activity.
## Durable intention/action ownership remains outside the orchestrator.

func active_execution_id() -> StringName:
	return &""


func current_intention():
	return null
