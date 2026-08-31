extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const ContentRegistry = preload("res://src/domain/content/content_registry.gd")
const EntityDefinition = preload("res://src/domain/content/entity_definition.gd")
const EntityInstance = preload("res://src/domain/world/entity_instance.gd")
const EntityStore = preload("res://src/domain/world/entity_store.gd")
const WorldRelation = preload("res://src/domain/world/world_relation.gd")
const WorldRelationStore = preload("res://src/domain/world/world_relation_store.gd")
const SemanticChange = preload("res://src/domain/world/semantic_change.gd")
const SemanticChangeSet = preload("res://src/domain/world/semantic_change_set.gd")
const DefaultWorldQuery = preload("res://src/domain/world/default_world_query.gd")
const RequirementPredicate = preload("res://src/domain/actions/requirement_predicate.gd")
const RequirementPredicateEvaluator = preload("res://src/domain/actions/requirement_predicate_evaluator.gd")
const PropertyInputSelector = preload("res://src/domain/physical/property_input_selector.gd")
const PropertyDerivationDefinition = preload("res://src/domain/physical/property_derivation_definition.gd")
const PropertyDependencyGraph = preload("res://src/domain/physical/property_dependency_graph.gd")
const EffectivePhysicalProfileResolver = preload("res://src/domain/physical/effective_physical_profile_resolver.gd")
const AssemblySlotDefinition = preload("res://src/domain/physical/assembly_slot_definition.gd")
const AssemblyDefinition = preload("res://src/domain/physical/assembly_definition.gd")
const AssemblyBindingProjection = preload("res://src/domain/physical/assembly_binding_projection.gd")
const CompositionDependencyProjection = preload("res://src/domain/physical/composition_dependency_projection.gd")
const AssemblyValidityResult = preload("res://src/domain/physical/assembly_validity_result.gd")
const AssemblyValidityService = preload("res://src/domain/physical/assembly_validity_service.gd")
const DerivedStateInvalidator = preload("res://src/application/simulation/derived_state_invalidator.gd")

var _failures: Array[String] = []
var _completed := false

func _init() -> void:
	_run_slice()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS improvised_hammer_composition_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL improvised_hammer_composition_test: %d failure(s)" % _failures.size())
	quit(1)

func _run_slice() -> void:
	var camp = DomainId.place(&"camp")
	var attached_to = DomainId.relation_type(&"attached_to")
	var structural_member = DomainId.capability(&"structural_member")
	var impact_surface = DomainId.capability(&"impact_surface")
	var binding_component = DomainId.capability(&"binding_component")
	var hardness = DomainId.property(&"hardness")
	var mass_class = DomainId.property(&"mass_class")
	var structural_integrity = DomainId.property(&"structural_integrity")
	var binding_integrity = DomainId.property(&"binding_integrity")
	var impact_capacity = DomainId.property(&"impact_capacity")
	var stability = DomainId.property(&"stability")

	var host_type = DomainId.entity_type(&"assembly_host")
	var handle_type = DomainId.entity_type(&"branch_handle")
	var head_type = DomainId.entity_type(&"impact_stone")
	var fiber_type = DomainId.entity_type(&"fiber_binding")
	var content = ContentRegistry.new()
	_expect_true(content.register_entity_definition(EntityDefinition.new(host_type, [], {}, [])).ok, "host definition registers")
	_expect_true(content.register_entity_definition(EntityDefinition.new(handle_type, [], {structural_integrity.key(): 4}, [structural_member])).ok, "handle definition registers")
	_expect_true(content.register_entity_definition(EntityDefinition.new(head_type, [], {hardness.key(): 4, mass_class.key(): 3}, [impact_surface])).ok, "head definition registers")
	_expect_true(content.register_entity_definition(EntityDefinition.new(fiber_type, [], {binding_integrity.key(): 4}, [binding_component])).ok, "binding definition registers")
	_expect_true(content.seal().ok, "content seals")

	var entities = EntityStore.new()
	var host_id = DomainId.entity(&"hammer_host")
	var handle_id = DomainId.entity(&"handle")
	var head_id = DomainId.entity(&"head")
	var fiber_id = DomainId.entity(&"fiber")
	_expect_true(entities.add_entity(EntityInstance.new(host_id, host_type, camp)).ok, "host added")
	_expect_true(entities.add_entity(EntityInstance.new(handle_id, handle_type, camp)).ok, "handle added")
	_expect_true(entities.add_entity(EntityInstance.new(head_id, head_type, camp)).ok, "head added")
	_expect_true(entities.add_entity(EntityInstance.new(fiber_id, fiber_type, camp)).ok, "binding added")

	var host = RuntimeWorldRef.entity(host_id)
	var handle = RuntimeWorldRef.entity(handle_id)
	var head = RuntimeWorldRef.entity(head_id)
	var fiber = RuntimeWorldRef.entity(fiber_id)
	var handle_slot = DomainId.assembly_slot(&"handle")
	var head_slot = DomainId.assembly_slot(&"head")
	var binding_slot = DomainId.assembly_slot(&"binding")

	var relations = WorldRelationStore.new()
	var handle_relation = WorldRelation.new(attached_to, handle, host, {"assembly_slot": handle_slot})
	var head_relation = WorldRelation.new(attached_to, head, host, {"assembly_slot": head_slot})
	var fiber_relation = WorldRelation.new(attached_to, fiber, host, {"assembly_slot": binding_slot})
	_expect_true(relations.add_relation(handle_relation).ok, "handle attached")
	_expect_true(relations.add_relation(head_relation).ok, "head attached")
	_expect_true(relations.add_relation(fiber_relation).ok, "binding attached")

	var query = DefaultWorldQuery.new(entities, relations, content)
	var binding_projection = AssemblyBindingProjection.new(query, attached_to)
	var composition_dependencies = CompositionDependencyProjection.new(query, [attached_to])
	var definition = AssemblyDefinition.new(DomainId.assembly_definition(&"improvised_impact_tool"), [
		AssemblySlotDefinition.new(handle_slot, DomainId.assembly_role(&"handle"), RequirementPredicate.has_capability(&"component", structural_member)),
		AssemblySlotDefinition.new(head_slot, DomainId.assembly_role(&"head"), RequirementPredicate.all_of([
			RequirementPredicate.has_capability(&"component", impact_surface),
			RequirementPredicate.property_compare(&"component", hardness, RequirementPredicate.CompareOp.GTE, 2),
		])),
		AssemblySlotDefinition.new(binding_slot, DomainId.assembly_role(&"binding"), RequirementPredicate.has_capability(&"component", binding_component)),
	])

	var graph = PropertyDependencyGraph.new()
	var impact_rule = PropertyDerivationDefinition.new(&"impact_capacity_from_components", [
		PropertyInputSelector.assembly_slot_property(head_slot, mass_class),
		PropertyInputSelector.assembly_slot_property(head_slot, hardness),
		PropertyInputSelector.assembly_slot_property(handle_slot, structural_integrity),
		PropertyInputSelector.assembly_slot_property(binding_slot, binding_integrity),
	], impact_capacity, &"min_numeric")
	var stability_rule = PropertyDerivationDefinition.new(&"stability_from_structure", [
		PropertyInputSelector.assembly_slot_property(handle_slot, structural_integrity),
		PropertyInputSelector.assembly_slot_property(binding_slot, binding_integrity),
	], stability, &"min_numeric")
	_expect_true(graph.compile([impact_rule, stability_rule]).ok, "composition property graph compiles")
	var profiles = EffectivePhysicalProfileResolver.new(query, graph, null, binding_projection)
	var evaluator = RequirementPredicateEvaluator.new(query, profiles)
	var validity = AssemblyValidityService.new(query, evaluator)
	var invalidator = DerivedStateInvalidator.new(profiles, composition_dependencies)

	var initial_validity = validity.evaluate(definition, host, binding_projection.bindings_for_host(host))
	_expect_equal(initial_validity.status, AssemblyValidityResult.Status.VALID, "initial hammer assembly valid")
	var initial_profile = profiles.resolve(host)
	_expect_equal(initial_profile.get_property(impact_capacity), 3, "impact capacity derives from weakest bounded component input")
	_expect_equal(initial_profile.get_property(stability), 4, "initial stability derives from handle and binding")
	_expect_equal(initial_profile.explain(impact_capacity).get("inputs", []).size(), 4, "impact provenance includes four component inputs")

	# Component property mutation invalidates its host transitively through composition.
	_expect_true(entities.set_property_override(fiber_id, binding_integrity, 2).ok, "binding degrades")
	var property_changes = SemanticChangeSet.new([SemanticChange.property_change(fiber, binding_integrity)])
	var property_invalidation = invalidator.apply(property_changes)
	_expect_equal(property_invalidation.size(), 1, "component property change invalidated")
	_expect_true(property_invalidation[0].get("composition_dependents", []).has(host.sort_key()), "host identified as composition dependent")
	var degraded_validity = validity.evaluate(definition, host, binding_projection.bindings_for_host(host))
	_expect_equal(degraded_validity.status, AssemblyValidityResult.Status.VALID, "degraded binding remains structurally valid")
	var degraded_profile = profiles.resolve(host)
	_expect_equal(degraded_profile.get_property(impact_capacity), 2, "degraded binding reduces impact capacity without manual host invalidation")
	_expect_equal(degraded_profile.get_property(stability), 2, "degraded binding reduces stability")

	# Relation mutation invalidates both direct host and transitive dependents.
	_expect_true(relations.remove_relation(fiber_relation).ok, "binding relation removed")
	invalidator.apply(SemanticChangeSet.new([SemanticChange.relation_change(fiber, attached_to, host)]))
	var broken_validity = validity.evaluate(definition, host, binding_projection.bindings_for_host(host))
	_expect_equal(broken_validity.status, AssemblyValidityResult.Status.INCOMPLETE, "missing binding makes assembly incomplete")
	var broken_profile = profiles.resolve(host)
	_expect_false(broken_profile.has_property(impact_capacity), "missing required slot input removes impact capacity derivation")
	_expect_false(broken_profile.has_property(stability), "missing required slot input removes stability derivation")

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
