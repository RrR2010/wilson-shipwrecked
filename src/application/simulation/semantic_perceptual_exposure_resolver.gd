class_name SemanticPerceptualExposureResolver
extends RefCounted

## Determines whether a spatially accessible subject is semantically exposed to vision.
## Geometry remains owned by SpatialQueryPort. This resolver only interprets authored
## containment semantics, so closed opaque storage cannot leak its contents through
## passive broadphase candidates.

var _world_query
var _inside_relation_type
var _occluding_container_capability
var _open_property_id
var _max_depth: int


func _init(
	world_query,
	inside_relation_type,
	occluding_container_capability,
	open_property_id,
	max_depth: int = 8
) -> void:
	assert(world_query != null, "SemanticPerceptualExposureResolver requires WorldQuery")
	assert(inside_relation_type != null, "inside relation type is required")
	assert(occluding_container_capability != null, "occluding container capability is required")
	assert(open_property_id != null, "open property id is required")
	assert(max_depth > 0, "max_depth must be positive")
	_world_query = world_query
	_inside_relation_type = inside_relation_type
	_occluding_container_capability = occluding_container_capability
	_open_property_id = open_property_id
	_max_depth = max_depth


func is_exposed(subject) -> bool:
	assert(subject != null, "is_exposed requires subject")
	var frontier: Array = [{"subject": subject, "depth": 0}]
	var visited: Dictionary = {}
	while not frontier.is_empty():
		var node: Dictionary = frontier.pop_back()
		var current = node["subject"]
		var depth := int(node["depth"])
		var key := current.sort_key()
		if visited.has(key):
			continue
		visited[key] = true
		if depth >= _max_depth:
			# Fail closed when malformed/deep containment cannot be resolved safely.
			if not _world_query.get_outgoing_relations(current, _inside_relation_type).is_empty():
				return false
			continue
		for relation in _world_query.get_outgoing_relations(current, _inside_relation_type):
			var container = relation.object
			if _blocks_visual_access(container):
				return false
			frontier.append({"subject": container, "depth": depth + 1})
	return true


func _blocks_visual_access(container) -> bool:
	if not _world_query.has_authored_capability(container, _occluding_container_capability):
		return false
	# An occluding container is conservative by default: only explicit boolean true
	# exposes its contents. Transparent/open storage simply omits this capability.
	return _world_query.get_instance_property(container, _open_property_id) != true
