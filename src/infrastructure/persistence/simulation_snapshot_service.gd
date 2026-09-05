class_name SimulationSnapshotService
extends RefCounted

const RoleBinding = preload("res://src/domain/actions/role_binding.gd")
const EntityInstance = preload("res://src/domain/world/entity_instance.gd")
const EntityStore = preload("res://src/domain/world/entity_store.gd")
const WilsonWorldState = preload("res://src/domain/world/wilson_world_state.gd")
const WorldRelation = preload("res://src/domain/world/world_relation.gd")
const WorldRelationStore = preload("res://src/domain/world/world_relation_store.gd")
const EnvironmentState = preload("res://src/domain/world/environment_state.gd")
const DynamicProcessStore = preload("res://src/domain/world/dynamic_process_store.gd")
const ActorStateStore = preload("res://src/domain/actors/actor_state_store.gd")
const BeliefProposition = preload("res://src/domain/cognition/belief_proposition.gd")
const BeliefStore = preload("res://src/domain/cognition/belief_store.gd")
const CurrentIntentionStore = preload("res://src/domain/cognition/current_intention_store.gd")
const DriveState = preload("res://src/domain/cognition/drive_state.gd")
const AssociationStore = preload("res://src/domain/cognition/association_store.gd")
const HabitStore = preload("res://src/domain/cognition/habit_store.gd")
const EpisodeStore = preload("res://src/domain/cognition/episode_store.gd")
const PresenceRelationship = preload("res://src/domain/cognition/presence_relationship.gd")
const ProjectStore = preload("res://src/domain/projects/project_store.gd")
const EpistemicGraphProjection = preload("res://src/domain/cognition/epistemic_graph_projection.gd")
const DomainValueCodec = preload("res://src/infrastructure/persistence/domain_value_codec.gd")
const RestoredSimulationState = preload("res://src/infrastructure/persistence/restored_simulation_state.gd")
const SimulationSnapshotBootstrapDecoder = preload("res://src/infrastructure/persistence/simulation_snapshot_bootstrap_decoder.gd")
const SimulationOwnerBootstrapper = preload("res://src/application/bootstrap/simulation_owner_bootstrapper.gd")

const SCHEMA_VERSION := 10

var _codec


func _init(codec = null) -> void:
	_codec = codec if codec != null else DomainValueCodec.new()


func capture(
	entity_store,
	relation_store,
	wilson_world_state,
	belief_store,
	intention_store,
	drive_state = null,
	project_store = null,
	association_store = null,
	habit_store = null,
	episode_store = null,
	presence_relationship = null,
	environment_state = null,
	dynamic_process_store = null,
	actor_state_store = null,
	wilson_body_state = null
) -> Dictionary:
	assert(entity_store != null, "capture requires EntityStore")
	assert(relation_store != null, "capture requires WorldRelationStore")
	assert(wilson_world_state != null, "capture requires WilsonWorldState")
	assert(belief_store != null, "capture requires BeliefStore")
	assert(intention_store != null, "capture requires CurrentIntentionStore")
	var drives = drive_state if drive_state != null else DriveState.new()
	var projects = project_store if project_store != null else ProjectStore.new()
	var associations = association_store if association_store != null else AssociationStore.new()
	var habits = habit_store if habit_store != null else HabitStore.new()
	var episodes = episode_store if episode_store != null else EpisodeStore.new()
	var presence = presence_relationship if presence_relationship != null else PresenceRelationship.new()
	var environment = environment_state if environment_state != null else EnvironmentState.new()
	var dynamic_processes = dynamic_process_store if dynamic_process_store != null else DynamicProcessStore.new()
	var actors = actor_state_store if actor_state_store != null else ActorStateStore.new()
	var body_vitality: float = 1.0 if wilson_body_state == null else float(wilson_body_state.vitality)
	return {
		"schema_version": SCHEMA_VERSION,
		"entities": _capture_entities(entity_store),
		"relations": _capture_relations(relation_store),
		"wilson_world": {"place_id": _codec.encode(wilson_world_state.place_id)},
		"wilson_body": {"vitality": body_vitality},
		"beliefs": _capture_beliefs(belief_store),
		"current_intention": _capture_intention(intention_store),
		"drives": _capture_drives(drives),
		"projects": _capture_projects(projects),
		"associations": _capture_associations(associations),
		"habits": _capture_habits(habits),
		"episodes": _capture_episodes(episodes),
		"presence": _capture_presence(presence),
		"environment": _capture_environment(environment),
		"dynamic_processes": _capture_dynamic_processes(dynamic_processes),
		"actors": _capture_actors(actors),
	}


func restore(snapshot: Dictionary):
	assert(int(snapshot.get("schema_version", -1)) == SCHEMA_VERSION, "Unsupported simulation snapshot schema")
	var definition = SimulationSnapshotBootstrapDecoder.new(_codec).decode(snapshot)
	var owner_result = SimulationOwnerBootstrapper.new().bootstrap(definition)
	assert(owner_result.ok, "Failed to restore core simulation owners: %s" % str(owner_result.diagnostics))
	var owners = owner_result.owners
	var entities = owners.entities
	var relations = owners.relations
	var wilson_world_state = owners.wilson_world_state
	var wilson_body = owners.wilson_body_state
	var beliefs = owners.beliefs
	var intention_store = owners.current_intention
	var drives = owners.drives
	var projects = owners.projects
	var associations = owners.associations
	var habits = owners.habits
	var episodes = owners.episodes
	var presence = owners.presence
	var environment = owners.environment
	var dynamic_processes = owners.dynamic_processes
	var actors = owners.actors

	var epistemic_projection = EpistemicGraphProjection.new()
	epistemic_projection.rebuild(beliefs)
	return RestoredSimulationState.new(
		entities,
		relations,
		wilson_world_state,
		wilson_body,
		beliefs,
		intention_store,
		drives,
		projects,
		associations,
		habits,
		episodes,
		presence,
		environment,
		dynamic_processes,
		actors,
		epistemic_projection
	)


func _capture_entities(entity_store) -> Array:
	var result: Array = []
	for entity in entity_store.entities():
		result.append({
			"id": _codec.encode(entity.id),
			"type_id": _codec.encode(entity.type_id),
			"place_id": _codec.encode(entity.place_id),
			"lifecycle": entity.lifecycle,
			"quantity": _codec.encode(entity.quantity),
			"state_overrides": _codec.encode(entity.state_overrides()),
		})
	return result


func _capture_relations(relation_store) -> Array:
	var result: Array = []
	for relation in relation_store.relations():
		result.append({
			"relation_type": _codec.encode(relation.relation_type),
			"subject": _codec.encode(relation.subject),
			"object": _codec.encode(relation.object),
			"qualifier": _codec.encode(relation.qualifier),
		})
	return result


func _capture_beliefs(belief_store) -> Array:
	var result: Array = []
	for entry in belief_store.entries():
		result.append({
			"claim": _codec.encode(entry.proposition.claim),
			"confidence": entry.confidence,
			"evidence_count": entry.evidence_count,
			"last_source_execution_id": String(entry.last_source_execution_id),
			"last_modality": String(entry.last_modality),
		})
	return result


func _capture_intention(intention_store):
	if not intention_store.has_current():
		return null
	var current = intention_store.current()
	return {
		"intention_id": _codec.encode(current.intention_id),
		"bindings": _encode_binding(current.bindings),
		"selected_step_id": String(current.selected_step_id),
	}


func _capture_drives(drive_state) -> Dictionary:
	var result: Dictionary = {}
	for drive_id in DriveState.DRIVE_IDS:
		result[String(drive_id)] = drive_state.value(drive_id)
	return result


func _capture_projects(project_store) -> Array:
	var result: Array = []
	for project in project_store.instances():
		result.append({
			"id": _codec.encode(project.id),
			"definition_id": _codec.encode(project.definition_id),
			"lifecycle": project.lifecycle,
			"subject_bindings": _encode_binding(project.subject_bindings),
			"contribution_count": project.contribution_count,
		})
	return result


func _capture_associations(association_store) -> Array:
	var result: Array = []
	for entry in association_store.entries():
		result.append({
			"subject": _codec.encode(entry["subject"]),
			"valence": entry["valence"],
			"attachment": entry["attachment"],
			"evidence_count": entry["evidence_count"],
			"last_source_execution_id": String(entry["last_source_execution_id"]),
		})
	return result


func _capture_habits(habit_store) -> Array:
	var result: Array = []
	for entry in habit_store.entries():
		result.append({
			"cue_id": String(entry["cue_id"]),
			"intention_id": _codec.encode(entry["intention_id"]),
			"bindings": _encode_binding(entry["bindings"]),
			"strength": entry["strength"],
			"evidence_count": entry["evidence_count"],
			"last_source_execution_id": String(entry["last_source_execution_id"]),
		})
	return result


func _capture_episodes(episode_store) -> Array:
	var result: Array = []
	for entry in episode_store.entries():
		result.append({
			"claim": _codec.encode(entry["claim"]),
			"importance": entry["importance"],
			"source_execution_id": String(entry["source_execution_id"]),
			"modality": String(entry["modality"]),
			"sequence": entry["sequence"],
		})
	return result


func _capture_presence(presence) -> Dictionary:
	return {
		"presence_belief": presence.presence_belief,
		"trust": presence.trust,
		"dependency": presence.dependency,
		"evidence_count": presence.evidence_count,
		"last_source_execution_id": String(presence.last_source_execution_id),
	}


func _capture_environment(environment) -> Dictionary:
	return {
		"weather": String(environment.weather),
		"daylight_phase": String(environment.daylight_phase),
	}


func _capture_dynamic_processes(dynamic_process_store) -> Array:
	var result: Array = []
	for process in dynamic_process_store.instances():
		result.append({
			"id": String(process.id),
			"definition_id": String(process.definition_id),
			"subject": _codec.encode(process.subject),
			"lifecycle": process.lifecycle,
			"elapsed": process.elapsed,
		})
	return result


func _capture_actors(actor_state_store) -> Array:
	var result: Array = []
	for state in actor_state_store.states():
		result.append({
			"actor": _codec.encode(state.actor),
			"profile_id": String(state.profile_id),
			"mode": String(state.mode),
			"decision_cooldown": state.decision_cooldown,
			"last_rule_id": String(state.last_rule_id),
		})
	return result


func _encode_binding(binding) -> Array:
	var result: Array = []
	for role_name in binding.role_names():
		result.append({
			"role": String(role_name),
			"subject": _codec.encode(binding.get_subject(role_name)),
		})
	return result


func _decode_binding(records: Array):
	var binding = RoleBinding.new()
	for record in records:
		binding.bind(StringName(record["role"]), _codec.decode(record["subject"]))
	return binding
