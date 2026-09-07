class_name WeatherTransitionDefinition
extends RefCounted

const DomainId = preload("res://src/domain/core/domain_id.gd")

## Weighted authored edge in the weather transition graph.
##
## Optional event_type keeps perceptual projection attached to the authored
## transition instead of requiring a parallel application-layer mapping.

var from_weather: StringName
var to_weather: StringName
var weight: float
var event_type


func _init(
	p_from_weather: StringName,
	p_to_weather: StringName,
	p_weight: float = 1.0,
	p_event_type = null
) -> void:
	assert(p_from_weather != &"" and p_to_weather != &"", "Weather transition requires non-empty weather ids")
	assert(is_finite(p_weight) and p_weight > 0.0, "Weather transition weight must be finite and positive")
	if p_event_type != null:
		p_event_type.assert_kind(DomainId.Kind.EVENT_DEFINITION)
	from_weather = p_from_weather
	to_weather = p_to_weather
	weight = p_weight
	event_type = p_event_type


func stable_key() -> String:
	return "%s->%s" % [String(from_weather), String(to_weather)]
