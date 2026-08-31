class_name RestoredSimulationState
extends RefCounted

## Explicit result of persistence restoration. Reconstructible projections are
## included for immediate query use but remain non-authoritative.

var entities
var relations
var beliefs
var current_intention
var epistemic_projection


func _init(p_entities, p_relations, p_beliefs, p_current_intention, p_epistemic_projection) -> void:
	entities = p_entities
	relations = p_relations
	beliefs = p_beliefs
	current_intention = p_current_intention
	epistemic_projection = p_epistemic_projection
