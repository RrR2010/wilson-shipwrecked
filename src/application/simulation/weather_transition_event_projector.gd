class_name WeatherTransitionEventProjector
extends RefCounted

const RoleBinding = preload("res://src/domain/actions/role_binding.gd")
const WorldEvent = preload("res://src/domain/actions/world_event.gd")

## Projects authored weather-regime transitions into ambient WorldEvents.
## The transition itself carries its optional event type, keeping perceptual
## semantics in authored content rather than in application-layer configuration.


func project(transitions: Array, step_id: StringName) -> Array:
	assert(step_id != &"", "Weather transition projection requires step id")
	var events: Array = []
	for transition in transitions:
		if not (transition is Dictionary):
			continue
		if not transition.has("from") or not transition.has("to") or not transition.has("transition_index"):
			continue
		var event_type = transition.get("event_type")
		if event_type == null:
			continue
		var occurrence_id := StringName("weather:%s:%d:%s:%s" % [
			String(step_id),
			int(transition["transition_index"]),
			String(transition["from"]),
			String(transition["to"]),
		])
		events.append(WorldEvent.new(event_type, null, RoleBinding.new(), occurrence_id))
	return events
