class_name WeatherDefinition
extends RefCounted

## Authored weather regime. A regime is composition data, not a behavior callback.
## Conditions expose generic environmental magnitudes that downstream rules may read.

var id: StringName
var min_duration: float
var max_duration: float
var conditions: Dictionary


func _init(
	p_id: StringName,
	p_min_duration: float,
	p_max_duration: float,
	p_conditions: Dictionary = {}
) -> void:
	assert(p_id != &"", "WeatherDefinition requires id")
	assert(is_finite(p_min_duration) and p_min_duration > 0.0, "Weather minimum duration must be finite and positive")
	assert(is_finite(p_max_duration) and p_max_duration >= p_min_duration, "Weather maximum duration must be finite and >= minimum")
	var normalized: Dictionary = {}
	for condition_id in p_conditions.keys():
		assert(condition_id is StringName or condition_id is String, "Weather condition ids must be strings")
		var normalized_id := StringName(condition_id)
		assert(normalized_id != &"", "Weather condition ids cannot be empty")
		var value := float(p_conditions[condition_id])
		assert(is_finite(value), "Weather condition values must be finite")
		normalized[normalized_id] = value
	id = p_id
	min_duration = p_min_duration
	max_duration = p_max_duration
	conditions = normalized


func condition(condition_id: StringName, fallback: float = 0.0) -> float:
	return float(conditions.get(condition_id, fallback))
