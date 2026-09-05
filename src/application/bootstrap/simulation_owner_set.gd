class_name SimulationOwnerSet
extends RefCounted

## Non-authoritative carrier for the normal owner instances produced by bootstrap.
## It owns no gameplay truth; each contained store remains its own authority.

var entities
var relations
var wilson_world_state
var beliefs
var current_intention
var wilson_body_state
var drives

func _init(
	p_entities,
	p_relations,
	p_wilson_world_state,
	p_beliefs,
	p_current_intention,
	p_wilson_body_state,
	p_drives
) -> void:
	entities = p_entities
	relations = p_relations
	wilson_world_state = p_wilson_world_state
	beliefs = p_beliefs
	current_intention = p_current_intention
	wilson_body_state = p_wilson_body_state
	drives = p_drives
