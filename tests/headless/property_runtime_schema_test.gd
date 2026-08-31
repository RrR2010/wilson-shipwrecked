extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const ContentRegistry = preload("res://src/domain/content/content_registry.gd")
const PropertyDefinition = preload("res://src/domain/content/property_definition.gd")
const EntityDefinition = preload("res://src/domain/content/entity_definition.gd")
const EntityInstance = preload("res://src/domain/world/entity_instance.gd")
const EntityStore = preload("res://src/domain/world/entity_store.gd")
const WorldRelationStore = preload("res://src/domain/world/world_relation_store.gd")
const DefaultWorldQuery = preload("res://src/domain/world/default_world_query.gd")
const DefaultWorldCommandPort = preload("res://src/domain/world/default_world_command_port.gd")
const PropertyDependencyGraph = preload("res://src/domain/physical/property_dependency_graph.gd")
const EffectivePhysicalProfileResolver = preload("res://src/domain/physical/effective_physical_profile_resolver.gd")
const RequirementPredicate = preload("res://src/domain/actions/requirement_predicate.gd")
const RequirementPredicateEvaluator = preload("res://src/domain/actions/requirement_predicate_evaluator.gd")
const RoleBinding = preload("res://src/domain/actions/role_binding.gd")
const ActionEffect = preload("res://src/domain/actions/action_effect.gd")
const ActionOutcome = preload("res://src/domain/actions/action_outcome.gd")

var _failures: Array[String] = []
var _completed := false


func _init() -> void:
	_run_slice()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS property_runtime_schema_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL property_runtime_schema_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_slice() -> void:
	var integrity = DomainId.property(&"structural_integrity")
	var sealed = DomainId.property(&"sealed")
	var material_state = DomainId.property(&"material_state")
	var crate_type = DomainId.entity_type(&"crate")
	var camp = DomainId.place(&"camp")
	var damage_committed = DomainId.event_definition(&"damage_committed")

	var content = ContentRegistry.new()
	_expect_true(content.register_property_definition(PropertyDefinition.new(integrity, PropertyDefinition.ValueFamily.NUMBER, 0, 5)).ok, "numeric property schema registers")
	_expect_true(content.register_property_definition(PropertyDefinition.new(sealed, PropertyDefinition.ValueFamily.BOOLEAN)).ok, "boolean property schema registers")
	_expect_true(content.register_property_definition(PropertyDefinition.new(material_state, PropertyDefinition.ValueFamily.SYMBOL)).ok, "symbol property schema registers")
	_expect_true(content.register_entity_definition(EntityDefinition.new(
		crate_type,
		[],
		{
			integrity.key(): 4,
			sealed.key(): false,
			material_state.key(): &"dry",
		},
		[]
	)).ok, "entity definition registers")
	_expect_true(content.seal().ok, "typed content seals")

	var entities = EntityStore.new()
	var crate_id = DomainId.entity(&"crate_1")
	_expect_true(entities.add_entity(EntityInstance.new(crate_id, crate_type, camp)).ok, "crate added")
	var crate = RuntimeWorldRef.entity(crate_id)
	var relations = WorldRelationStore.new()
	var query = DefaultWorldQuery.new(entities, relations, content)
	var commands = DefaultWorldCommandPort.new(entities, relations, query)

	var bindings = RoleBinding.new()
	bindings.bind(&"target", crate)
	var invalid_outcome = ActionOutcome.new(
		&"exec_invalid",
		DomainId.action(&"damage"),
		bindings,
		[ActionEffect.new(ActionEffect.Kind.SET_PROPERTY, &"target", integrity, 9)],
		damage_committed
	)
	var invalid_commit = commands.apply_outcome(invalid_outcome)
	_expect_false(invalid_commit.ok, "out-of-bounds runtime property is rejected")
	_expect_equal(query.get_instance_property(crate, integrity), 4, "invalid property effect leaves World unchanged")
	_expect_equal(invalid_commit.events.size(), 0, "invalid property effect emits no event")
	_expect_true(invalid_commit.change_set.is_empty(), "invalid property effect emits no semantic change")

	var valid_outcome = ActionOutcome.new(
		&"exec_valid",
		DomainId.action(&"damage"),
		bindings,
		[ActionEffect.new(ActionEffect.Kind.SET_PROPERTY, &"target", integrity, 2)],
		damage_committed
	)
	var valid_commit = commands.apply_outcome(valid_outcome)
	_expect_true(valid_commit.ok, "valid runtime property is accepted")
	_expect_equal(query.get_instance_property(crate, integrity), 2, "valid property effect mutates World")

	var graph = PropertyDependencyGraph.new()
	_expect_true(graph.compile([]).ok, "empty property graph compiles")
	var evaluator = RequirementPredicateEvaluator.new(query, EffectivePhysicalProfileResolver.new(query, graph))

	var numeric_result = evaluator.evaluate(
		RequirementPredicate.property_compare(&"target", integrity, RequirementPredicate.CompareOp.GTE, 2),
		bindings
	)
	_expect_true(numeric_result.passed, "numeric ordered comparison remains valid")

	var bool_order_result = evaluator.evaluate(
		RequirementPredicate.property_compare(&"target", sealed, RequirementPredicate.CompareOp.GT, false),
		bindings
	)
	_expect_false(bool_order_result.passed, "boolean ordered comparison is rejected")
	_expect_true(_diagnostics_contain(bool_order_result.diagnostics, "does not support ordered comparison"), "boolean rejection is diagnostic")

	var wrong_expected_result = evaluator.evaluate(
		RequirementPredicate.property_compare(&"target", integrity, RequirementPredicate.CompareOp.EQ, &"high"),
		bindings
	)
	_expect_false(wrong_expected_result.passed, "wrong expected-value family is rejected")
	_expect_true(_diagnostics_contain(wrong_expected_result.diagnostics, "expected value violates property schema"), "wrong-family rejection is diagnostic")

	var symbol_eq_result = evaluator.evaluate(
		RequirementPredicate.property_compare(&"target", material_state, RequirementPredicate.CompareOp.EQ, &"dry"),
		bindings
	)
	_expect_true(symbol_eq_result.passed, "symbol equality remains valid")

	_completed = true


func _diagnostics_contain(diagnostics: Array[String], fragment: String) -> bool:
	for diagnostic in diagnostics:
		if diagnostic.contains(fragment):
			return true
	return false


func _expect_true(actual: bool, label: String) -> void:
	if not actual:
		_failures.append("Expected true: %s" % label)


func _expect_false(actual: bool, label: String) -> void:
	if actual:
		_failures.append("Expected false: %s" % label)


func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
