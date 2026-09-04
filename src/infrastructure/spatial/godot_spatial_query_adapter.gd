class_name GodotSpatialQueryAdapter
extends "res://src/application/simulation/spatial_query_port.gd"

const SceneSpatialRegistry = preload("res://src/infrastructure/spatial/godot_scene_spatial_registry.gd")

## Godot-backed implementation of semantic spatial queries.
##
## The adapter resolves stable runtime refs through GodotSceneSpatialRegistry and may
## delegate route/visibility work to NavigationServer3D and PhysicsDirectSpaceState3D.

var registry: SceneSpatialRegistry
var navigation_map: RID = RID()
var physics_space_state: PhysicsDirectSpaceState3D
var interaction_reach_distance: float = 1.5

func _init(p_registry: SceneSpatialRegistry) -> void:
	assert(p_registry != null)
	registry = p_registry

func metric_distance(from_ref: RuntimeWorldRef, to_ref: RuntimeWorldRef) -> float:
	var from_node: Node3D = registry.resolve(from_ref)
	var to_node: Node3D = registry.resolve(to_ref)
	if from_node == null or to_node == null:
		return INF
	return from_node.global_position.distance_to(to_node.global_position)

func has_route(from_ref: RuntimeWorldRef, to_ref: RuntimeWorldRef) -> bool:
	return not _route_points(from_ref, to_ref).is_empty()

func route_cost(from_ref: RuntimeWorldRef, to_ref: RuntimeWorldRef) -> float:
	var points: PackedVector3Array = _route_points(from_ref, to_ref)
	if points.is_empty():
		return INF
	var cost := 0.0
	for index in range(1, points.size()):
		cost += points[index - 1].distance_to(points[index])
	return cost

func has_line_of_sight(observer_ref: RuntimeWorldRef, target_ref: RuntimeWorldRef) -> bool:
	if physics_space_state == null:
		return false
	var observer: Node3D = registry.resolve(observer_ref)
	var target: Node3D = registry.resolve(target_ref)
	if observer == null or target == null:
		return false
	var query := PhysicsRayQueryParameters3D.create(observer.global_position, target.global_position)
	_exclude_collision_subject(query, observer)
	var hit := physics_space_state.intersect_ray(query)
	if hit.is_empty():
		return true
	var collider = hit.get("collider")
	return collider is Node and _matches_spatial_subject(collider as Node, target)

func is_interaction_reachable(actor_ref: RuntimeWorldRef, target_ref: RuntimeWorldRef, interaction_id: StringName = &"") -> bool:
	var actor: Node3D = registry.resolve(actor_ref)
	var anchor: Node3D = registry.resolve_anchor(target_ref, interaction_id)
	if actor == null or anchor == null:
		return false
	if actor.global_position.distance_to(anchor.global_position) > interaction_reach_distance:
		return false
	if physics_space_state == null:
		return true
	var query := PhysicsRayQueryParameters3D.create(actor.global_position, anchor.global_position)
	_exclude_collision_subject(query, actor)
	var hit := physics_space_state.intersect_ray(query)
	if hit.is_empty():
		return true
	var collider = hit.get("collider")
	return collider is Node and _matches_spatial_subject(collider as Node, anchor)

func _route_points(from_ref: RuntimeWorldRef, to_ref: RuntimeWorldRef) -> PackedVector3Array:
	if not navigation_map.is_valid():
		return PackedVector3Array()
	var from_node: Node3D = registry.resolve(from_ref)
	var to_node: Node3D = registry.resolve(to_ref)
	if from_node == null or to_node == null:
		return PackedVector3Array()
	return NavigationServer3D.map_get_path(
		navigation_map,
		from_node.global_position,
		to_node.global_position,
		true
	)

func _exclude_collision_subject(query: PhysicsRayQueryParameters3D, subject: Node) -> void:
	var collision_root: CollisionObject3D = _nearest_collision_ancestor(subject)
	if collision_root == null:
		return
	var exclusions: Array[RID] = []
	_collect_collision_rids(collision_root, exclusions)
	query.exclude = exclusions

func _nearest_collision_ancestor(node: Node) -> CollisionObject3D:
	var current: Node = node
	while current != null:
		if current is CollisionObject3D:
			return current as CollisionObject3D
		current = current.get_parent()
	return null

func _collect_collision_rids(node: Node, output: Array[RID]) -> void:
	if node is CollisionObject3D:
		output.append((node as CollisionObject3D).get_rid())
	for child in node.get_children():
		_collect_collision_rids(child, output)

func _matches_spatial_subject(candidate: Node, expected: Node) -> bool:
	if _is_same_or_descendant(candidate, expected):
		return true
	var expected_collision_root: CollisionObject3D = _nearest_collision_ancestor(expected)
	return expected_collision_root != null and _is_same_or_descendant(candidate, expected_collision_root)

func _is_same_or_descendant(candidate: Node, expected_root: Node) -> bool:
	var current: Node = candidate
	while current != null:
		if current == expected_root:
			return true
		current = current.get_parent()
	return false
