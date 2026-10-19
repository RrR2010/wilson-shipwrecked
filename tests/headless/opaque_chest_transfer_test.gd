extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const RoleBinding = preload("res://src/domain/actions/role_binding.gd")
const ActionEffect = preload("res://src/domain/actions/action_effect.gd")
const ActionOutcome = preload("res://src/domain/actions/action_outcome.gd")
const EntityInstance = preload("res://src/domain/world/entity_instance.gd")
const EntityStore = preload("res://src/domain/world/entity_store.gd")
const WorldRelationStore = preload("res://src/domain/world/world_relation_store.gd")
const WorldRelation = preload("res://src/domain/world/world_relation.gd")
const DefaultWorldCommandPort = preload("res://src/domain/world/default_world_command_port.gd")
const DefaultWorldQuery = preload("res://src/domain/world/default_world_query.gd")
const ContentRegistry = preload("res://src/domain/content/content_registry.gd")
const BeliefStore = preload("res://src/domain/cognition/belief_store.gd")
const BeliefProposition = preload("res://src/domain/cognition/belief_proposition.gd")
const EpistemicClaim = preload("res://src/domain/cognition/epistemic_claim.gd")

var failures: Array[String] = []

func _init() -> void:
	var camp = DomainId.place(&"camp")
	var chest_id = DomainId.entity(&"chest")
	var food_id = DomainId.entity(&"preserved_food")
	var chest = RuntimeWorldRef.entity(chest_id)
	var food = RuntimeWorldRef.entity(food_id)
	var wilson = RuntimeWorldRef.wilson()
	var inside = DomainId.relation_type(&"inside")
	var held_by = DomainId.relation_type(&"held_by")
	var entities = EntityStore.new()
	entities.add_entity(EntityInstance.new(chest_id, DomainId.entity_type(&"chest"), camp))
	entities.add_entity(EntityInstance.new(food_id, DomainId.entity_type(&"food"), camp, {}, 2))
	var relations = WorldRelationStore.new()
	relations.add_relation(WorldRelation.new(inside, food, chest))
	var query = DefaultWorldQuery.new(entities, relations, ContentRegistry.new())
	var commands = DefaultWorldCommandPort.new(entities, relations)
	var beliefs = BeliefStore.new()
	var content_claim = BeliefProposition.new(EpistemicClaim.relation_claim(food, inside, chest))
	_check(query.get_container_contents(chest, inside).size() == 1, "World contains hidden food")
	_check(beliefs.get_entry(content_claim) == null, "Unopened opaque chest does not grant contents knowledge")
	var bindings = RoleBinding.new()
	bindings.bind(&"item", food)
	bindings.bind(&"chest", chest)
	bindings.bind(&"actor", wilson)
	var withdraw = ActionOutcome.new(&"withdraw_1", DomainId.action(&"withdraw"), bindings, [
		ActionEffect.new(ActionEffect.Kind.REMOVE_RELATION, &"item", inside, null, &"chest"),
		ActionEffect.new(ActionEffect.Kind.CREATE_RELATION, &"item", held_by, null, &"actor"),
	], DomainId.event_definition(&"item_withdrawn"))
	_check(commands.apply_outcome(withdraw).ok, "Withdraw commits World transfer")
	_check(query.get_container_contents(chest, inside).is_empty(), "Withdraw removes chest containment")
	_check(query.get_held_items(wilson, held_by).size() == 1, "Withdraw establishes possession")
	_check(query.get_quantity(food) == 2, "Whole item transfer conserves stack quantity")
	_check(not commands.apply_outcome(withdraw).ok, "Repeated withdrawal cannot duplicate item")
	var deposit = ActionOutcome.new(&"deposit_1", DomainId.action(&"deposit"), bindings, [
		ActionEffect.new(ActionEffect.Kind.REMOVE_RELATION, &"item", held_by, null, &"actor"),
		ActionEffect.new(ActionEffect.Kind.CREATE_RELATION, &"item", inside, null, &"chest"),
	], DomainId.event_definition(&"item_deposited"))
	_check(commands.apply_outcome(deposit).ok, "Deposit commits reverse transfer")
	_check(query.get_container_contents(chest, inside).size() == 1, "Deposit restores containment")
	_check(query.get_held_items(wilson, held_by).is_empty(), "Deposit clears possession")
	_check(query.get_quantity(food) == 2, "Deposit preserves quantity")
	# This is the missing exclusivity invariant: two different owner edges
	# must not simultaneously claim the same physical item.
	var invalid = ActionOutcome.new(&"invalid_1", DomainId.action(&"invalid_transfer"), bindings, [
		ActionEffect.new(ActionEffect.Kind.CREATE_RELATION, &"item", held_by, null, &"actor"),
	], DomainId.event_definition(&"invalid_transfer"))
	_check(not commands.apply_outcome(invalid).ok, "Cannot hold an item still inside a chest")
	_check(query.get_container_contents(chest, inside).size() == 1, "Rejected conflicting transfer retains original parent")
	if failures.is_empty():
		print("PASS opaque_chest_transfer_test")
		quit(0)
		return
	for failure in failures:
		push_error(failure)
	print("FAIL opaque_chest_transfer_test: %d failure(s)" % failures.size())
	quit(1)

func _check(ok: bool, label: String) -> void:
	if not ok:
		failures.append(label)
