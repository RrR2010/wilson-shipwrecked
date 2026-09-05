class_name SimulationBootstrapDefinition
extends RefCounted

var wilson_place_id
var entity_seeds: Array
var relation_seeds: Array
var belief_seeds: Array
var intention_seed
var wilson_body_vitality: float
var drive_values: Dictionary

func _init(
	p_wilson_place_id,
	p_entity_seeds: Array = [],
	p_relation_seeds: Array = [],
	p_belief_seeds: Array = [],
	p_intention_seed = null,
	p_wilson_body_vitality: float = 1.0,
	p_drive_values: Dictionary = {}
) -> void:
	assert(p_wilson_place_id != null, "SimulationBootstrapDefinition requires Wilson place id")
	assert(is_finite(p_wilson_body_vitality) and p_wilson_body_vitality >= 0.0 and p_wilson_body_vitality <= 1.0, "Wilson body vitality must be within [0,1]")
	wilson_place_id = p_wilson_place_id
	entity_seeds = p_entity_seeds.duplicate()
	relation_seeds = p_relation_seeds.duplicate()
	belief_seeds = p_belief_seeds.duplicate()
	intention_seed = p_intention_seed
	wilson_body_vitality = p_wilson_body_vitality
	drive_values = p_drive_values.duplicate(true)
