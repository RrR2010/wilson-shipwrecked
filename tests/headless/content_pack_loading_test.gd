extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const EntityInstance = preload("res://src/domain/world/entity_instance.gd")
const EntityStore = preload("res://src/domain/world/entity_store.gd")
const WorldRelation = preload("res://src/domain/world/world_relation.gd")
const WorldRelationStore = preload("res://src/domain/world/world_relation_store.gd")
const DefaultWorldQuery = preload("res://src/domain/world/default_world_query.gd")
const PropertyDependencyGraph = preload("res://src/domain/physical/property_dependency_graph.gd")
const PhysicalDerivationPolicyRegistry = preload("res://src/domain/physical/physical_derivation_policy_registry.gd")
const EffectivePhysicalProfileResolver = preload("res://src/domain/physical/effective_physical_profile_resolver.gd")
const AssemblyBindingProjection = preload("res://src/domain/physical/assembly_binding_projection.gd")
const AssemblyValidityResult = preload("res://src/domain/physical/assembly_validity_result.gd")
const AssemblyValidityService = preload("res://src/domain/physical/assembly_validity_service.gd")
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
	var pack = _valid_pack()
	var loader = ContentPackLoader.new()
	var loaded = loader.load_json(JSON.stringify(pack))
	_expect_true(loaded.ok, "valid authored pack loads")
	if not loaded.ok:
		return
	var content = loaded.value
	_expect_true(content.is_sealed(), "loaded registry is sealed")
	_expect_equal(content.property_definition_ids().size(), 4, "property definitions loaded")
	_expect_equal(content.event_definition_ids().size(), 1, "event definition loaded")
	_expect_equal(content.entity_definition_ids().size(), 4, "entity definitions loaded")
	_expect_equal(content.assembly_definition_ids().size(), 1, "assembly definition loaded")
	_expect_equal(content.property_derivation_definition_ids(), ["impact_capacity_v1"], "property derivation loaded")
	_expect_equal(content.action_definition_ids().size(), 1, "action definition loaded")
	_expect_equal(content.action_resolution_definition_ids(), ["hit_basic_v1"], "resolution definition loaded")

	var camp = DomainId.place(&"camp")
	var crate_id = DomainId.entity(&"crate_1")
	var host_id = DomainId.entity(&"tool_host_1")
	var head_id = DomainId.entity(&"stone_head_1")
	var handle_id = DomainId.entity(&"branch_handle_1")
	var entities = EntityStore.new()
	_expect_true(entities.add_entity(EntityInstance.new(crate_id, DomainId.entity_type(&"crate"), camp)).ok, "runtime crate added")
	_expect_true(entities.add_entity(EntityInstance.new(host_id, DomainId.entity_type(&"tool_host"), camp)).ok, "runtime host added")
	_expect_true(entities.add_entity(EntityInstance.new(head_id, DomainId.entity_type(&"stone_head"), camp)).ok, "runtime head added")
	_expect_true(entities.add_entity(EntityInstance.new(handle_id, DomainId.entity_type(&"branch_handle"), camp)).ok, "runtime handle added")

	var attached_to = DomainId.relation_type(&"attached_to")
	var relations = WorldRelationStore.new()
	var host = RuntimeWorldRef.entity(host_id)
	var head = RuntimeWorldRef.entity(head_id)
	var handle = RuntimeWorldRef.entity(handle_id)
	_expect_true(relations.add_relation(WorldRelation.new(attached_to, head, host, {"assembly_slot": DomainId.assembly_slot(&"head")})).ok, "head binding relation added")
	_expect_true(relations.add_relation(WorldRelation.new(attached_to, handle, host, {"assembly_slot": DomainId.assembly_slot(&"handle")})).ok, "handle binding relation added")

	var query = DefaultWorldQuery.new(entities, relations, content)
	var policies = PhysicalDerivationPolicyRegistry.new()
	var graph = PropertyDependencyGraph.new()
	_expect_true(graph.compile(content.property_derivation_definitions(), policies).ok, "loaded derivation graph compiles")
	var binding_projection = AssemblyBindingProjection.new(query, attached_to)
	var profiles = EffectivePhysicalProfileResolver.new(query, graph, policies, binding_projection)
	var evaluator = RequirementPredicateEvaluator.new(query, profiles)

	var assembly = content.get_assembly_definition(DomainId.assembly_definition(&"improvised_impact_tool"))
	var assembly_result = AssemblyValidityService.new(query, evaluator).evaluate(
		assembly,
		host,
		binding_projection.bindings_for_host(host)
	)
	_expect_equal(assembly_result.status, AssemblyValidityResult.Status.VALID, "loaded assembly validates projected bindings")
	_expect_equal(profiles.resolve(host).get_property(DomainId.property(&"impact_capacity")), 3, "loaded slot derivation produces effective physical property")

	var bindings = RoleBinding.new()
	bindings.bind(&"actor", RuntimeWorldRef.wilson())
	bindings.bind(&"target", RuntimeWorldRef.entity(crate_id))
	var action = content.get_action_definition(DomainId.action(&"hit"))
	var resolution = content.get_action_resolution_definition(&"hit_basic_v1")
	var execution = ActionExecutionService.new(ActionAttemptabilityService.new(evaluator))
	_expect_true(execution.start(&"exec_loaded", action, resolution, bindings) != null, "loaded action is attemptable/executable")

	var missing_event = _valid_pack()
	missing_event["events"] = []
	_expect_false(loader.load_dictionary(missing_event).ok, "resolution referencing missing typed event is rejected")

	var invalid_property = _valid_pack()
	invalid_property["entities"][0]["base_properties"]["structural_integrity"] = 9
	_expect_false(loader.load_dictionary(invalid_property).ok, "out-of-bounds authored property is rejected")

	var bad_predicate = _valid_pack()
	bad_predicate["actions"][0]["requirements"] = {"kind": "arbitrary_callback"}
	_expect_false(loader.load_dictionary(bad_predicate).ok, "unbounded authored predicate kind is rejected")

	var missing_derivation_property = _valid_pack()
	missing_derivation_property["property_derivations"][0]["output"] = "undeclared_output"
	_expect_false(loader.load_dictionary(missing_derivation_property).ok, "derivation with undeclared typed property is rejected")

	var unknown_selector = _valid_pack()
	unknown_selector["property_derivations"][0]["inputs"][0]["kind"] = "global_scan"
	_expect_false(loader.load_dictionary(unknown_selector).ok, "unbounded property selector kind is rejected")

	_completed = true


func _valid_pack() -> Dictionary:
	return {
		"schema_version": 1,
		"properties": [
			{"id": "structural_integrity", "family": "number", "min": 0, "max": 5},
			{"id": "hardness", "family": "number", "min": 0, "max": 5},
			{"id": "binding_integrity", "family": "number", "min": 0, "max": 5},
			{"id": "impact_capacity", "family": "number", "min": 0, "max": 5},
		],
		"events": [
			{"id": "impact_committed", "perceptible_roles": ["target"], "modalities": ["vision"], "base_confidence": 0.9},
		],
		"entities": [
			{"id": "crate", "base_properties": {"structural_integrity": 5}, "capabilities": ["receives_impact"]},
			{"id": "tool_host"},
			{"id": "stone_head", "base_properties": {"hardness": 4}, "capabilities": ["impact_surface"]},
			{"id": "branch_handle", "base_properties": {"structural_integrity": 3, "binding_integrity": 4}, "capabilities": ["structural_member"]},
		],
		"assemblies": [
			{
				"id": "improvised_impact_tool",
				"slots": [
					{"id": "head", "role": "head", "accepted_component": {"kind": "has_capability", "role": "component", "capability": "impact_surface"}},
					{"id": "handle", "role": "handle", "accepted_component": {"kind": "has_capability", "role": "component", "capability": "structural_member"}},
				],
			},
		],
		"property_derivations": [
			{
				"id": "impact_capacity_v1",
				"inputs": [
					{"kind": "assembly_slot", "slot": "head", "property": "hardness"},
					{"kind": "assembly_slot", "slot": "handle", "property": "structural_integrity"},
				],
				"output": "impact_capacity",
				"policy": "min_numeric",
			},
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


func _expect_true(actual: bool, label: String) -> void:
	if not actual:
		_failures.append("Expected true: %s" % label)

func _expect_false(actual: bool, label: String) -> void:
	if actual:
		_failures.append("Expected false: %s" % label)

func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
