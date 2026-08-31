extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const ContentRegistry = preload("res://src/domain/content/content_registry.gd")
const EntityDefinition = preload("res://src/domain/content/entity_definition.gd")
const EntityInstance = preload("res://src/domain/world/entity_instance.gd")
const EntityStore = preload("res://src/domain/world/entity_store.gd")
const WorldRelationStore = preload("res://src/domain/world/world_relation_store.gd")
const DefaultWorldQuery = preload("res://src/domain/world/default_world_query.gd")
const PropertyDependencyGraph = preload("res://src/domain/physical/property_dependency_graph.gd")
const EffectivePhysicalProfileResolver = preload("res://src/domain/physical/effective_physical_profile_resolver.gd")
const RequirementPredicate = preload("res://src/domain/actions/requirement_predicate.gd")
const RequirementPredicateEvaluator = preload("res://src/domain/actions/requirement_predicate_evaluator.gd")
const SemanticPattern = preload("res://src/domain/actions/semantic_pattern.gd")
const SemanticPatternMatcher = preload("res://src/domain/actions/semantic_pattern_matcher.gd")
const RoleBinding = preload("res://src/domain/actions/role_binding.gd")
const ActionDefinition = preload("res://src/domain/actions/action_definition.gd")
const ActionAttemptabilityService = preload("res://src/domain/actions/action_attemptability_service.gd")

var _failures: Array[String] = []
var _completed := false


func _init() -> void:
	_run_slice()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS action_attemptability_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL action_attemptability_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_slice() -> void:
	var stone_type = DomainId.entity_type(&"stone_small")
	var branch_type = DomainId.entity_type(&"branch")
	var crate_type = DomainId.entity_type(&"crate")
	var hardness = DomainId.property(&"hardness")
	var impact_surface = DomainId.capability(&"impact_surface")
	var receives_impact = DomainId.capability(&"receives_impact")
	var camp = DomainId.place(&"camp")

	var content = ContentRegistry.new()
	_expect_true(content.register_entity_definition(EntityDefinition.new(
		stone_type, [], {hardness.key(): 4}, [impact_surface]
	)).ok, "stone definition registers")
	_expect_true(content.register_entity_definition(EntityDefinition.new(
		branch_type, [], {hardness.key(): 1}, [impact_surface]
	)).ok, "branch definition registers")
	_expect_true(content.register_entity_definition(EntityDefinition.new(
		crate_type, [], {}, [receives_impact]
	)).ok, "crate definition registers")
	_expect_true(content.seal().ok, "content seals")

	var entities = EntityStore.new()
	var stone_id = DomainId.entity(&"stone_42")
	var branch_id = DomainId.entity(&"branch_3")
	var crate_id = DomainId.entity(&"crate_4")
	_expect_true(entities.add_entity(EntityInstance.new(stone_id, stone_type, camp)).ok, "stone instance added")
	_expect_true(entities.add_entity(EntityInstance.new(branch_id, branch_type, camp)).ok, "branch instance added")
	_expect_true(entities.add_entity(EntityInstance.new(crate_id, crate_type, camp)).ok, "crate instance added")

	var stone = RuntimeWorldRef.entity(stone_id)
	var branch = RuntimeWorldRef.entity(branch_id)
	var crate = RuntimeWorldRef.entity(crate_id)
	var wilson = RuntimeWorldRef.wilson()

	var relations = WorldRelationStore.new()
	var world_query = DefaultWorldQuery.new(entities, relations, content)
	var dependency_graph = PropertyDependencyGraph.new()
	_expect_true(dependency_graph.compile([]).ok, "empty property DAG compiles")
	var profiles = EffectivePhysicalProfileResolver.new(world_query, dependency_graph)
	var evaluator = RequirementPredicateEvaluator.new(world_query, profiles)

	var requirements = RequirementPredicate.all_of([
		RequirementPredicate.has_capability(&"tool", impact_surface),
		RequirementPredicate.property_compare(&"tool", hardness, RequirementPredicate.CompareOp.GTE, 3),
		RequirementPredicate.has_capability(&"target", receives_impact),
	])

	var pattern = SemanticPattern.new([&"tool", &"target"], requirements)
	var matcher = SemanticPatternMatcher.new(evaluator)
	var matches = matcher.match(pattern, {
		&"tool": [branch, stone],
		&"target": [crate],
	}, 10)
	_expect_equal(matches.size(), 1, "pattern filters weak tool")
	if matches.size() == 1:
		_expect_equal(matches[0].get_subject(&"tool").key(), stone.key(), "stone is discovered as viable tool")
		_expect_equal(matches[0].get_subject(&"target").key(), crate.key(), "crate remains target")

	var hit = ActionDefinition.new(DomainId.action(&"hit"), [&"actor", &"tool", &"target"], requirements)
	var attemptability = ActionAttemptabilityService.new(evaluator)

	var valid = RoleBinding.new()
	valid.bind(&"actor", wilson)
	valid.bind(&"tool", stone)
	valid.bind(&"target", crate)
	var valid_result = attemptability.query(hit, valid)
	_expect_true(valid_result.attemptable, "valid hit binding is attemptable")
	_expect_equal(String(valid_result.code), "attemptable", "valid hit result code")
	_expect_true(not valid_result.diagnostics.is_empty(), "valid attempt includes predicate diagnostics")

	var weak = RoleBinding.new()
	weak.bind(&"actor", wilson)
	weak.bind(&"tool", branch)
	weak.bind(&"target", crate)
	var weak_result = attemptability.query(hit, weak)
	_expect_false(weak_result.attemptable, "weak branch fails hardness requirement")
	_expect_equal(String(weak_result.code), "requirements_failed", "failed requirements code")

	var incomplete = RoleBinding.new()
	incomplete.bind(&"actor", wilson)
	incomplete.bind(&"tool", stone)
	var incomplete_result = attemptability.query(hit, incomplete)
	_expect_false(incomplete_result.attemptable, "missing target role rejected")
	_expect_equal(String(incomplete_result.code), "missing_role", "missing role diagnostic code")

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
