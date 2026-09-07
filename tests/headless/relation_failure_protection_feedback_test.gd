extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const ContentRegistry = preload("res://src/domain/content/content_registry.gd")
const PropertyDefinition = preload("res://src/domain/content/property_definition.gd")
const EntityDefinition = preload("res://src/domain/content/entity_definition.gd")
const EntityInstance = preload("res://src/domain/world/entity_instance.gd")
const EntityStore = preload("res://src/domain/world/entity_store.gd")
const WorldRelation = preload("res://src/domain/world/world_relation.gd")
const WorldRelationStore = preload("res://src/domain/world/world_relation_store.gd")
const DefaultWorldQuery = preload("res://src/domain/world/default_world_query.gd")
const SemanticChange = preload("res://src/domain/world/semantic_change.gd")
const SemanticChangeSet = preload("res://src/domain/world/semantic_change_set.gd")
const RelationFailureDefinition = preload("res://src/domain/world/relation_failure_definition.gd")
const RelationFailureAdvanceService = preload("res://src/domain/world/relation_failure_advance_service.gd")
const PropertyDerivationDefinition = preload("res://src/domain/physical/property_derivation_definition.gd")
const PropertyInputSelector = preload("res://src/domain/physical/property_input_selector.gd")
const PropertyDependencyGraph = preload("res://src/domain/physical/property_dependency_graph.gd")
const PhysicalDerivationPolicyRegistry = preload("res://src/domain/physical/physical_derivation_policy_registry.gd")
const AssemblyBindingProjection = preload("res://src/domain/physical/assembly_binding_projection.gd")
const CompositionDependencyProjection = preload("res://src/domain/physical/composition_dependency_projection.gd")
const EffectivePhysicalProfileResolver = preload("res://src/domain/physical/effective_physical_profile_resolver.gd")
const EffectivePropertyReader = preload("res://src/domain/physical/effective_property_reader.gd")
const ProtectionRuleDefinition = preload("res://src/domain/physical/protection_rule_definition.gd")
const ProtectionProjectionService = preload("res://src/domain/physical/protection_projection_service.gd")
const ExposureResolver = preload("res://src/domain/physical/exposure_resolver.gd")
const DerivedStateInvalidator = preload("res://src/application/simulation/derived_state_invalidator.gd")

var _failures: Array[String] = []
var _completed := false


func _init() -> void:
	_run_slice()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS relation_failure_protection_feedback_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL relation_failure_protection_feedback_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_slice() -> void:
	var camp = DomainId.place(&"camp")
	var attached_to = DomainId.relation_type(&"attached_to")
	var protects = DomainId.relation_type(&"protects")
	var binding_slot = DomainId.assembly_slot(&"roof_binding")
	var binding_integrity = DomainId.property(&"binding_integrity")
	var coverage = DomainId.property(&"coverage")
	var rain_protection = DomainId.property(&"rain_protection")
	var host_type = DomainId.entity_type(&"cover_host")
	var binding_type = DomainId.entity_type(&"fiber_binding")
	var bedding_type = DomainId.entity_type(&"bedding")

	var content = ContentRegistry.new()
	_expect_true(content.register_property_definition(PropertyDefinition.new(binding_integrity, PropertyDefinition.ValueFamily.NUMBER, 0.0, 1.0)).ok, "binding integrity registers")
	_expect_true(content.register_property_definition(PropertyDefinition.new(coverage, PropertyDefinition.ValueFamily.NUMBER, 0.0, 1.0)).ok, "coverage registers")
	_expect_true(content.register_property_definition(PropertyDefinition.new(rain_protection, PropertyDefinition.ValueFamily.NUMBER, 0.0, 1.0)).ok, "rain protection registers")
	_expect_true(content.register_entity_definition(EntityDefinition.new(host_type, [], {coverage.key(): 1.0}, [])).ok, "host registers")
	_expect_true(content.register_entity_definition(EntityDefinition.new(binding_type, [], {binding_integrity.key(): 1.0}, [])).ok, "binding registers")
	_expect_true(content.register_entity_definition(EntityDefinition.new(bedding_type, [], {}, [])).ok, "bedding registers")
	_expect_true(content.register_property_derivation_definition(PropertyDerivationDefinition.new(
		&"binding_controls_rain_protection",
		[PropertyInputSelector.assembly_slot_property(binding_slot, binding_integrity)],
		rain_protection,
		&"min_numeric"
	)).ok, "rain protection derivation registers")
	_expect_true(content.seal().ok, "content seals")

	var host_id = DomainId.entity(&"host_1")
	var binding_id = DomainId.entity(&"binding_1")
	var bedding_id = DomainId.entity(&"bedding_1")
	var entities = EntityStore.new()
	_expect_true(entities.add_entity(EntityInstance.new(host_id, host_type, camp)).ok, "host added")
	_expect_true(entities.add_entity(EntityInstance.new(binding_id, binding_type, camp)).ok, "binding added")
	_expect_true(entities.add_entity(EntityInstance.new(bedding_id, bedding_type, camp)).ok, "bedding added")
	var host = RuntimeWorldRef.entity(host_id)
	var binding = RuntimeWorldRef.entity(binding_id)
	var bedding = RuntimeWorldRef.entity(bedding_id)

	var relations = WorldRelationStore.new()
	_expect_true(relations.add_relation(WorldRelation.new(attached_to, binding, host, binding_slot)).ok, "binding attached")
	_expect_true(relations.add_relation(WorldRelation.new(protects, host, bedding)).ok, "host protects bedding")
	var query = DefaultWorldQuery.new(entities, relations, content)
	var assembly = AssemblyBindingProjection.new(query, attached_to)
	var dependencies = CompositionDependencyProjection.new(query, [attached_to])
	var policies = PhysicalDerivationPolicyRegistry.new()
	var graph = PropertyDependencyGraph.new()
	_expect_true(graph.compile(content.property_derivation_definitions(), policies).ok, "dependency graph compiles")
	var profiles = EffectivePhysicalProfileResolver.new(query, graph, policies, assembly)
	var invalidator = DerivedStateInvalidator.new(profiles, dependencies)
	var reader = EffectivePropertyReader.new(query, profiles)
	var exposure = ExposureResolver.new(ProtectionProjectionService.new(query, [
		ProtectionRuleDefinition.new(&"rain_cover", &"rain", protects, coverage, rain_protection),
	], reader))

	_expect_float(exposure.resolve(bedding, &"rain", 1.0).exposure_level, 0.0, "intact binding yields full protection")

	_expect_true(entities.set_property_override(binding_id, binding_integrity, 0.2).ok, "binding integrity degrades below failure threshold")
	var property_changes = SemanticChangeSet.new([SemanticChange.property_change(binding, binding_integrity)])
	invalidator.apply(property_changes)
	_expect_float(exposure.resolve(bedding, &"rain", 1.0).exposure_level, 0.8, "weak but attached binding yields partial protection")

	var failures = RelationFailureAdvanceService.new(query, relations, [
		RelationFailureDefinition.new(&"binding_attachment_failure", attached_to, binding_integrity, 0.25, RelationFailureDefinition.Compare.LTE, binding_slot),
	]).advance()
	_expect_equal(failures["transitions"].size(), 1, "crossing authored threshold removes one relation")
	_expect_equal(query.find_relations(attached_to, binding, host).size(), 0, "binding attachment relation is removed")
	_expect_true(not failures["change_set"].is_empty(), "detachment emits semantic relation change")
	invalidator.apply(failures["change_set"])
	_expect_float(exposure.resolve(bedding, &"rain", 1.0).exposure_level, 1.0, "missing structural binding removes derived protection entirely")

	_completed = true


func _expect_true(actual: bool, label: String) -> void:
	if not actual:
		_failures.append("Expected true: %s" % label)


func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])


func _expect_float(actual: Variant, expected: float, label: String) -> void:
	if actual == null or not is_equal_approx(float(actual), expected):
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
