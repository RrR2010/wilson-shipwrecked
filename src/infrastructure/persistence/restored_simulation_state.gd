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
var projects
var associations
var habits
var episodes
var presence
var environment
var dynamic_processes
var actors
var epistemic_projection


func _init(
	p_entities,
	p_relations,
	p_wilson_world_state,
	p_beliefs,
	p_current_intention,
	p_drives,
	p_projects,
	p_associations,
	p_habits,
	p_episodes,
	p_presence,
	p_environment,
	p_dynamic_processes,
	p_actors,
	p_epistemic_projection
) -> void:
	entities = p_entities
	relations = p_relations
	wilson_world_state = p_wilson_world_state
	beliefs = p_beliefs
	current_intention = p_current_intention
	drives = p_drives
	projects = p_projects
	associations = p_associations
	habits = p_habits
	episodes = p_episodes
	presence = p_presence
	environment = p_environment
	dynamic_processes = p_dynamic_processes
	actors = p_actors
	epistemic_projection = p_epistemic_projection
