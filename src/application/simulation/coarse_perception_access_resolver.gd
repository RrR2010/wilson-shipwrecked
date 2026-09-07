class_name CoarsePerceptionAccessResolver
extends RefCounted

const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const PerceptionAccess = preload("res://src/domain/cognition/perception_access.gd")
const EventDefinition = preload("res://src/domain/content/event_definition.gd")

## Concrete engine-agnostic perception adapter for the current coarse spatial model.
## Spatial-role events use current PlaceId truth. Ambient event definitions represent
## locally pervasive environmental facts and are observable without synthetic bindings.

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
		if definition.access_scope == EventDefinition.AccessScope.AMBIENT:
			result[world_event.execution_id] = PerceptionAccess.new(
				true,
				definition.modalities,
				[],
				definition.base_confidence
			)
			continue
		var accessible_roles: Array[StringName] = []
		for role_name in definition.perceptible_roles:
			if not world_event.bindings.has(role_name):
				continue
			var subject = world_event.bindings.get_subject(role_name)
			if subject.equals(_observer) or _world_query.are_co_located(_observer, subject):
				accessible_roles.append(role_name)
		var observable := not accessible_roles.is_empty()
		var modalities: Array[StringName] = []
		if observable:
			modalities.append_array(definition.modalities)
		result[world_event.execution_id] = PerceptionAccess.new(
			observable,
			modalities,
			accessible_roles,
			definition.base_confidence
		)
	return result
