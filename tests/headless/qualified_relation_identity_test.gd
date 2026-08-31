extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const EntityInstance = preload("res://src/domain/world/entity_instance.gd")
const EntityStore = preload("res://src/domain/world/entity_store.gd")
const WorldRelation = preload("res://src/domain/world/world_relation.gd")
const WorldRelationStore = preload("res://src/domain/world/world_relation_store.gd")
const DefaultWorldCommandPort = preload("res://src/domain/world/default_world_command_port.gd")
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
		print("PASS qualified_relation_identity_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL qualified_relation_identity_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_slice() -> void:
	var camp = DomainId.place(&"camp")
	var component_id = DomainId.entity(&"component_1")
	var host_id = DomainId.entity(&"host_1")
	var component_type = DomainId.entity_type(&"component")
	var host_type = DomainId.entity_type(&"host")
	var entities = EntityStore.new()
	_expect_true(entities.add_entity(EntityInstance.new(component_id, component_type, camp)).ok, "component added")
	_expect_true(entities.add_entity(EntityInstance.new(host_id, host_type, camp)).ok, "host added")

	var component = RuntimeWorldRef.entity(component_id)
	var host = RuntimeWorldRef.entity(host_id)
	var attached_to = DomainId.relation_type(&"attached_to")
	var near = DomainId.relation_type(&"near")
	var head_slot = DomainId.assembly_slot(&"head")
	var handle_slot = DomainId.assembly_slot(&"handle")
	var relations = WorldRelationStore.new()

	var head_relation = WorldRelation.new(attached_to, component, host, head_slot)
	var handle_relation = WorldRelation.new(attached_to, component, host, handle_slot)
	_expect_true(head_relation.key() != handle_relation.key(), "qualifier participates in relation identity")
	_expect_true(relations.add_relation(head_relation).ok, "head-qualified relation added")
	_expect_true(relations.add_relation(handle_relation).ok, "handle-qualified relation with same endpoints coexists")
	_expect_equal(relations.find_relations(attached_to, component, host).size(), 2, "broad endpoint query intentionally returns both qualified relations")
	_expect_true(relations.get_relation(head_relation.key()) != null, "exact head relation lookup succeeds")
	_expect_true(relations.get_relation(handle_relation.key()) != null, "exact handle relation lookup succeeds")

	# Numeric representation does not create two semantic qualifier identities.
	var numeric_relation = WorldRelation.new(near, component, host, 3)
	var numeric_float_relation = WorldRelation.new(near, component, host, 3.0)
	_expect_equal(numeric_relation.key(), numeric_float_relation.key(), "int/float qualifier identity is canonicalized")
	_expect_true(relations.add_relation(numeric_relation).ok, "numeric qualified relation added")
	var numeric_duplicate = relations.add_relation(numeric_float_relation)
	_expect_false(numeric_duplicate.ok, "equivalent numeric qualifier duplicate is rejected")

	var bindings = RoleBinding.new()
	bindings.bind(&"component", component)
	bindings.bind(&"host", host)
	var commands = DefaultWorldCommandPort.new(entities, relations)
	var action_id = DomainId.action(&"rebind_component")
	var event_type = DomainId.event_definition(&"component_rebound")

	var remove_head = ActionOutcome.new(
		&"remove_head",
		action_id,
		bindings,
		[ActionEffect.new(ActionEffect.Kind.REMOVE_RELATION, &"component", attached_to, head_slot, &"host")],
		event_type
	)
	var remove_result = commands.apply_outcome(remove_head)
	_expect_true(remove_result.ok, "World command removes exact qualified relation")
	_expect_true(relations.get_relation(head_relation.key()) == null, "head relation removed")
	_expect_true(relations.get_relation(handle_relation.key()) != null, "different qualifier relation remains")
	_expect_equal(relations.find_relations(attached_to, component, host).size(), 1, "only one attached relation remains")

	var recreate_head = ActionOutcome.new(
		&"recreate_head",
		action_id,
		bindings,
		[ActionEffect.new(ActionEffect.Kind.CREATE_RELATION, &"component", attached_to, head_slot, &"host")],
		event_type
	)
	var create_result = commands.apply_outcome(recreate_head)
	_expect_true(create_result.ok, "World command creates missing exact qualified relation")
	_expect_equal(relations.find_relations(attached_to, component, host).size(), 2, "both qualifiers coexist after recreation")

	var duplicate_create = ActionOutcome.new(
		&"duplicate_head",
		action_id,
		bindings,
		[ActionEffect.new(ActionEffect.Kind.CREATE_RELATION, &"component", attached_to, head_slot, &"host")],
		event_type
	)
	var duplicate_result = commands.apply_outcome(duplicate_create)
	_expect_false(duplicate_result.ok, "duplicate exact qualified relation is rejected before mutation")
	_expect_equal(relations.find_relations(attached_to, component, host).size(), 2, "failed duplicate create leaves relations unchanged")
	_expect_true(relations.validate_indexes().ok, "qualified relation indexes remain valid")

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
