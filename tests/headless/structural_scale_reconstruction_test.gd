extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const ContentRegistry = preload("res://src/domain/content/content_registry.gd")
const EntityDefinition = preload("res://src/domain/content/entity_definition.gd")
const EntityInstance = preload("res://src/domain/world/entity_instance.gd")
const EntityStore = preload("res://src/domain/world/entity_store.gd")
const WilsonWorldState = preload("res://src/domain/world/wilson_world_state.gd")
const WorldRelation = preload("res://src/domain/world/world_relation.gd")
const WorldRelationStore = preload("res://src/domain/world/world_relation_store.gd")
const DefaultWorldQuery = preload("res://src/domain/world/default_world_query.gd")
const EpistemicClaim = preload("res://src/domain/cognition/epistemic_claim.gd")
const BeliefProposition = preload("res://src/domain/cognition/belief_proposition.gd")
const BeliefStore = preload("res://src/domain/cognition/belief_store.gd")
const CurrentIntentionStore = preload("res://src/domain/cognition/current_intention_store.gd")
const EpistemicGraphProjection = preload("res://src/domain/cognition/epistemic_graph_projection.gd")
const SimulationSnapshotService = preload("res://src/infrastructure/persistence/simulation_snapshot_service.gd")

const ENTITY_COUNT := 200
const RELATION_CHAIN_COUNT := 120
const BELIEF_COUNT := 120

var _failures: Array[String] = []
var _completed := false


func _init() -> void:
	_run_stress_fixture()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS structural_scale_reconstruction_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL structural_scale_reconstruction_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_stress_fixture() -> void:
	var places = [
		DomainId.place(&"place_0"),
		DomainId.place(&"place_1"),
		DomainId.place(&"place_2"),
		DomainId.place(&"place_3"),
	]
	var generic_type = DomainId.entity_type(&"generic_item")
	var inspectable = DomainId.category(&"inspectable")
	var graspable = DomainId.capability(&"graspable")
	var content = ContentRegistry.new()
	_expect_true(content.register_entity_definition(EntityDefinition.new(generic_type, [inspectable], {}, [graspable])).ok, "generic entity definition registers")
	_expect_true(content.seal().ok, "content seals")

	var entities = EntityStore.new()
	var refs: Array = []
	for index in range(ENTITY_COUNT):
		var entity_id = DomainId.entity(StringName("item_%03d" % index))
		_expect_true(entities.add_entity(EntityInstance.new(entity_id, generic_type, places[index % places.size()])).ok, "scaled entity adds")
		refs.append(RuntimeWorldRef.entity(entity_id))
	_expect_equal(entities.entities().size(), ENTITY_COUNT, "all scaled entities stored")

	var linked_to = DomainId.relation_type(&"linked_to")
	var relations = WorldRelationStore.new()
	for index in range(RELATION_CHAIN_COUNT - 1):
		_expect_true(relations.add_relation(WorldRelation.new(linked_to, refs[index], refs[index + 1])).ok, "scaled relation adds")
	_expect_equal(relations.relation_count(), RELATION_CHAIN_COUNT - 1, "relation chain stored")
	_expect_true(relations.validate_indexes().ok, "relation indexes valid at scale")

	var wilson_world = WilsonWorldState.new(places[0])
	var query = DefaultWorldQuery.new(entities, relations, content, wilson_world)
	var nearby = query.query_nearby(RuntimeWorldRef.wilson(), {"limit": 15})
	_expect_equal(nearby.size(), 15, "nearby query respects explicit result limit")
	_expect_true(_is_sorted_refs(nearby), "nearby results deterministic")
	_expect_equal(query.query_nearby(RuntimeWorldRef.wilson(), {"limit": 10, "category_id": inspectable}).size(), 10, "category-filtered nearby query remains bounded")
	_expect_equal(query.query_nearby(RuntimeWorldRef.wilson(), {"limit": 7, "capability_id": graspable}).size(), 7, "capability-filtered nearby query remains bounded")

	var traversal = relations.traverse_relations(refs[0], [linked_to], RELATION_CHAIN_COUNT, 25)
	_expect_equal(traversal.subjects.size(), 25, "relation traversal respects result bound")
	_expect_true(traversal.truncated, "relation traversal reports truncation")
	_expect_equal(traversal.subjects[0].key(), refs[1].key(), "relation traversal begins at first neighbor")
	_expect_equal(traversal.subjects[24].key(), refs[25].key(), "relation traversal preserves deterministic chain order")

	var beliefs = BeliefStore.new()
	var event_id = DomainId.event_definition(&"observed_change")
	var property_id = DomainId.property(&"condition")
	var near_id = DomainId.relation_type(&"near")
	for index in range(BELIEF_COUNT):
		var subject = refs[index]
		var claim = null
		match index % 3:
			0:
				claim = EpistemicClaim.event_claim(subject, event_id, &"target")
			1:
				claim = EpistemicClaim.property_claim(subject, property_id, index % 5)
			2:
				claim = EpistemicClaim.relation_claim(subject, near_id, refs[(index + 1) % ENTITY_COUNT])
		_expect_true(beliefs.restore_entry(BeliefProposition.new(claim), 0.5, 1, &"stress_fixture", &"vision").ok, "scaled belief restores")
	_expect_equal(beliefs.entries().size(), BELIEF_COUNT, "all scaled beliefs stored")

	var epistemic = EpistemicGraphProjection.new()
	epistemic.rebuild(beliefs)
	_expect_equal(epistemic.query_by_kind(EpistemicClaim.Kind.EVENT).size(), 40, "event claim index count")
	_expect_equal(epistemic.query_by_kind(EpistemicClaim.Kind.PROPERTY).size(), 40, "property claim index count")
	_expect_equal(epistemic.query_by_kind(EpistemicClaim.Kind.RELATION).size(), 40, "relation claim index count")
	_expect_equal(epistemic.query_by_semantic_id(event_id).size(), 40, "event semantic index count")
	_expect_equal(epistemic.query_by_semantic_id(property_id).size(), 40, "property semantic index count")
	_expect_equal(epistemic.query_by_semantic_id(near_id).size(), 40, "relation semantic index count")

	# Large JSON reconstruction stores causes and rebuilds both relation/epistemic indexes.
	var persistence = SimulationSnapshotService.new()
	var snapshot = persistence.capture(entities, relations, wilson_world, beliefs, CurrentIntentionStore.new())
	var parsed = JSON.parse_string(JSON.stringify(snapshot))
	_expect_true(parsed is Dictionary, "scaled snapshot survives JSON")
	if not (parsed is Dictionary):
		return
	var restored = persistence.restore(parsed)
	_expect_equal(restored.entities.entities().size(), ENTITY_COUNT, "scaled entities survive reconstruction")
	_expect_equal(restored.relations.relation_count(), RELATION_CHAIN_COUNT - 1, "scaled relations survive reconstruction")
	_expect_true(restored.relations.validate_indexes().ok, "relation indexes rebuild valid at scale")
	_expect_equal(restored.beliefs.entries().size(), BELIEF_COUNT, "scaled beliefs survive reconstruction")
	_expect_equal(restored.epistemic_projection.query_by_kind(EpistemicClaim.Kind.EVENT).size(), 40, "epistemic kind index rebuilds at scale")
	_expect_equal(restored.epistemic_projection.query_by_semantic_id(near_id).size(), 40, "epistemic semantic index rebuilds at scale")
	_expect_equal(restored.wilson_world_state.place_id.key(), places[0].key(), "Wilson spatial truth survives scaled reconstruction")
	var restored_query = DefaultWorldQuery.new(restored.entities, restored.relations, content, restored.wilson_world_state)
	var nearby_after = restored_query.query_nearby(RuntimeWorldRef.wilson(), {"limit": 15})
	_expect_equal(nearby_after.size(), nearby.size(), "bounded nearby query count stable after reconstruction")
	for index in range(nearby.size()):
		_expect_equal(nearby_after[index].key(), nearby[index].key(), "nearby query ordering stable after reconstruction")

	_completed = true


func _is_sorted_refs(refs: Array) -> bool:
	for index in range(1, refs.size()):
		if refs[index - 1].sort_key() > refs[index].sort_key():
			return false
	return true


func _expect_true(actual: bool, label: String) -> void:
	if not actual:
		_failures.append("Expected true: %s" % label)

func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
