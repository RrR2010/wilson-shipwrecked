extends Node3D

## Smoke test: Spatial / Navigation / Perception
## Proves: import, collision, navigation, broadphase overlap, LOS

@onready var wilson_body: CharacterBody3D = $Wilson
@onready var wilson_agent: NavigationAgent3D = $Wilson/NavigationAgent3D
@onready var perception_area: Area3D = $Wilson/PerceptionArea
@onready var target_marker: Node3D = $TargetMarker
@onready var perceptible: StaticBody3D = $PerceptibleObject

var _moving := false
var _test_log: PackedStringArray = []


func _ready() -> void:
	_log("=== SPATIAL/NAV/PERCEPTION SMOKE START ===")
	_log("Wilson pos: %s" % str(wilson_body.global_position))
	_log("Target pos: %s" % str(target_marker.global_position))
	_log("Wall pos:  %s" % str($NavigationRegion3D/Wall.global_position))
	_log("Perceptible pos: %s" % str(perceptible.global_position))
	_check_import()
	_check_collision()
	_check_navigation()
	_request_movement()


func _check_import() -> void:
	_log("--- Stage 1: Import ---")
	var wilson_vis = $Wilson/Visual
	if wilson_vis and wilson_vis.get_child_count() > 0:
		_log("  Wilson visual: OK (children=%d)" % wilson_vis.get_child_count())
	else:
		_log("  Wilson visual: MISSING or EMPTY")
	var wall_vis = $NavigationRegion3D/Wall/Visual
	if wall_vis and wall_vis.get_child_count() > 0:
		_log("  Wall visual: OK")
	else:
		_log("  Wall visual: MISSING")


func _check_collision() -> void:
	_log("--- Stage 2: Collision ---")
	_log("  Wilson body: %s" % str(wilson_body))
	_log("  Wilson position: %s" % str(wilson_body.global_position))
	_log("  Wilson is_on_floor: %s" % str(wilson_body.is_on_floor()))
	await get_tree().physics_frame
	await get_tree().physics_frame
	_log("  Wilson is_on_floor (after 2 frames): %s" % str(wilson_body.is_on_floor()))


func _check_detour(path: PackedVector3Array) -> bool:
	for p in path:
		if abs(p.x) > 1.0:
			return true
	return false


func _check_navigation() -> void:
	_log("--- Stage 3: Navigation ---")
	var nav_map_rid = wilson_body.get_world_3d().navigation_map
	_log("  Navigation map valid: %s" % str(nav_map_rid.is_valid()))
	_log("  Wilson global pos: %s" % str(wilson_body.global_position))
	_log("  Target global pos: %s" % str(target_marker.global_position))
	# Check closest point on navmesh
	var wilson_closest = NavigationServer3D.map_get_closest_point(nav_map_rid, wilson_body.global_position)
	var target_closest = NavigationServer3D.map_get_closest_point(nav_map_rid, target_marker.global_position)
	_log("  NavMesh closest to Wilson: %s (dist=%.2f)" % [str(wilson_closest), wilson_body.global_position.distance_to(wilson_closest)])
	_log("  NavMesh closest to Target: %s (dist=%.2f)" % [str(target_closest), target_marker.global_position.distance_to(target_closest)])
	# Check if there's a route using NavigationServer directly
	var path = NavigationServer3D.map_get_path(nav_map_rid, wilson_body.global_position, target_marker.global_position, true)
	_log("  Direct map_get_path: %d points" % path.size())
	if path.size() > 0:
		_log("  Direct path first: %s" % str(path[0]))
		_log("  Direct path last: %s" % str(path[-1]))
	wilson_agent.target_position = target_marker.global_position
	var _next = wilson_agent.get_next_path_position()
	_log("  Agent get_next_path_position: %s" % str(_next))
	await get_tree().physics_frame
	await get_tree().physics_frame
	var agent_path = wilson_agent.get_current_navigation_path()
	_log("  Agent path length: %d points" % agent_path.size())
	if agent_path.size() > 0:
		_log("  Agent first point: %s" % str(agent_path[0]))
		_log("  Agent detours around wall: %s" % str(_check_detour(agent_path)))
	else:
		_log("  Agent final_position: %s" % str(wilson_agent.get_final_position()))


func _request_movement() -> void:
	_log("--- Stage 4: Movement ---")
	_moving = true
	wilson_agent.target_position = target_marker.global_position
	_log("  Movement requested to %s" % str(target_marker.global_position))


func _physics_process(_delta: float) -> void:
	if not _moving:
		return
	if wilson_agent.is_navigation_finished():
		_log("  ARRIVED at target!")
		_moving = false
		_check_perception()
		return
	var next_pos = wilson_agent.get_next_path_position()
	var direction = (next_pos - wilson_body.global_position).normalized()
	direction.y = 0.0
	wilson_body.velocity = direction * 3.0
	wilson_body.move_and_slide()
	if perception_area.has_overlapping_bodies() or perception_area.has_overlapping_areas():
		_log("  [MOVING] Broadphase overlap detected!")
		var candidates = perception_area.get_overlapping_bodies()
		candidates.append_array(perception_area.get_overlapping_areas())
		for obj in candidates:
			_log("    Candidate: %s at %s" % [obj.name, str(obj.global_position)])


func _check_perception() -> void:
	_log("--- Stage 5: Perception ---")
	var candidates = perception_area.get_overlapping_bodies()
	candidates.append_array(perception_area.get_overlapping_areas())
	_log("  Overlapping candidates: %d" % candidates.size())
	for obj in candidates:
		_log("    - %s" % obj.name)
	var space_state = wilson_body.get_world_3d().direct_space_state
	var from = wilson_body.global_position + Vector3(0.0, 0.9, 0.0)
	var to = perceptible.global_position + Vector3(0.0, 0.25, 0.0)
	var query = PhysicsRayQueryParameters3D.create(from, to)
	query.exclude = [perceptible.get_rid()]
	var result = space_state.intersect_ray(query)
	if result.is_empty():
		_log("  LOS to perceptible: CLEAR")
	else:
		_log("  LOS to perceptible: BLOCKED by %s" % str(result.collider))
	_log("=== SMOKE TEST COMPLETE ===")
	_print_log()


func _log(msg: String) -> void:
	_test_log.append(msg)
	print(msg)


func _print_log() -> void:
	print("\n".join(_test_log))
