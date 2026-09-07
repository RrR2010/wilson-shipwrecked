class_name WeatherTransitionEventProjector
extends RefCounted

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RoleBinding = preload("res://src/domain/actions/role_binding.gd")
const WorldEvent = preload("res://src/domain/actions/world_event.gd")

## Projects authoritative weather-regime transitions into ambient WorldEvents.
## The event carries no synthetic entity bindings; perception access is defined by
## EventDefinition.AccessScope.AMBIENT.

var _event_type


func _init(event_type) -> void:
	assert(event_type != null, "WeatherTransitionEventProjector requires event type")
	event_type.assert_kind(DomainId.Kind.EVENT_DEFINITION)
	_event_type = event_type


func project(transitions: Array, step_id: StringName) -> Array:
	assert(step_id != &"", "Weather transition projection requires step id")
	var events: Array = []
	for transition in transitions:
		if not (transition is Dictionary):
			continue
		if not transition.has("from") or not transition.has("to") or not transition.has("transition_index"):
			continue
		var occurrence_id := StringName("weather:%s:%d:%s:%s" % [
			String(step_id),
			int(transition["transition_index"]),
			String(transition["from"]),
			String(transition["to"]),
		])
		events.append(WorldEvent.new(_event_type, null, RoleBinding.new(), occurrence_id))
	return events
