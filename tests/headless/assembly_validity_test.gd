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
const AssemblySlotDefinition = preload("res://src/domain/physical/assembly_slot_definition.gd")
const AssemblyDefinition = preload("res://src/domain/physical/assembly_definition.gd")
const AssemblyBinding = preload("res://src/domain/physical/assembly_binding.gd")
const AssemblyValidityResult = preload("res://src/domain/physical/assembly_validity_result.gd")
const AssemblyValidityService = preload("res://src/domain/physical/assembly_validity_service.gd")

var _failures: Array[String] = []
var _completed := false


func _init() -> void:
	_run_slice()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS assembly_validity_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL assembly_validity_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_slice() -> void:
	var camp = DomainId.place(&"camp")
	var structural_member = DomainId.capability(&"structural_member")
	var impact_surface = DomainId.capability(&"impact_surface")
	var binding_component = DomainId.capability(&"binding_component")
	var hardness = DomainId.property(&"hardness")
	var mass_class = DomainId.property(&"mass_class")

	var handle_type = DomainId.entity_type(&"branch_handle")
	var stone_type = DomainId.entity_type(&"impact_stone")
	var pebble_type = DomainId.entity_type(&"tiny_pebble")
	var fiber_type = DomainId.entity_type(&"fiber_binding")
	var fruit_type = DomainId.entity_type(&"soft_fruit")
	var host_type = DomainId.entity_type(&"assembly_host")

	var content = ContentRegistry.new()
	_expect_true(content.register_entity_definition(EntityDefinition.new(handle_type, [], {}, [structural_member])).ok, "handle definition registers")
	_expect_true(content.register_entity_definition(EntityDefinition.new(stone_type, [], {hardness.key(): 4, mass_class.key(): 3}, [impact_surface])).ok, "stone definition registers")
	_expect_true(content.register_entity_definition(EntityDefinition.new(pebble_type, [], {hardness.key(): 4, mass_class.key(): 1}, [impact_surface])).ok, "pebble definition registers")
	_expect_true(content.register_entity_definition(EntityDefinition.new(fiber_type, [], {}, [binding_component])).ok, "binding definition registers")
	_expect_true(content.register_entity_definition(EntityDefinition.new(fruit_type, [], {hardness.key(): 0, mass_class.key(): 1}, [])).ok, "fruit definition registers")
	_expect_true(content.register_entity_definition(EntityDefinition.new(host_type, [], {}, [])).ok, "host definition registers")
	_expect_true(content.seal().ok, "content seals")

	var entities = EntityStore.new()
	var host_id = DomainId.entity(&"tool_host_1")
	var handle_id = DomainId.entity(&"handle_1")
	var stone_id = DomainId.entity(&"stone_1")
	var pebble_id = DomainId.entity(&"pebble_1")
	var fiber_id = DomainId.entity(&"fiber_1")
	var fruit_id = DomainId.entity(&"fruit_1")
	_expect_true(entities.add_entity(EntityInstance.new(host_id, host_type, camp)).ok, "host added")
	_expect_true(entities.add_entity(EntityInstance.new(handle_id, handle_type, camp)).ok, "handle added")
	_expect_true(entities.add_entity(EntityInstance.new(stone_id, stone_type, camp)).ok, "stone added")
	_expect_true(entities.add_entity(EntityInstance.new(pebble_id, pebble_type, camp)).ok, "pebble added")
	_expect_true(entities.add_entity(EntityInstance.new(fiber_id, fiber_type, camp)).ok, "fiber added")
	_expect_true(entities.add_entity(EntityInstance.new(fruit_id, fruit_type, camp)).ok, "fruit added")

	var host = RuntimeWorldRef.entity(host_id)
	var handle = RuntimeWorldRef.entity(handle_id)
	var stone = RuntimeWorldRef.entity(stone_id)
	var pebble = RuntimeWorldRef.entity(pebble_id)
	var fiber = RuntimeWorldRef.entity(fiber_id)
	var fruit = RuntimeWorldRef.entity(fruit_id)

	var query = DefaultWorldQuery.new(entities, WorldRelationStore.new(), content)
	var graph = PropertyDependencyGraph.new()
	_expect_true(graph.compile([]).ok, "empty property graph compiles")
	var profiles = EffectivePhysicalProfileResolver.new(query, graph)
	var predicate_evaluator = RequirementPredicateEvaluator.new(query, profiles)
	var service = AssemblyValidityService.new(query, predicate_evaluator)

	var handle_slot = DomainId.assembly_slot(&"handle")
	var head_slot = DomainId.assembly_slot(&"head")
	var binding_slot = DomainId.assembly_slot(&"binding")
	var definition = AssemblyDefinition.new(
		DomainId.assembly_definition(&"improvised_impact_tool"),
		[
			AssemblySlotDefinition.new(
				handle_slot,
				DomainId.assembly_role(&"handle"),
				RequirementPredicate.has_capability(&"component", structural_member)
			),
			AssemblySlotDefinition.new(
				head_slot,
				DomainId.assembly_role(&"head"),
				RequirementPredicate.all_of([
					RequirementPredicate.has_capability(&"component", impact_surface),
					RequirementPredicate.property_compare(&"component", hardness, RequirementPredicate.CompareOp.GTE, 2),
				])
			),
			AssemblySlotDefinition.new(
				binding_slot,
				DomainId.assembly_role(&"binding"),
				RequirementPredicate.has_capability(&"component", binding_component)
			),
		]
	)

	var good_bindings = [
		AssemblyBinding.new(host, handle_slot, handle),
		AssemblyBinding.new(host, head_slot, stone),
		AssemblyBinding.new(host, binding_slot, fiber),
	]
	var good_result = service.evaluate(definition, host, good_bindings)
	_expect_equal(good_result.status, AssemblyValidityResult.Status.VALID, "good assembly is valid")

	var incomplete_result = service.evaluate(definition, host, [
		AssemblyBinding.new(host, handle_slot, handle),
		AssemblyBinding.new(host, head_slot, stone),
	])
	_expect_equal(incomplete_result.status, AssemblyValidityResult.Status.INCOMPLETE, "missing required binding is incomplete")

	var fruit_result = service.evaluate(definition, host, [
		AssemblyBinding.new(host, handle_slot, handle),
		AssemblyBinding.new(host, head_slot, fruit),
		AssemblyBinding.new(host, binding_slot, fiber),
	])
	_expect_equal(fruit_result.status, AssemblyValidityResult.Status.INCOMPATIBLE_COMPONENT, "soft fruit is rejected as head")

	var pebble_result = service.evaluate(definition, host, [
		AssemblyBinding.new(host, handle_slot, handle),
		AssemblyBinding.new(host, head_slot, pebble),
		AssemblyBinding.new(host, binding_slot, fiber),
	])
	_expect_equal(pebble_result.status, AssemblyValidityResult.Status.VALID, "compatible low-mass pebble remains valid")
	_expect_equal(query.get_instance_property(pebble, mass_class), 1, "validity does not impose performance threshold")

	var fiber_entity = entities.get_entity(fiber_id)
	fiber_entity.lifecycle = EntityInstance.Lifecycle.DESTROYED
	var broken_result = service.evaluate(definition, host, good_bindings)
	_expect_equal(broken_result.status, AssemblyValidityResult.Status.BROKEN_BINDING, "destroyed component yields broken binding")
	fiber_entity.lifecycle = EntityInstance.Lifecycle.ACTIVE

	var duplicate_head_result = service.evaluate(definition, host, [
		AssemblyBinding.new(host, handle_slot, handle),
		AssemblyBinding.new(host, head_slot, stone),
		AssemblyBinding.new(host, head_slot, pebble),
		AssemblyBinding.new(host, binding_slot, fiber),
	])
	_expect_equal(duplicate_head_result.status, AssemblyValidityResult.Status.INVALID_CONFIGURATION, "slot cardinality overflow is invalid configuration")

	_completed = true


func _expect_true(actual: bool, label: String) -> void:
	if not actual:
		_failures.append("Expected true: %s" % label)


func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
