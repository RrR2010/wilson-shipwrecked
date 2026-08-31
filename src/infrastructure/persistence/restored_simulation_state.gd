class_name RestoredSimulationState
extends RefCounted

## Explicit result of persistence restoration. Reconstructible projections are
## included for immediate query use but remain non-authoritative.

var entities
var relations
var wilson_world_state
var beliefs
var current_intention
var drives
var epistemic_projection


func _init(
	p_entities,
	p_relations,
	p_wilson_world_state,
	p_beliefs,
	p_current_intention,
	p_drives,
	p_epistemic_projection
) -> void:
	entities = p_entities
	relations = p_relations
	wilson_world_state = p_wilson_world_state
	beliefs = p_beliefs
	current_intention = p_current_intention
	drives = p_drives
	epistemic_projection = p_epistemic_projection
