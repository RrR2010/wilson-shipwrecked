class_name WeatherProgressionService
extends RefCounted

## Deterministic procedural weather progression over authored regime and transition data.
## This service mutates only EnvironmentState and owns no independent durable truth.
##
## Selection is intentionally derived from authored ids plus the persisted transition
## index. Run-specific entropy is not accepted here until the runtime has a common
## persisted entropy cause rather than a caller-supplied seed that restore can lose.

const SAMPLE_MODULUS := 2147483647

var _environment
var _definitions: Dictionary = {}
var _transitions_by_from: Dictionary = {}


func _init(environment, definitions: Array, transitions: Array) -> void:
	assert(environment != null, "WeatherProgressionService requires EnvironmentState")
	assert(not definitions.is_empty(), "Weather progression requires definitions")
	_environment = environment
	for definition in definitions:
		assert(definition != null, "Weather definitions cannot contain null")
		assert(not _definitions.has(definition.id), "Duplicate weather definition: %s" % String(definition.id))
		_definitions[definition.id] = definition
	for transition in transitions:
		assert(transition != null, "Weather transitions cannot contain null")
		assert(_definitions.has(transition.from_weather), "Unknown weather transition source: %s" % String(transition.from_weather))
		assert(_definitions.has(transition.to_weather), "Unknown weather transition target: %s" % String(transition.to_weather))
		var bucket: Array = _transitions_by_from.get(transition.from_weather, [])
		for existing in bucket:
			assert(existing.to_weather != transition.to_weather, "Duplicate weather transition: %s" % transition.stable_key())
		bucket.append(transition)
		bucket.sort_custom(func(a, b): return a.stable_key() < b.stable_key())
		_transitions_by_from[transition.from_weather] = bucket
	assert(_definitions.has(_environment.weather), "Environment weather has no WeatherDefinition: %s" % String(_environment.weather))
	for weather_id in _definitions.keys():
		assert(_transitions_by_from.has(weather_id) and not _transitions_by_from[weather_id].is_empty(), "Procedural weather requires at least one outgoing transition for %s" % String(weather_id))
	if _environment.weather_planned_duration <= 0.0:
		_environment.weather_planned_duration = _duration_for(_environment.weather, _environment.weather_transition_index)


func advance(elapsed: float) -> Dictionary:
	assert(is_finite(elapsed) and elapsed >= 0.0, "Weather elapsed must be finite and non-negative")
	var transitions: Array = []
	var segments: Array = []
	var remaining := elapsed
	while remaining > 0.0:
		var until_transition := _environment.weather_planned_duration - _environment.weather_elapsed
		var segment_elapsed := minf(remaining, until_transition)
		if segment_elapsed > 0.0:
			segments.append({
				"weather": _environment.weather,
				"elapsed": segment_elapsed,
				"conditions": _definitions[_environment.weather].conditions.duplicate(true),
			})
			_environment.weather_elapsed += segment_elapsed
			remaining = maxf(remaining - segment_elapsed, 0.0)
		if _environment.weather_elapsed < _environment.weather_planned_duration and not is_equal_approx(_environment.weather_elapsed, _environment.weather_planned_duration):
			break
		var previous: StringName = _environment.weather
		var selected = _select_transition(previous, _environment.weather_transition_index)
		var next: StringName = selected.to_weather
		var next_index := _environment.weather_transition_index + 1
		var duration := _duration_for(next, next_index)
		_environment.begin_weather(next, duration, next_index)
		transitions.append({
			"from": previous,
			"to": next,
			"transition_index": next_index,
			"planned_duration": duration,
			"event_type": selected.event_type,
		})
	return {
		"weather": _environment.weather,
		"elapsed": _environment.weather_elapsed,
		"planned_duration": _environment.weather_planned_duration,
		"transition_index": _environment.weather_transition_index,
		"transitions": transitions,
		"segments": segments,
		"conditions": current_conditions(),
	}


func current_conditions() -> Dictionary:
	var definition = _definitions[_environment.weather]
	return definition.conditions.duplicate(true)


func condition(condition_id: StringName, fallback: float = 0.0) -> float:
	var definition = _definitions[_environment.weather]
	return definition.condition(condition_id, fallback)


func _select_transition(from_weather: StringName, transition_index: int):
	var options: Array = _transitions_by_from[from_weather]
	var total_weight := 0.0
	for option in options:
		total_weight += option.weight
	var sample := _sample_unit(from_weather, transition_index, 11) * total_weight
	var cumulative := 0.0
	for option in options:
		cumulative += option.weight
		if sample < cumulative:
			return option
	return options[options.size() - 1]


func _duration_for(weather_id: StringName, transition_index: int) -> float:
	var definition = _definitions[weather_id]
	if is_equal_approx(definition.min_duration, definition.max_duration):
		return definition.min_duration
	var sample := _sample_unit(weather_id, transition_index, 29)
	return lerpf(definition.min_duration, definition.max_duration, sample)


func _sample_unit(weather_id: StringName, transition_index: int, salt: int) -> float:
	var state := 17
	state = posmod(state * 48271 + posmod(transition_index, SAMPLE_MODULUS), SAMPLE_MODULUS)
	state = posmod(state * 69621 + _stable_string_hash(String(weather_id)), SAMPLE_MODULUS)
	state = posmod(state * 40699 + salt, SAMPLE_MODULUS)
	return float(state) / float(SAMPLE_MODULUS)


func _stable_string_hash(value: String) -> int:
	var result := 7
	for index in range(value.length()):
		result = posmod(result * 131 + value.unicode_at(index), SAMPLE_MODULUS)
	return result
