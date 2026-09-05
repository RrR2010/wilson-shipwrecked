class_name SimulationBootstrapDefinition
extends RefCounted

var wilson_place_id
var entity_seeds: Array
var relation_seeds: Array
var belief_seeds: Array
var intention_seed

func _init(p_wilson_place_id, p_entity_seeds: Array = [], p_relation_seeds: Array = [], p_belief_seeds: Array = [], p_intention_seed = null) -> void:
	assert(p_wilson_place_id != null, "SimulationBootstrapDefinition requires Wilson place id")
	wilson_place_id = p_wilson_place_id
	entity_seeds = p_entity_seeds.duplicate()
	relation_seeds = p_relation_seeds.duplicate()
	belief_seeds = p_belief_seeds.duplicate()
	intention_seed = p_intention_seed
