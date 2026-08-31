class_name CoarsePerceptionAccessResolver
extends RefCounted

const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const PerceptionAccess = preload("res://src/domain/cognition/perception_access.gd")

## Concrete engine-agnostic perception adapter for the current coarse spatial model.
## EventDefinition owns potentially perceptible roles/modalities; WorldQuery owns
## current PlaceId truth. Fine distance/occlusion adapters can replace this class
## behind the same resolve() contract.

var _world_query
var _observer


func _init(world_query, observer = null) -> void:
	assert(world_query != null, "CoarsePerceptionAccessResolver requires WorldQuery")
	_world_query = world_query
	_observer = observer if observer != null else RuntimeWorldRef.wilson()


func resolve(world_events: Array, _step_context) -> Dictionary:
	var result: Dictionary = {}
	for world_event in world_events:
		assert(world_event != null, "resolve events cannot contain null")
		var definition = _world_query.get_event_definition(world_event.event_type)
		if definition == null:
			result[world_event.execution_id] = PerceptionAccess.new(false)
			continue
		var accessible_roles: Array[StringName] = []
		for role_name in definition.perceptible_roles:
			if not world_event.bindings.has(role_name):
				continue
			var subject = world_event.bindings.get_subject(role_name)
			if subject.equals(_observer) or _world_query.are_co_located(_observer, subject):
				accessible_roles.append(role_name)
		var observable := not accessible_roles.is_empty()
		result[world_event.execution_id] = PerceptionAccess.new(
			observable,
			definition.modalities if observable else [],
			accessible_roles,
			definition.base_confidence
		)
	return result
