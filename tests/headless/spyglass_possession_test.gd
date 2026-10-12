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
const AuthoredToolOpportunitySource = preload("res://src/domain/cognition/authored_tool_opportunity_source.gd")
const BeliefStore = preload("res://src/domain/cognition/belief_store.gd")
const BeliefProposition = preload("res://src/domain/cognition/belief_proposition.gd")
const EpistemicClaim = preload("res://src/domain/cognition/epistemic_claim.gd")
const RequirementPredicateEvaluator = preload("res://src/domain/actions/requirement_predicate_evaluator.gd")

class UnusedPropertyResolver:
	extends RefCounted
	func get_value(_subject, _property_id):
		return null

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
	var evaluator = RequirementPredicateEvaluator.new(query, RefCounted.new(), UnusedPropertyResolver.new())
	_check(not evaluator.evaluate(inspect_requires_tool, binding).passed, "tool use denied before pickup")
	_check(query.find_relations(held_by, spyglass, wilson).is_empty(), "tool is unheld initially")
	var known = BeliefProposition.new(EpistemicClaim.property_claim(spyglass, DomainId.property(&"collectible"), true))
	var target_known = BeliefProposition.new(EpistemicClaim.property_claim(spyglass, DomainId.property(&"interesting"), true))
	var beliefs = BeliefStore.new()
	beliefs.restore_entry(known, 0.9, 1)
	beliefs.restore_entry(target_known, 0.9, 1)
	var collect_intention = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"collect_spyglass")
	var explore_intention = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"investigate_with_spyglass")
	var opportunities = AuthoredToolOpportunitySource.new(query, beliefs, spyglass, wilson, spyglass, known, target_known, held_by, DomainId.relation_type(&"tool_exploration_receipt"), collect_intention, explore_intention)
	var stored_tool = beliefs.get_entry(known)
	var stored_target = beliefs.get_entry(target_known)
	_check(stored_tool != null, "known tool belief was restored")
	_check(stored_target != null, "known exploration target belief was restored")
	var before = opportunities.generate()
	_check(before.size() == 1 and before[0].intention_id != null, "pickup opportunity has non-null intent (count=%d; belief=%s)" % [before.size(), str(null if stored_tool == null else stored_tool.confidence)])
	if before.size() == 1 and before[0].intention_id != null:
		_check(before[0].intention_id.equals(collect_intention), "known unheld tool prompts pickup")
		_check(before[0].total_score() < 0.35, "optional pickup must not displace ongoing shelter work")
	var first = commands.apply_outcome(pickup)
	_check(first.ok, "pick-up commits a held relation")
	_check(query.get_held_items(wilson, held_by).size() == 1, "World query sees spyglass held by Wilson")
	_check(evaluator.evaluate(inspect_requires_tool, binding).passed, "held tool permits tool-gated action")
	var after = opportunities.generate()
	_check(after.size() == 1 and after[0].intention_id != null, "tool-use opportunity has non-null intent (count=%d; held=%d; target-belief=%s)" % [after.size(), query.find_relations(held_by, spyglass, wilson).size(), str(null if stored_target == null else stored_target.confidence)])
	if after.size() == 1 and after[0].intention_id != null:
		_check(after[0].intention_id.equals(explore_intention), "held tool prompts exploration")
		_check(after[0].total_score() < 0.35, "optional tool use must not displace ongoing shelter work")
	_check(not commands.apply_outcome(pickup).ok, "duplicate pick-up rejected")
	_check(query.get_held_items(wilson, held_by).size() == 1, "duplicate cannot create second item")
	_check(commands.apply_outcome(release).ok, "release commits removal")
	_check(query.get_held_items(wilson, held_by).is_empty(), "World query sees no tool after release")
	_check(not evaluator.evaluate(inspect_requires_tool, binding).passed, "released tool no longer satisfies requirement")
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
