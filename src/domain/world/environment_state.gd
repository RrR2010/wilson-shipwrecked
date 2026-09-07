class_name EnvironmentState
extends RefCounted

var weather: StringName
var daylight_phase: StringName
var weather_elapsed: float
var weather_planned_duration: float
var weather_transition_index: int


func _init(
	p_weather: StringName = &"clear",
	p_daylight_phase: StringName = &"day",
	p_weather_elapsed: float = 0.0,
	p_weather_planned_duration: float = 0.0,
	p_weather_transition_index: int = 0
) -> void:
	assert(p_weather != &"", "EnvironmentState requires weather")
	assert(p_daylight_phase != &"", "EnvironmentState requires daylight phase")
	assert(is_finite(p_weather_elapsed) and p_weather_elapsed >= 0.0, "Weather elapsed must be finite and non-negative")
	assert(is_finite(p_weather_planned_duration) and p_weather_planned_duration >= 0.0, "Weather planned duration must be finite and non-negative")
	assert(p_weather_planned_duration <= 0.0 or p_weather_elapsed <= p_weather_planned_duration, "Weather elapsed cannot exceed planned duration")
	assert(p_weather_transition_index >= 0, "Weather transition index must be non-negative")
	weather = p_weather
	daylight_phase = p_daylight_phase
	weather_elapsed = p_weather_elapsed
	weather_planned_duration = p_weather_planned_duration
	weather_transition_index = p_weather_transition_index


func set_weather(value: StringName) -> void:
	## Explicit non-procedural weather mutation invalidates the current procedural phase.
	## A later WeatherProgressionService composition may derive a fresh duration.
	assert(value != &"", "weather cannot be empty")
	weather = value
	weather_elapsed = 0.0
	weather_planned_duration = 0.0


func begin_weather(value: StringName, planned_duration: float, transition_index: int) -> void:
	assert(value != &"", "weather cannot be empty")
	assert(is_finite(planned_duration) and planned_duration > 0.0, "Weather duration must be finite and positive")
	assert(transition_index >= 0, "Weather transition index must be non-negative")
	weather = value
	weather_elapsed = 0.0
	weather_planned_duration = planned_duration
	weather_transition_index = transition_index


func set_daylight_phase(value: StringName) -> void:
	assert(value != &"", "daylight phase cannot be empty")
	daylight_phase = value
