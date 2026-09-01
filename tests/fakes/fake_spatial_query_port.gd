class_name FakeSpatialQueryPort
extends SpatialQueryPort

const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")

var _distance_by_pair: Dictionary = {}
var _route_by_pair: Dictionary = {}
var _route_cost_by_pair: Dictionary = {}
var _line_of_sight_by_pair: Dictionary = {}
var _interaction_reachable_by_pair: Dictionary = {}

func set_distance(from_ref: RuntimeWorldRef, to_ref: RuntimeWorldRef, value: float) -> void:
	_distance_by_pair[_pair_key(from_ref, to_ref)] = value

func set_route(from_ref: RuntimeWorldRef, to_ref: RuntimeWorldRef, available: bool, cost: float = INF) -> void:
	var key := _pair_key(from_ref, to_ref)
	_route_by_pair[key] = available
	_route_cost_by_pair[key] = cost

func set_line_of_sight(observer_ref: RuntimeWorldRef, target_ref: RuntimeWorldRef, visible: bool) -> void:
	_line_of_sight_by_pair[_pair_key(observer_ref, target_ref)] = visible

func set_interaction_reachable(actor_ref: RuntimeWorldRef, target_ref: RuntimeWorldRef, interaction_id: StringName, reachable: bool) -> void:
	_interaction_reachable_by_pair[_triple_key(actor_ref, target_ref, interaction_id)] = reachable

func metric_distance(from_ref: RuntimeWorldRef, to_ref: RuntimeWorldRef) -> float:
	return float(_distance_by_pair.get(_pair_key(from_ref, to_ref), INF))

func has_route(from_ref: RuntimeWorldRef, to_ref: RuntimeWorldRef) -> bool:
	return bool(_route_by_pair.get(_pair_key(from_ref, to_ref), false))

func route_cost(from_ref: RuntimeWorldRef, to_ref: RuntimeWorldRef) -> float:
	return float(_route_cost_by_pair.get(_pair_key(from_ref, to_ref), INF))

func has_line_of_sight(observer_ref: RuntimeWorldRef, target_ref: RuntimeWorldRef) -> bool:
	return bool(_line_of_sight_by_pair.get(_pair_key(observer_ref, target_ref), false))

func is_interaction_reachable(actor_ref: RuntimeWorldRef, target_ref: RuntimeWorldRef, interaction_id: StringName = &"") -> bool:
	return bool(_interaction_reachable_by_pair.get(_triple_key(actor_ref, target_ref, interaction_id), false))

func _pair_key(a: RuntimeWorldRef, b: RuntimeWorldRef) -> String:
	return "%s|%s" % [a.key(), b.key()]

func _triple_key(a: RuntimeWorldRef, b: RuntimeWorldRef, c: StringName) -> String:
	return "%s|%s|%s" % [a.key(), b.key(), c]
