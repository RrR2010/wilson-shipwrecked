extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const EntityInstance = preload("res://src/domain/world/entity_instance.gd")
const EntityStore = preload("res://src/domain/world/entity_store.gd")
const WorldRelationStore = preload("res://src/domain/world/world_relation_store.gd")
const WilsonWorldState = preload("res://src/domain/world/wilson_world_state.gd")
const BeliefStore = preload("res://src/domain/cognition/belief_store.gd")
const CurrentIntentionStore = preload("res://src/domain/cognition/current_intention_store.gd")
const EpistemicClaim = preload("res://src/domain/cognition/epistemic_claim.gd")
const RoleBinding = preload("res://src/domain/actions/role_binding.gd")
const ContentPackLoader = preload("res://src/infrastructure/content_loading/content_pack_loader.gd")
const RunRuntimeComposer = preload("res://src/application/simulation/run_runtime_composer.gd")

var _failures: Array[String] = []
var _completed := false


func _init() -> void:
	_run_test()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS run_runtime_non_empty_cognition_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL run_runtime_non_empty_cognition_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_test() -> void:
	var loaded = ContentPackLoader.new().load_dictionary({
		"schema_version": 1,
		"properties": [
			{"id": "freshness", "family": "number", "min": 0.0, "max": 1.0},
		],
		"entities": [
			{"id": "food", "base_properties": {"freshness": 0.75}, "capabilities": []},
		],
	})
	_expect_true(loaded.ok, "cognition fixture content loads")
	if not loaded.ok:
		_completed = true
		return

	var camp = DomainId.place(&"camp")
	var food_id = DomainId.entity(&"food_1")
	var food_ref = RuntimeWorldRef.entity(food_id)
	var entities = EntityStore.new()
	_expect_true(
		entities.add_entity(EntityInstance.new(food_id, DomainId.entity_type(&"food"), camp)).ok,
		"food entity admitted"
	)

	var beliefs = BeliefStore.new()
	var claim = EpistemicClaim.property_claim(food_ref, DomainId.property(&"freshness"), 0.75)
	_expect_true(
		beliefs.restore_entry(claim, 0.8, 2, &"exec_observed_food", &"vision").ok,
		"pre-existing belief restored before composition"
	)

	var intentions = CurrentIntentionStore.new()
	var bindings = RoleBinding.new()
	bindings.bind(&"actor", RuntimeWorldRef.wilson())
	bindings.bind(&"target", food_ref)
	var intention_id = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"seek_food")
	_expect_true(
		intentions.select(intention_id, bindings, &"step_restored_42").ok,
		"pre-existing intention selected before composition"
	)

	var belief_before = beliefs.get_entry(claim)
	var intention_before = intentions.current()
	var result = RunRuntimeComposer.new().compose(
		entities,
		WorldRelationStore.new(),
		WilsonWorldState.new(camp),
		beliefs,
		intentions,
		loaded.value
	)
	_expect_true(result.ok, "runtime composes over non-empty cognition")
	if not result.ok or result.composition == null:
		_completed = true
		return

	var runtime = result.composition
	var belief_after = beliefs.get_entry(claim)
	var intention_after = runtime.activity_query.current_intention()

	_expect_true(belief_after == belief_before, "compose preserves supplied belief entry instance")
	_expect_equal(beliefs.entry_count(), 1, "compose does not duplicate or clear restored beliefs")
	_expect_equal(belief_after.confidence, 0.8, "restored belief confidence survives composition")
	_expect_equal(belief_after.evidence_count, 2, "restored belief evidence count survives composition")
	_expect_equal(belief_after.last_source_execution_id, &"exec_observed_food", "restored belief provenance survives composition")
	_expect_true(intention_after == intention_before, "activity query exposes supplied current intention owner state")
	_expect_true(intention_after.intention_id.equals(intention_id), "restored semantic intention survives composition")
	_expect_equal(intention_after.selected_step_id, &"step_restored_42", "restored intention selection step survives composition")
	_expect_true(intention_after.bindings.get_subject(&"target").equals(food_ref), "restored intention bindings survive composition")
	_expect_equal(runtime.activity_query.active_execution_id(), &"", "restored intention does not fabricate an active action execution")

	_completed = true


func _expect_true(actual: bool, label: String) -> void:
	if not actual:
		_failures.append("Expected true: %s" % label)


func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
