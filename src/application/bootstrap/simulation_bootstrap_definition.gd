class_name SimulationBootstrapDefinition
extends RefCounted

var wilson_place_id
var entity_seeds: Array
var relation_seeds: Array
var belief_seeds: Array
var intention_seed
var wilson_body_vitality: float
var drive_values: Dictionary
var project_seeds: Array
var association_seeds: Array
var habit_seeds: Array
var episode_seeds: Array
var presence_seed
var environment_weather: StringName
var environment_daylight_phase: StringName
var dynamic_process_seeds: Array
var actor_state_seeds: Array

func _init(
	p_wilson_place_id,
	p_entity_seeds: Array = [],
	p_relation_seeds: Array = [],
	p_belief_seeds: Array = [],
	p_intention_seed = null,
	p_wilson_body_vitality: float = 1.0,
	p_drive_values: Dictionary = {},
	p_project_seeds: Array = [],
	p_association_seeds: Array = [],
	p_habit_seeds: Array = [],
	p_episode_seeds: Array = [],
	p_presence_seed = null,
	p_environment_weather: StringName = &"clear",
	p_environment_daylight_phase: StringName = &"day",
	p_dynamic_process_seeds: Array = [],
	p_actor_state_seeds: Array = []
) -> void:
	assert(p_wilson_place_id != null, "SimulationBootstrapDefinition requires Wilson place id")
	assert(is_finite(p_wilson_body_vitality) and p_wilson_body_vitality >= 0.0 and p_wilson_body_vitality <= 1.0, "Wilson body vitality must be within [0,1]")
	assert(p_environment_weather != &"", "SimulationBootstrapDefinition requires environment weather")
	assert(p_environment_daylight_phase != &"", "SimulationBootstrapDefinition requires daylight phase")
	wilson_place_id = p_wilson_place_id
	entity_seeds = p_entity_seeds.duplicate()
	relation_seeds = p_relation_seeds.duplicate()
	belief_seeds = p_belief_seeds.duplicate()
	intention_seed = p_intention_seed
	wilson_body_vitality = p_wilson_body_vitality
	drive_values = p_drive_values.duplicate(true)
	project_seeds = p_project_seeds.duplicate()
	association_seeds = p_association_seeds.duplicate()
	habit_seeds = p_habit_seeds.duplicate()
	episode_seeds = p_episode_seeds.duplicate()
	presence_seed = p_presence_seed
	environment_weather = p_environment_weather
	environment_daylight_phase = p_environment_daylight_phase
	dynamic_process_seeds = p_dynamic_process_seeds.duplicate()
	actor_state_seeds = p_actor_state_seeds.duplicate()
