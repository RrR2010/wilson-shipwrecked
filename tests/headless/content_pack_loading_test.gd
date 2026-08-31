extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const EntityInstance = preload("res://src/domain/world/entity_instance.gd")
const EntityStore = preload("res://src/domain/world/entity_store.gd")
const WorldRelationStore = preload("res://src/domain/world/world_relation_store.gd")
const DefaultWorldQuery = preload("res://src/domain/world/default_world_query.gd")
const PropertyDependencyGraph = preload("res://src/domain/physical/property_dependency_graph.gd")
const EffectivePhysicalProfileResolver = preload("res://src/domain/physical/effective_physical_profile_resolver.gd")
const RequirementPredicateEvaluator = preload("res://src/domain/actions/requirement_predicate_evaluator.gd")
const ActionAttemptabilityService = preload("res://src/domain/actions/action_attemptability_service.gd")
const ActionExecutionService = preload("res://src/domain/actions/action_execution_service.gd")
const RoleBinding = preload("res://src/domain/actions/role_binding.gd")
const ContentPackLoader = preload("res://src/infrastructure/content_loading/content_pack_loader.gd")

var _failures: Array[String] = []
var _completed := false


func _init() -> void:
	_run_slice()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS content_pack_loading_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL content_pack_loading_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_slice() -> void:
	var pack = {
		"schema_version": 1,
		"properties": [
			{"id": "structural_integrity", "family": "number", "min": 0, "max": 5},
		],
		"events": [
			{"id": "impact_committed", "perceptible_roles": ["target"], "modalities": ["vision"], "base_confidence": 0.9},
		],
		"entities": [
			{"id": "crate", "base_properties": {"structural_integrity": 5}, "capabilities": ["receives_impact"]},
		],
		"actions": [
			{
				"id": "hit",
				"roles": ["actor", "target"],
				"interruption": "pre_commit_only",
				"requirements": {"kind": "has_capability", "role": "target", "capability": "receives_impact"},
			},
		],
		"resolutions": [
			{
				"id": "hit_basic_v1",
				"action": "hit",
				"duration": 1.0,
				"commit_fraction": 0.5,
				"event": "impact_committed",
				"effects": [
					{"kind": "set_property", "subject_role": "target", "property": "structural_integrity", "value": 3},
				],
			},
		],
	}
	var loader = ContentPackLoader.new()
	var json_text = JSON.stringify(pack)
	var loaded = loader.load_json(json_text)
	_expect_true(loaded.ok, "valid authored pack loads")
	if not loaded.ok:
		return
	var content = loaded.value
	_expect_true(content.is_sealed(), "loaded registry is sealed")
	_expect_equal(content.property_definition_ids().size(), 1, "property definition loaded")
	_expect_equal(content.event_definition_ids().size(), 1, "event definition loaded")
	_expect_equal(content.entity_definition_ids().size(), 1, "entity definition loaded")
	_expect_equal(content.action_definition_ids().size(), 1, "action definition loaded")
	_expect_equal(content.action_resolution_definition_ids(), ["hit_basic_v1"], "resolution definition loaded")

	# Loaded authored definitions are directly executable through the normal domain path.
	var camp = DomainId.place(&"camp")
	var crate_id = DomainId.entity(&"crate_1")
	var entities = EntityStore.new()
	_expect_true(entities.add_entity(EntityInstance.new(crate_id, DomainId.entity_type(&"crate"), camp)).ok, "runtime crate added")
	var query = DefaultWorldQuery.new(entities, WorldRelationStore.new(), content)
	var graph = PropertyDependencyGraph.new()
	_expect_true(graph.compile([]).ok, "empty property graph compiles")
	var evaluator = RequirementPredicateEvaluator.new(query, EffectivePhysicalProfileResolver.new(query, graph))
	var execution = ActionExecutionService.new(ActionAttemptabilityService.new(evaluator))
	var bindings = RoleBinding.new()
	bindings.bind(&"actor", RuntimeWorldRef.wilson())
	bindings.bind(&"target", RuntimeWorldRef.entity(crate_id))
	var action = content.get_action_definition(DomainId.action(&"hit"))
	var resolution = content.get_action_resolution_definition(&"hit_basic_v1")
	_expect_true(execution.start(&"exec_loaded", action, resolution, bindings) != null, "loaded action is attemptable/executable")

	var missing_event = pack.duplicate(true)
	missing_event["events"] = []
	var missing_event_result = loader.load_dictionary(missing_event)
	_expect_false(missing_event_result.ok, "resolution referencing missing typed event is rejected")

	var invalid_property = pack.duplicate(true)
	invalid_property["entities"][0]["base_properties"]["structural_integrity"] = 9
	var invalid_property_result = loader.load_dictionary(invalid_property)
	_expect_false(invalid_property_result.ok, "out-of-bounds authored property is rejected")

	var bad_predicate = pack.duplicate(true)
	bad_predicate["actions"][0]["requirements"] = {"kind": "arbitrary_callback"}
	var bad_predicate_result = loader.load_dictionary(bad_predicate)
	_expect_false(bad_predicate_result.ok, "unbounded authored predicate kind is rejected")

	_completed = true


func _expect_true(actual: bool, label: String) -> void:
	if not actual:
		_failures.append("Expected true: %s" % label)


func _expect_false(actual: bool, label: String) -> void:
	if actual:
		_failures.append("Expected false: %s" % label)


func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
