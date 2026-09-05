class_name SimulationOwnerBootstrapper
extends RefCounted

const EntityInstance = preload("res://src/domain/world/entity_instance.gd")
const EntityStore = preload("res://src/domain/world/entity_store.gd")
const WorldRelation = preload("res://src/domain/world/world_relation.gd")
const WorldRelationStore = preload("res://src/domain/world/world_relation_store.gd")
const WilsonWorldState = preload("res://src/domain/world/wilson_world_state.gd")
const WilsonBodyState = preload("res://src/domain/world/wilson_body_state.gd")
const BeliefStore = preload("res://src/domain/cognition/belief_store.gd")
const CurrentIntentionStore = preload("res://src/domain/cognition/current_intention_store.gd")
const DriveState = preload("res://src/domain/cognition/drive_state.gd")
const SimulationOwnerSet = preload("res://src/application/bootstrap/simulation_owner_set.gd")
const SimulationBootstrapResult = preload("res://src/application/bootstrap/simulation_bootstrap_result.gd")

## Common construction boundary for authoritative owners required by runtime
## composition/bootstrap. Declarative seeds are copied into fresh owner instances;
## callers cannot manufacture post-bootstrap state by retaining mutable owner refs.

func bootstrap(definition):
	assert(definition != null, "bootstrap requires SimulationBootstrapDefinition")

	var entities = EntityStore.new()
	for seed in definition.entity_seeds:
		var entity = EntityInstance.new(
			seed.id,
			seed.type_id,
			seed.place_id,
			seed.state_overrides,
			seed.quantity
		)
		entity.lifecycle = seed.lifecycle
		var add_result = entities.add_entity(entity)
		if not add_result.ok:
			return SimulationBootstrapResult.failure(add_result.code, add_result.diagnostics)

	var relations = WorldRelationStore.new()
	for seed in definition.relation_seeds:
		var relation_result = relations.add_relation(WorldRelation.new(
			seed.relation_type,
			seed.subject,
			seed.object,
			seed.qualifier
		))
		if not relation_result.ok:
			return SimulationBootstrapResult.failure(relation_result.code, relation_result.diagnostics)
	relations.rebuild_indexes()
	var index_result = relations.validate_indexes()
	if not index_result.ok:
		return SimulationBootstrapResult.failure(index_result.code, index_result.diagnostics)

	var beliefs = BeliefStore.new()
	for seed in definition.belief_seeds:
		var belief_result = beliefs.restore_entry(
			seed.proposition,
			seed.confidence,
			seed.evidence_count,
			seed.last_source_execution_id,
			seed.last_modality
		)
		if not belief_result.ok:
			return SimulationBootstrapResult.failure(belief_result.code, belief_result.diagnostics)

	var intentions = CurrentIntentionStore.new()
	if definition.intention_seed != null:
		var intention_result = intentions.select(
			definition.intention_seed.intention_id,
			definition.intention_seed.bindings,
			definition.intention_seed.selected_step_id
		)
		if not intention_result.ok:
			return SimulationBootstrapResult.failure(intention_result.code, intention_result.diagnostics)

	return SimulationBootstrapResult.success(SimulationOwnerSet.new(
		entities,
		relations,
		WilsonWorldState.new(definition.wilson_place_id),
		beliefs,
		intentions,
		WilsonBodyState.new(definition.wilson_body_vitality),
		DriveState.new(definition.drive_values)
	))
