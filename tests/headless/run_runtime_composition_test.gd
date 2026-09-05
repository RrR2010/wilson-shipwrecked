extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const EntityInstance = preload("res://src/domain/world/entity_instance.gd")
const EntityStore = preload("res://src/domain/world/entity_store.gd")
const WorldRelationStore = preload("res://src/domain/world/world_relation_store.gd")
const WilsonWorldState = preload("res://src/domain/world/wilson_world_state.gd")
const BeliefStore = preload("res://src/domain/cognition/belief_store.gd")
const CurrentIntentionStore = preload("res://src/domain/cognition/current_intention_store.gd")
const RoleBinding = preload("res://src/domain/actions/role_binding.gd")
const ContentPackLoader = preload("res://src/infrastructure/content_loading/content_pack_loader.gd")
const RunRuntimeComposer = preload("res://src/application/simulation/run_runtime_composer.gd")

var _failures: Array[String] = []
var _completed := false


func _init() -> void:
	_run_tests()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS run_runtime_composition_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL run_runtime_composition_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_tests() -> void:
	_test_valid_runtime_composition()
	_test_invalid_derived_policy_rejected_during_composition()
	_completed = true


func _test_valid_runtime_composition() -> void:
	var loaded = ContentPackLoader.new().load_dictionary(_content_pack(&"min_numeric"))
	_expect_true(loaded.ok, "valid content loads")
	if not loaded.ok:
		return

	var camp = DomainId.place(&"camp")
	var crate_id = DomainId.entity(&"crate_1")
	var crate_ref = RuntimeWorldRef.entity(crate_id)
	var entities = EntityStore.new()
	_expect_true(
		entities.add_entity(EntityInstance.new(crate_id, DomainId.entity_type(&"crate"), camp)).ok,
		"authoritative entity admitted before composition"
	)
	var relations = WorldRelationStore.new()
	var wilson_world = WilsonWorldState.new(camp)
	var beliefs = BeliefStore.new()
	var intentions = CurrentIntentionStore.new()

	var result = RunRuntimeComposer.new().compose(
		entities,
		relations,
		wilson_world,
		beliefs,
		intentions,
		loaded.value
	)
	_expect_true(result.ok, "valid authoritative state composes")
	_expect_equal(result.code, &"run_runtime_composed", "composition returns explicit success code")
	_expect_true(result.composition != null, "successful composition exposes runtime")
	if not result.ok or result.composition == null:
		return

	var runtime = result.composition
	_expect_equal(
		runtime.world_query.get_instance_property(crate_ref, DomainId.property(&"effective_resistance")),
		4,
		"derived physical query is rebuilt by composition"
	)
	_expect_equal(runtime.activity_query.active_execution_id(), &"", "fresh runtime has no active Wilson action")

	var bindings = RoleBinding.new()
	bindings.bind(&"actor", RuntimeWorldRef.wilson())
	bindings.bind(&"target", crate_ref)
	var action = loaded.value.get_action_definition(DomainId.action(&"hit"))
	var resolution = loaded.value.get_action_resolution_definition(&"hit_basic_v1")
	_expect_true(runtime.action_execution.start(&"exec_runtime", action, resolution, bindings) != null, "composed action service starts authored action")
	_expect_equal(runtime.activity_query.active_execution_id(), &"exec_runtime", "activity query observes composed execution owner")

	var crossing = runtime.action_execution.advance(&"exec_runtime", 0.5)
	_expect_true(crossing != null and crossing.committed, "composed execution crosses commit")
	_expect_true(crossing != null and crossing.new_outcome != null, "commit produces one authoritative outcome")
	if crossing == null or crossing.new_outcome == null:
		return

	var commit = runtime.world_commands.apply_outcome(crossing.new_outcome)
	_expect_true(commit.ok, "composed World command port admits outcome")
	runtime.derived_invalidator.apply(commit.change_set)
	_expect_equal(
		runtime.world_query.get_instance_property(crate_ref, DomainId.property(&"structural_integrity")),
		2,
		"authoritative World mutation is visible through composed query"
	)
	_expect_equal(
		runtime.effective_physical_profiles.resolve(crate_ref).get_property(DomainId.property(&"effective_resistance")),
		2,
		"derived profile recomputes after composed invalidation"
	)

	var access = runtime.perception_access.resolve(commit.events, null)
	var perception = runtime.perception.perceive(commit.events, access)
	var learning = runtime.learning.process(perception)
	_expect_equal(perception.evidence.size(), 1, "composed perception exposes grounded event evidence")
	_expect_equal(learning.get("mutation_results", []).size(), 1, "composed learning reaches cognition owner")
	_expect_equal(beliefs.entries().size(), 1, "learning mutates the supplied authoritative BeliefStore")


func _test_invalid_derived_policy_rejected_during_composition() -> void:
	var loaded = ContentPackLoader.new().load_dictionary(_content_pack(&"not_supported"))
	_expect_true(loaded.ok, "content loader admits policy id for bootstrap validation")
	if not loaded.ok:
		return
	var result = RunRuntimeComposer.new().compose(
		EntityStore.new(),
		WorldRelationStore.new(),
		WilsonWorldState.new(DomainId.place(&"camp")),
		BeliefStore.new(),
		CurrentIntentionStore.new(),
		loaded.value
	)
	_expect_false(result.ok, "unsupported derived policy fails runtime admission")
	_expect_equal(result.code, &"unsupported_property_derivation_policy", "composition preserves graph validation failure code")
	_expect_true(not result.diagnostics.is_empty(), "composition exposes bounded validation diagnostics")
	_expect_true(result.composition == null, "failed composition exposes no partial runtime")


func _content_pack(policy_id: StringName) -> Dictionary:
	return {
		"schema_version": 1,
		"properties": [
			{"id": "structural_integrity", "family": "number", "min": 0, "max": 5},
			{"id": "hardness", "family": "number", "min": 0, "max": 5},
			{"id": "effective_resistance", "family": "number", "min": 0, "max": 5},
		],
		"events": [
			{"id": "impact_committed", "perceptible_roles": ["target"], "modalities": ["vision", "hearing"], "base_confidence": 0.85},
		],
		"entities": [
			{"id": "crate", "base_properties": {"structural_integrity": 5, "hardness": 4}, "capabilities": ["receives_impact"]},
		],
		"property_derivations": [
			{
				"id": "effective_resistance_v1",
				"inputs": [
					{"kind": "self", "property": "hardness"},
					{"kind": "self", "property": "structural_integrity"},
				],
				"output": "effective_resistance",
				"policy": String(policy_id),
			},
		],
		"actions": [
			{"id": "hit", "roles": ["actor", "target"], "requirements": {"kind": "has_capability", "role": "target", "capability": "receives_impact"}},
		],
		"resolutions": [
			{
				"id": "hit_basic_v1",
				"action": "hit",
				"duration": 1.0,
				"commit_fraction": 0.5,
				"event": "impact_committed",
				"effects": [{"kind": "set_property", "subject_role": "target", "property": "structural_integrity", "value": 2}],
			},
		],
	}


func _expect_true(actual: bool, label: String) -> void:
	if not actual:
		_failures.append("Expected true: %s" % label)


func _expect_false(actual: bool, label: String) -> void:
	if actual:
		_failures.append("Expected false: %s" % label)


func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
