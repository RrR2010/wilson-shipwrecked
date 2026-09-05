extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const EntityInstance = preload("res://src/domain/world/entity_instance.gd")
const EntityStore = preload("res://src/domain/world/entity_store.gd")
const WilsonWorldState = preload("res://src/domain/world/wilson_world_state.gd")
const WorldRelation = preload("res://src/domain/world/world_relation.gd")
const WorldRelationStore = preload("res://src/domain/world/world_relation_store.gd")
const BeliefStore = preload("res://src/domain/cognition/belief_store.gd")
const CurrentIntentionStore = preload("res://src/domain/cognition/current_intention_store.gd")
const EpistemicClaim = preload("res://src/domain/cognition/epistemic_claim.gd")
const BeliefProposition = preload("res://src/domain/cognition/belief_proposition.gd")
const RoleBinding = preload("res://src/domain/actions/role_binding.gd")
const SimulationSnapshotService = preload("res://src/infrastructure/persistence/simulation_snapshot_service.gd")
const SimulationSnapshotBootstrapDecoder = preload("res://src/infrastructure/persistence/simulation_snapshot_bootstrap_decoder.gd")
const SimulationOwnerBootstrapper = preload("res://src/application/bootstrap/simulation_owner_bootstrapper.gd")

var _failures: Array[String] = []
var _completed := false


func _init() -> void:
	_run_test()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS snapshot_bootstrap_equivalence_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL snapshot_bootstrap_equivalence_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_test() -> void:
	var camp = DomainId.place(&"camp")
	var grove = DomainId.place(&"grove")
	var food_id = DomainId.entity(&"food_1")
	var shelter_id = DomainId.entity(&"shelter_1")
	var food_ref = RuntimeWorldRef.entity(food_id)
	var shelter_ref = RuntimeWorldRef.entity(shelter_id)

	var entities = EntityStore.new()
	_expect_true(entities.add_entity(EntityInstance.new(
		food_id,
		DomainId.entity_type(&"food"),
		camp,
		{DomainId.property(&"freshness").key(): 0.6},
		2
	)).ok, "food entity admitted")
	var shelter = EntityInstance.new(shelter_id, DomainId.entity_type(&"shelter"), grove)
	shelter.lifecycle = EntityInstance.Lifecycle.DESTROYED
	_expect_true(entities.add_entity(shelter).ok, "shelter entity admitted")

	var relations = WorldRelationStore.new()
	_expect_true(relations.add_relation(WorldRelation.new(
		DomainId.relation_type(&"stored_near"),
		food_ref,
		shelter_ref,
		&"north_side"
	)).ok, "relation admitted")

	var beliefs = BeliefStore.new()
	var claim = EpistemicClaim.property_claim(food_ref, DomainId.property(&"freshness"), 0.6)
	var proposition = BeliefProposition.new(claim)
	_expect_true(beliefs.restore_entry(proposition, 0.7, 3, &"exec_seen", &"vision").ok, "belief restored")

	var intentions = CurrentIntentionStore.new()
	var bindings = RoleBinding.new()
	bindings.bind(&"actor", RuntimeWorldRef.wilson())
	bindings.bind(&"target", food_ref)
	var intention_id = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"inspect_food")
	_expect_true(intentions.select(intention_id, bindings, &"step_17").ok, "intention selected")

	var snapshot_service = SimulationSnapshotService.new()
	var snapshot = snapshot_service.capture(
		entities,
		relations,
		WilsonWorldState.new(camp),
		beliefs,
		intentions
	)
	var legacy = snapshot_service.restore(snapshot)
	var definition = SimulationSnapshotBootstrapDecoder.new().decode(snapshot)
	var common_result = SimulationOwnerBootstrapper.new().bootstrap(definition)
	_expect_true(common_result.ok, "decoded snapshot enters common owner bootstrap")
	if not common_result.ok or common_result.owners == null:
		_completed = true
		return
	var common = common_result.owners

	_expect_equal(_entity_fingerprint(common.entities), _entity_fingerprint(legacy.entities), "common bootstrap matches legacy restored entities")
	_expect_equal(_relation_fingerprint(common.relations), _relation_fingerprint(legacy.relations), "common bootstrap matches legacy restored relations")
	_expect_equal(common.wilson_world_state.place_id.sort_key(), legacy.wilson_world_state.place_id.sort_key(), "common bootstrap matches Wilson place")
	_expect_equal(_belief_fingerprint(common.beliefs), _belief_fingerprint(legacy.beliefs), "common bootstrap matches legacy restored beliefs")
	_expect_equal(_intention_fingerprint(common.current_intention), _intention_fingerprint(legacy.current_intention), "common bootstrap matches legacy restored intention")
	_expect_true(common.entities != legacy.entities, "common path reconstructs fresh EntityStore")
	_expect_true(common.beliefs != legacy.beliefs, "common path reconstructs fresh BeliefStore")

	_completed = true


func _entity_fingerprint(store) -> Array:
	var result: Array = []
	for entity in store.entities():
		result.append({
			"id": entity.id.sort_key(),
			"type": entity.type_id.sort_key(),
			"place": entity.place_id.sort_key(),
			"lifecycle": entity.lifecycle,
			"quantity": entity.quantity,
			"overrides": entity.state_overrides(),
		})
	return result


func _relation_fingerprint(store) -> Array[String]:
	var result: Array[String] = []
	for relation in store.relations():
		result.append(relation.sort_key())
	return result


func _belief_fingerprint(store) -> Array:
	var result: Array = []
	for entry in store.entries():
		result.append({
			"claim": entry.proposition.sort_key(),
			"confidence": entry.confidence,
			"count": entry.evidence_count,
			"source": entry.last_source_execution_id,
			"modality": entry.last_modality,
		})
	return result


func _intention_fingerprint(store) -> Dictionary:
	if not store.has_current():
		return {}
	var current = store.current()
	var binding_keys: Array[String] = []
	for role_name in current.bindings.role_names():
		binding_keys.append("%s=%s" % [String(role_name), current.bindings.get_subject(role_name).sort_key()])
	binding_keys.sort()
	return {
		"intention": current.intention_id.sort_key(),
		"step": String(current.selected_step_id),
		"bindings": binding_keys,
	}


func _expect_true(actual: bool, label: String) -> void:
	if not actual:
		_failures.append("Expected true: %s" % label)


func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
