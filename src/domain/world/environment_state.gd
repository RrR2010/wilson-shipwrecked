class_name EnvironmentState
extends RefCounted

var weather: StringName
var daylight_phase: StringName


func _init(p_weather: StringName = &"clear", p_daylight_phase: StringName = &"day") -> void:
	assert(p_weather != &"", "EnvironmentState requires weather")
	assert(p_daylight_phase != &"", "EnvironmentState requires daylight phase")
	weather = p_weather
	daylight_phase = p_daylight_phase


func set_weather(value: StringName) -> void:
	assert(value != &"", "weather cannot be empty")
	weather = value


func set_daylight_phase(value: StringName) -> void:
	assert(value != &"", "daylight phase cannot be empty")
	daylight_phase = value
