class_name RememberedRouteMotionCoordinator
extends RefCounted

const MotionPort = preload("res://src/application/simulation/motion_port.gd")

## Executes a Wilson-relative preferred route through ordinary MotionPort requests.
##
## Route preference is derived from spatial truth plus cognition-owned associations.
## This coordinator persists no route-progress authority: current progress is inferred
## from MotionPort status/target and the selected route's stable waypoint sequence.

var _motion
var _preference
var _actor_ref


func _init(motion, preference_service, actor_ref) -> void:
	assert(motion != null, "RememberedRouteMotionCoordinator requires MotionPort")
	assert(preference_service != null, "RememberedRouteMotionCoordinator requires route preference service")
	assert(actor_ref != null, "RememberedRouteMotionCoordinator requires actor RuntimeWorldRef")
	_motion = motion
	_preference = preference_service
	_actor_ref = actor_ref


func apply(options: Array) -> Dictionary:
	var selected = _preference.choose(_actor_ref, options)
	if selected == null:
		return _result(false, null, null, &"no_viable_route")

	var status: int = _motion.get_status(_actor_ref)
	var current_target = _motion.get_target(_actor_ref)
	var current_index := _waypoint_index(selected.waypoints, current_target)

	if status == MotionPort.MotionStatus.MOVING and current_index >= 0:
		return _result(true, selected, current_target, &"already_moving")

	if status == MotionPort.MotionStatus.ARRIVED and current_index >= 0:
		var next_index := current_index + 1
		if next_index >= selected.waypoints.size():
			return _result(true, selected, current_target, &"route_complete")
		return _request(selected, selected.waypoints[next_index])

	if status == MotionPort.MotionStatus.MOVING:
		_motion.cancel_move(_actor_ref)

	return _request(selected, selected.waypoints[0])


func _request(selected, waypoint) -> Dictionary:
	if not _motion.request_move(_actor_ref, waypoint):
		return _result(false, selected, waypoint, &"move_rejected")
	return _result(true, selected, waypoint, &"move_requested")


func _waypoint_index(waypoints: Array, target) -> int:
	if target == null:
		return -1
	for index in range(waypoints.size()):
		if waypoints[index].equals(target):
			return index
	return -1


func _result(ok: bool, route, target, reason: StringName) -> Dictionary:
	return {
		"ok": ok,
		"route": route,
		"target_ref": target,
		"reason": reason,
	}
