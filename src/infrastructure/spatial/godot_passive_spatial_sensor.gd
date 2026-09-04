class_name GodotPassiveSpatialSensor
extends Node

## Collision-backed broadphase candidate source for passive perception.
##
## Area/body overlap means only "worth rechecking". It never means visible, heard,
## reachable, dangerous, or otherwise semantically perceived.
##
## Godot overlap signals are the fast path. A bounded reconciliation fallback samples
## the Area3D snapshot more often while the sensor is moving and sparsely while static,
## preventing callback ordering or missed edges from leaving candidates stale without
## scanning every physics frame.

const MOVING_RECONCILE_FRAMES := 6
const STATIC_RECONCILE_FRAMES := 60
const MOVEMENT_REFRESH_DISTANCE := 0.10
const DEBUG_BUILD := "passive_sensor_reconcile_v2"

var _sensor_area: Area3D
var _ref_by_collision_id: Dictionary = {}
var _active_by_key: Dictionary = {}
var _dirty := false
var _physics_frames_since_reconcile: int = 0
var _last_reconcile_position := Vector3.ZERO
var _has_reconcile_position := false
var _reconcile_count: int = 0


func configure(sensor_area: Area3D) -> void:
	assert(sensor_area != null, "GodotPassiveSpatialSensor requires Area3D")
	if _sensor_area != null:
		_disconnect_area()
	_sensor_area = sensor_area
	_sensor_area.body_entered.connect(_on_body_entered)
	_sensor_area.body_exited.connect(_on_body_exited)
	_sensor_area.area_entered.connect(_on_area_entered)
	_sensor_area.area_exited.connect(_on_area_exited)
	_physics_frames_since_reconcile = 0
	_has_reconcile_position = false
	_reconcile_count = 0
	set_physics_process(true)
	print("[PASSIVE_SENSOR][BUILD] %s mask=%d monitoring=%s" % [DEBUG_BUILD, _sensor_area.collision_mask, _sensor_area.monitoring])


func bind_candidate(runtime_ref, collision_object: CollisionObject3D) -> bool:
	if runtime_ref == null or collision_object == null:
		return false
	var instance_id := collision_object.get_instance_id()
	if _ref_by_collision_id.has(instance_id):
		return _ref_by_collision_id[instance_id].equals(runtime_ref)
	_ref_by_collision_id[instance_id] = runtime_ref
	print("[PASSIVE_SENSOR][BIND] instance=%d layer=%d ref=%s" % [instance_id, collision_object.collision_layer, runtime_ref.sort_key()])
	return true


func unbind_candidate(runtime_ref, collision_object: CollisionObject3D) -> void:
	if runtime_ref == null or collision_object == null:
		return
	var instance_id := collision_object.get_instance_id()
	var mapped = _ref_by_collision_id.get(instance_id)
	if mapped != null and mapped.equals(runtime_ref):
		_ref_by_collision_id.erase(instance_id)
		if _active_by_key.erase(runtime_ref.key()):
			_dirty = true


func has_pending_refresh() -> bool:
	return _dirty


func consume_refresh_candidates() -> Array:
	var result: Array = _active_by_key.values()
	result.sort_custom(func(a, b): return a.sort_key() < b.sort_key())
	_dirty = false
	return result


func request_refresh() -> void:
	_dirty = true


func active_candidate_count() -> int:
	return _active_by_key.size()


func reconcile_overlaps() -> bool:
	if _sensor_area == null or not is_instance_valid(_sensor_area) or not _sensor_area.is_inside_tree():
		return false
	var overlapping_bodies: Array[Node3D] = _sensor_area.get_overlapping_bodies()
	var overlapping_areas: Array[Area3D] = _sensor_area.get_overlapping_areas()
	var current_by_key: Dictionary = {}
	for body in overlapping_bodies:
		_collect_bound_overlap(body, current_by_key)
	for area in overlapping_areas:
		_collect_bound_overlap(area, current_by_key)

	var changed: bool = not _same_key_set(_active_by_key, current_by_key)
	if changed:
		_active_by_key = current_by_key
		_dirty = true
	_last_reconcile_position = _sensor_area.global_position
	_has_reconcile_position = true
	_physics_frames_since_reconcile = 0
	_reconcile_count += 1
	if changed or not overlapping_bodies.is_empty() or not overlapping_areas.is_empty() or _reconcile_count == 1:
		print("[PASSIVE_SENSOR][RECONCILE] count=%d raw_bodies=%d raw_areas=%d bound=%d changed=%s position=%s" % [
			_reconcile_count,
			overlapping_bodies.size(),
			overlapping_areas.size(),
			current_by_key.size(),
			changed,
			str(_sensor_area.global_position),
		])
	return changed


func raw_overlap_count() -> int:
	if _sensor_area == null or not is_instance_valid(_sensor_area) or not _sensor_area.is_inside_tree():
		return 0
	return _sensor_area.get_overlapping_bodies().size() + _sensor_area.get_overlapping_areas().size()


func _physics_process(_delta: float) -> void:
	if _sensor_area == null or not is_instance_valid(_sensor_area) or not _sensor_area.is_inside_tree():
		return
	_physics_frames_since_reconcile += 1
	var current_position: Vector3 = _sensor_area.global_position
	if not _has_reconcile_position:
		_last_reconcile_position = current_position
		_has_reconcile_position = true
		return
	var moved: bool = current_position.distance_to(_last_reconcile_position) >= MOVEMENT_REFRESH_DISTANCE
	var due_frames: int = MOVING_RECONCILE_FRAMES if moved else STATIC_RECONCILE_FRAMES
	if _physics_frames_since_reconcile >= due_frames:
		reconcile_overlaps()


func _on_body_entered(body: Node3D) -> void:
	print("[PASSIVE_SENSOR][SIGNAL] body_entered id=%d" % body.get_instance_id())
	_enter_collision_object(body)


func _on_body_exited(body: Node3D) -> void:
	print("[PASSIVE_SENSOR][SIGNAL] body_exited id=%d" % body.get_instance_id())
	_exit_collision_object(body)


func _on_area_entered(area: Area3D) -> void:
	print("[PASSIVE_SENSOR][SIGNAL] area_entered id=%d" % area.get_instance_id())
	_enter_collision_object(area)


func _on_area_exited(area: Area3D) -> void:
	print("[PASSIVE_SENSOR][SIGNAL] area_exited id=%d" % area.get_instance_id())
	_exit_collision_object(area)


func _enter_collision_object(node: Object) -> void:
	if node == null:
		return
	var runtime_ref = _ref_by_collision_id.get(node.get_instance_id())
	if runtime_ref == null:
		print("[PASSIVE_SENSOR][UNBOUND] entered id=%d" % node.get_instance_id())
		return
	var key = runtime_ref.key()
	if not _active_by_key.has(key):
		_active_by_key[key] = runtime_ref
		_dirty = true
		print("[PASSIVE_SENSOR][CANDIDATE] entered=%s" % runtime_ref.sort_key())


func _exit_collision_object(node: Object) -> void:
	if node == null:
		return
	var runtime_ref = _ref_by_collision_id.get(node.get_instance_id())
	if runtime_ref == null:
		return
	if _active_by_key.erase(runtime_ref.key()):
		_dirty = true
		print("[PASSIVE_SENSOR][CANDIDATE] exited=%s" % runtime_ref.sort_key())


func _collect_bound_overlap(node: Object, output: Dictionary) -> void:
	if node == null:
		return
	var runtime_ref = _ref_by_collision_id.get(node.get_instance_id())
	if runtime_ref == null:
		return
	output[runtime_ref.key()] = runtime_ref


func _same_key_set(a: Dictionary, b: Dictionary) -> bool:
	if a.size() != b.size():
		return false
	for key in a:
		if not b.has(key):
			return false
	return true


func _disconnect_area() -> void:
	if not is_instance_valid(_sensor_area):
		return
	if _sensor_area.body_entered.is_connected(_on_body_entered):
		_sensor_area.body_entered.disconnect(_on_body_entered)
	if _sensor_area.body_exited.is_connected(_on_body_exited):
		_sensor_area.body_exited.disconnect(_on_body_exited)
	if _sensor_area.area_entered.is_connected(_on_area_entered):
		_sensor_area.area_entered.disconnect(_on_area_entered)
	if _sensor_area.area_exited.is_connected(_on_area_exited):
		_sensor_area.area_exited.disconnect(_on_area_exited)
