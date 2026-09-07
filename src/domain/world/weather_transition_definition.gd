class_name WeatherTransitionDefinition
extends RefCounted

## Weighted authored edge in the weather transition graph.

var from_weather: StringName
var to_weather: StringName
var weight: float


func _init(p_from_weather: StringName, p_to_weather: StringName, p_weight: float = 1.0) -> void:
	assert(p_from_weather != &"" and p_to_weather != &"", "Weather transition requires non-empty weather ids")
	assert(is_finite(p_weight) and p_weight > 0.0, "Weather transition weight must be finite and positive")
	from_weather = p_from_weather
	to_weather = p_to_weather
	weight = p_weight


func stable_key() -> String:
	return "%s->%s" % [String(from_weather), String(to_weather)]
