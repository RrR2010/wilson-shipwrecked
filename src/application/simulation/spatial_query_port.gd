class_name SpatialQueryPort
extends RefCounted

## Abstract spatial query boundary used by authoritative simulation.
##
## Implementations may delegate to Godot navigation/physics or deterministic test doubles.
## Domain/application callers receive semantic answers and never depend on scene nodes.

func metric_distance(_from_ref: StringName, _to_ref: StringName) -> float:
	push_error("SpatialQueryPort.metric_distance() is abstract")
	return INF

func has_route(_from_ref: StringName, _to_ref: StringName) -> bool:
	push_error("SpatialQueryPort.has_route() is abstract")
	return false

func route_cost(_from_ref: StringName, _to_ref: StringName) -> float:
	push_error("SpatialQueryPort.route_cost() is abstract")
	return INF

func has_line_of_sight(_observer_ref: StringName, _target_ref: StringName) -> bool:
	push_error("SpatialQueryPort.has_line_of_sight() is abstract")
	return false

func is_interaction_reachable(_actor_ref: StringName, _target_ref: StringName, _interaction_id: StringName = &"") -> bool:
	push_error("SpatialQueryPort.is_interaction_reachable() is abstract")
	return false
