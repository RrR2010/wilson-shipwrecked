extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const RoleBinding = preload("res://src/domain/actions/role_binding.gd")
const ActionEffect = preload("res://src/domain/actions/action_effect.gd")
const ActionOutcome = preload("res://src/domain/actions/action_outcome.gd")
const EntityInstance = preload("res://src/domain/world/entity_instance.gd")
const EntityStore = preload("res://src/domain/world/entity_store.gd")
const WorldRelationStore = preload("res://src/domain/world/world_relation_store.gd")
const DefaultWorldCommandPort = preload("res://src/domain/world/default_world_command_port.gd")
const SemanticChange = preload("res://src/domain/world/semantic_change.gd")

var _failures: Array[String] = []


func _init() -> void:
	_run_slice()
	if _failures.is_empty():
		print("PASS inventory_quantity_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL inventory_quantity_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_slice() -> void:
	var entity_id = DomainId.entity(&"finite_food")
	var entity_ref = RuntimeWorldRef.entity(entity_id)
	var entities = EntityStore.new()
	var entity = EntityInstance.new(
		entity_id,
		DomainId.entity_type(&"food"),
		DomainId.place(&"camp"),
		{},
		3
	)
	_expect_true(entities.add_entity(entity).ok, "finite food is added")

	var bindings = RoleBinding.new()
	bindings.bind(&"target", entity_ref)
	var commands = DefaultWorldCommandPort.new(entities, WorldRelationStore.new())
	var consume = _outcome(&"consume_1", bindings, [ActionEffect.change_quantity(&"target", -1)])
	var commit = commands.apply_outcome(consume)
	_expect_true(commit.ok, "available quantity can be consumed")
	_expect_equal(entities.get_quantity(entity_id), 2, "successful consume decrements authoritative quantity")
	_expect_equal(commit.change_set.changes.size(), 1, "quantity mutation emits semantic change")
	if commit.change_set.changes.size() == 1:
		_expect_equal(commit.change_set.changes[0].kind, SemanticChange.Kind.QUANTITY, "semantic change is typed as quantity")

	# Sequential prevalidation must reject the entire batch before any mutation occurs.
	var underflow = _outcome(&"consume_underflow", bindings, [
		ActionEffect.change_quantity(&"target", -2),
		ActionEffect.change_quantity(&"target", -1),
	])
	var rejected = commands.apply_outcome(underflow)
	_expect_false(rejected.ok, "batch that would underflow is rejected")
	_expect_equal(entities.get_quantity(entity_id), 2, "rejected batch leaves authoritative quantity untouched")

	var exhaust = _outcome(&"consume_last", bindings, [ActionEffect.change_quantity(&"target", -2)])
	var exhausted = commands.apply_outcome(exhaust)
	_expect_true(exhausted.ok, "remaining quantity can reach exactly zero")
	_expect_equal(entities.get_quantity(entity_id), 0, "zero quantity is preserved explicitly")
	_expect_equal(entity.lifecycle, EntityInstance.Lifecycle.ACTIVE, "zero quantity does not destroy the entity")

	var unavailable = _outcome(&"consume_empty", bindings, [ActionEffect.change_quantity(&"target", -1)])
	_expect_false(commands.apply_outcome(unavailable).ok, "empty quantity cannot be consumed")
	_expect_equal(entities.get_quantity(entity_id), 0, "failed empty consume keeps zero quantity")


func _outcome(execution_id: StringName, bindings, effects: Array):
	return ActionOutcome.new(
		execution_id,
		DomainId.action(&"consume_food"),
		bindings,
		effects,
		DomainId.event_definition(&"food_consumed")
	)


func _expect_true(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _expect_false(condition: bool, message: String) -> void:
	if condition:
		_failures.append(message)


func _expect_equal(actual: Variant, expected: Variant, message: String) -> void:
	if actual != expected:
		_failures.append("%s (expected=%s actual=%s)" % [message, expected, actual])
