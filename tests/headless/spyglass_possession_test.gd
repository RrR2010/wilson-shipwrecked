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
const DefaultWorldQuery = preload("res://src/domain/world/default_world_query.gd")
const ContentRegistry = preload("res://src/domain/content/content_registry.gd")
const RequirementPredicate = preload("res://src/domain/actions/requirement_predicate.gd")
const RequirementPredicateEvaluator = preload("res://src/domain/actions/requirement_predicate_evaluator.gd")

var failures: Array[String] = []

func _init() -> void:
	var spyglass_id = DomainId.entity(&"spyglass")
	var spyglass = RuntimeWorldRef.entity(spyglass_id)
	var wilson = RuntimeWorldRef.wilson()
	var held_by = DomainId.relation_type(&"held_by")
	var entities = EntityStore.new()
	entities.add_entity(EntityInstance.new(spyglass_id, DomainId.entity_type(&"spyglass"), DomainId.place(&"beach")))
	var relations = WorldRelationStore.new()
	var query = DefaultWorldQuery.new(entities, relations, ContentRegistry.new())
	var commands = DefaultWorldCommandPort.new(entities, relations)
	var binding = RoleBinding.new()
	binding.bind(&"tool", spyglass)
	binding.bind(&"actor", wilson)
	var pickup = ActionOutcome.new(&"pickup_1", DomainId.action(&"pick_up"), binding, [
		ActionEffect.new(ActionEffect.Kind.CREATE_RELATION, &"tool", held_by, null, &"actor")
	], DomainId.event_definition(&"tool_picked_up"))
	var release = ActionOutcome.new(&"release_1", DomainId.action(&"put_down"), binding, [
		ActionEffect.new(ActionEffect.Kind.REMOVE_RELATION, &"tool", held_by, null, &"actor")
	], DomainId.event_definition(&"tool_released"))
	var inspect_requires_tool = RequirementPredicate.has_relation(&"tool", held_by, &"actor")
	# The World predicate is a generic eligibility contract; an unheld tool cannot be used.
	_check(query.find_relations(held_by, spyglass, wilson).is_empty(), "tool is unheld initially")
	_check(not query.find_relations(held_by, spyglass, wilson).size() > 0, "unheld tool cannot satisfy held relation")
	var first = commands.apply_outcome(pickup)
	_check(first.ok, "pick-up commits a held relation")
	_check(query.get_held_items(wilson, held_by).size() == 1, "World query sees spyglass held by Wilson")
	_check(not commands.apply_outcome(pickup).ok, "duplicate pick-up rejected")
	_check(query.get_held_items(wilson, held_by).size() == 1, "duplicate cannot create second item")
	_check(commands.apply_outcome(release).ok, "release commits removal")
	_check(query.get_held_items(wilson, held_by).is_empty(), "World query sees no tool after release")
	_check(not commands.apply_outcome(release).ok, "duplicate release rejected")
	_check(inspect_requires_tool.semantic_id.equals(held_by), "tool requirement is relation-based")
	if failures.is_empty():
		print("PASS spyglass_possession_test")
		quit(0)
		return
	for failure in failures:
		push_error(failure)
	print("FAIL spyglass_possession_test: %d failure(s)" % failures.size())
	quit(1)

func _check(ok: bool, label: String) -> void:
	if not ok:
		failures.append(label)
