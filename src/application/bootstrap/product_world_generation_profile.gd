class_name ProductWorldGenerationProfile
extends RefCounted

## Authored, bounded generation content used before NewRunDefinition exists.
##
## Profiles describe possible durable bootstrap causes. They never become runtime owners.

var id: StringName
var wilson_start_places: Array
var entity_rules: Array
var initial_drive_values: Dictionary
var environment_weather: StringName
var environment_daylight_phase: StringName


func _init(
	p_id: StringName,
	p_wilson_start_places: Array,
	p_entity_rules: Array = [],
	p_initial_drive_values: Dictionary = {},
	p_environment_weather: StringName = &"clear",
	p_environment_daylight_phase: StringName = &"day"
) -> void:
	assert(p_id != &"", "ProductWorldGenerationProfile requires id")
	assert(not p_wilson_start_places.is_empty(), "ProductWorldGenerationProfile requires at least one Wilson start place")
	for place_id in p_wilson_start_places:
		assert(place_id != null, "ProductWorldGenerationProfile Wilson start place cannot be null")
	for rule in p_entity_rules:
		assert(rule != null, "ProductWorldGenerationProfile entity rule cannot be null")
	assert(p_environment_weather != &"", "ProductWorldGenerationProfile requires environment weather")
	assert(p_environment_daylight_phase != &"", "ProductWorldGenerationProfile requires daylight phase")
	id = p_id
	wilson_start_places = p_wilson_start_places.duplicate()
	entity_rules = p_entity_rules.duplicate()
	initial_drive_values = p_initial_drive_values.duplicate(true)
	environment_weather = p_environment_weather
	environment_daylight_phase = p_environment_daylight_phase
