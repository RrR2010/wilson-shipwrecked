extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const ContentRegistry = preload("res://src/domain/content/content_registry.gd")
const EntityDefinition = preload("res://src/domain/content/entity_definition.gd")
const EntityInstance = preload("res://src/domain/world/entity_instance.gd")
const EntityStore = preload("res://src/domain/world/entity_store.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const WorldRelationStore = preload("res://src/domain/world/world_relation_store.gd")
const DefaultWorldQuery = preload("res://src/domain/world/default_world_query.gd")
const PropertyDerivationDefinition = preload("res://src/domain/physical/property_derivation_definition.gd")
const PropertyDependencyGraph = preload("res://src/domain/physical/property_dependency_graph.gd")
const EffectivePhysicalProfileResolver = preload("res://src/domain/physical/effective_physical_profile_resolver.gd")

var _failures: Array[String] = []
var _completed := false


func _init() -> void:
	_run_slice()
	if not _completed:
		_failures.append("Test body did not complete; likely interrupted by runtime error")
	if _failures.is_empty():
		print("PASS effective_physical_profile_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL effective_physical_profile_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_slice() -> void:
	var tool_type = DomainId.entity_type(&"improvised_tool")
	var tool_id = DomainId.entity(&"tool_1")
	var camp = DomainId.place(&"camp")
	var hardness = DomainId.property(&"hardness")
	var structural_integrity = DomainId.property(&"structural_integrity")
	var mass_class = DomainId.property(&"mass_class")
	var effective_resistance = DomainId.property(&"effective_resistance")
	var impact_capacity = DomainId.property(&"impact_capacity")

	var content = ContentRegistry.new()
	_expect_true(content.register_entity_definition(EntityDefinition.new(
		tool_type,
		[],
		{
			hardness.key(): 4,
			structural_integrity.key(): 3,
			mass_class.key(): 2,
		},
		[]
	)).ok, "tool definition registers")
	content.seal()

	var entities = EntityStore.new()
	_expect_true(entities.add_entity(EntityInstance.new(tool_id, tool_type, camp)).ok, "tool instance added")
	var subject = RuntimeWorldRef.entity(tool_id)
	var query = DefaultWorldQuery.new(entities, WorldRelationStore.new(), content)

	var resistance_rule = PropertyDerivationDefinition.new(
		&"effective_resistance_v1",
		[hardness, structural_integrity],
		effective_resistance,
		&"min_numeric"
	)
	var impact_rule = PropertyDerivationDefinition.new(
		&"impact_capacity_v1",
		[mass_class, effective_resistance],
		impact_capacity,
		&"min_numeric"
	)
	var graph = PropertyDependencyGraph.new()
	_expect_true(graph.compile([resistance_rule, impact_rule]).ok, "dependency graph compiles")
	_expect_equal(_property_keys(graph.topological_outputs()), [effective_resistance.sort_key(), impact_capacity.sort_key()], "topological order follows dependencies")

	var resolver = EffectivePhysicalProfileResolver.new(query, graph)
	var profile = resolver.resolve(subject)
	_expect_equal(profile.get_property(effective_resistance), 3, "first derived property resolves")
	_expect_equal(profile.get_property(impact_capacity), 2, "chained derived property resolves")
	_expect_equal(resolver.cached_subject_count(), 1, "profile cached")

	var explanation = profile.explain(impact_capacity)
	_expect_equal(explanation.get("rule_id"), "impact_capacity_v1", "provenance exposes rule")
	_expect_equal(explanation.get("policy_id"), "min_numeric", "provenance exposes policy")
	_expect_equal(explanation.get("inputs", []).size(), 2, "provenance exposes inputs")

	_expect_true(entities.set_property_override(tool_id, structural_integrity, 1).ok, "world owner mutates base property")
	_expect_equal(resolver.resolve(subject).get_property(impact_capacity), 2, "cached profile remains stable before invalidation")
	var affected = resolver.invalidate(subject, structural_integrity)
	_expect_equal(_property_keys(affected), [effective_resistance.sort_key(), impact_capacity.sort_key()], "invalidation reports transitive affected outputs")
	var recomputed = resolver.resolve(subject)
	_expect_equal(recomputed.get_property(effective_resistance), 1, "invalidated profile recomputes first derived property")
	_expect_equal(recomputed.get_property(impact_capacity), 1, "invalidated profile recomputes chained property")

	var cycle_graph = PropertyDependencyGraph.new()
	var cycle_a = PropertyDerivationDefinition.new(&"cycle_a", [impact_capacity], effective_resistance, &"min_numeric")
	var cycle_b = PropertyDerivationDefinition.new(&"cycle_b", [effective_resistance], impact_capacity, &"min_numeric")
	var cycle_result = cycle_graph.compile([cycle_a, cycle_b])
	_expect_false(cycle_result.ok, "cyclic derivations rejected")
	_expect_equal(String(cycle_result.code), "property_derivation_cycle", "cycle diagnostic code")

	_completed = true


func _property_keys(properties: Array) -> Array[String]:
	var result: Array[String] = []
	for property_id in properties:
		result.append(property_id.sort_key())
	return result


func _expect_true(actual: bool, label: String) -> void:
	if not actual:
		_failures.append("Expected true: %s" % label)


func _expect_false(actual: bool, label: String) -> void:
	if actual:
		_failures.append("Expected false: %s" % label)


func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
