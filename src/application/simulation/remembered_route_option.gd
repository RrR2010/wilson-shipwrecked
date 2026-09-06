class_name RememberedRouteOption
extends RefCounted

## One semantic route alternative toward the same goal.
##
## Waypoints are stable RuntimeWorldRefs used only for spatial queries/execution.
## Memory subjects are semantic subjects whose Wilson-relative associations may make
## this route more or less desirable. Neither list is authoritative world state.

var id: StringName
var waypoints: Array
var memory_subjects: Array


func _init(p_id: StringName, p_waypoints: Array, p_memory_subjects: Array = []) -> void:
	assert(p_id != &"", "RememberedRouteOption requires id")
	assert(not p_waypoints.is_empty(), "RememberedRouteOption requires at least one waypoint")
	for waypoint in p_waypoints:
		assert(waypoint != null, "RememberedRouteOption waypoint cannot be null")
	for subject in p_memory_subjects:
		assert(subject != null and subject.has_method("sort_key"), "RememberedRouteOption memory subject must be semantic")
	id = p_id
	waypoints = p_waypoints.duplicate()
	memory_subjects = p_memory_subjects.duplicate()


func stable_key() -> String:
	var waypoint_keys: Array[String] = []
	for waypoint in waypoints:
		waypoint_keys.append(String(waypoint.key()))
	var memory_keys: Array[String] = []
	for subject in memory_subjects:
		memory_keys.append(subject.sort_key())
	memory_keys.sort()
	return "%s|%s|%s" % [String(id), ">".join(waypoint_keys), ",".join(memory_keys)]
