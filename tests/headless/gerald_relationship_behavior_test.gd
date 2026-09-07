extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const EntityInstance = preload("res://src/domain/world/entity_instance.gd")
const EntityStore = preload("res://src/domain/world/entity_store.gd")
const ActorRuntimeState = preload("res://src/domain/actors/actor_runtime_state.gd")
const ActorStateStore = preload("res://src/domain/actors/actor_state_store.gd")
const ActorProfileDefinition = preload("res://src/domain/actors/actor_profile_definition.gd")
const ActorBehaviorRule = preload("res://src/domain/actors/actor_behavior_rule.gd")
const ActorRelationshipImpact = preload("res://src/domain/actors/actor_relationship_impact.gd")
const ActorRelationshipStore = preload("res://src/domain/actors/actor_relationship_store.gd")
const ShallowActorAdvanceService = preload("res://src/domain/actors/shallow_actor_advance_service.gd")

var _failures: Array[String] = []


func _init() -> void:
	_run_test()
	if _failures.is_empty():
		print("PASS gerald_relationship_behavior_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL gerald_relationship_behavior_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_test() -> void:
	var camp = DomainId.place(&"camp")
	var near_wilson = DomainId.place(&"near_wilson")
	var away_from_wilson = DomainId.place(&"away_from_wilson")
	var gerald_id = DomainId.entity(&"gerald")
	var gerald_ref = RuntimeWorldRef.entity(gerald_id)
	var wilson_ref = RuntimeWorldRef.wilson()

	var entities = EntityStore.new()
	_expect_true(entities.add_entity(EntityInstance.new(gerald_id, DomainId.entity_type(&"seagull"), camp)).ok, "Gerald entity is admitted")

	var actors = ActorStateStore.new()
	_expect_true(actors.add(ActorRuntimeState.new(gerald_ref, &"gerald", &"idle")), "Gerald actor state is admitted")
	var relationships = ActorRelationshipStore.new()
	var profile = ActorProfileDefinition.new(&"gerald", &"idle", 1.0)
	var rules: Array = [
		ActorBehaviorRule.new(&"approach_wilson", &"gerald", &"idle", &"wilson_present", &"idle", near_wilson, 0.9, wilson_ref, 0.40, 1.0),
		ActorBehaviorRule.new(&"avoid_wilson", &"gerald", &"idle", &"wilson_present", &"idle", away_from_wilson, 0.9, wilson_ref, -1.0, -0.40),
		ActorBehaviorRule.new(&"neutral_watch", &"gerald", &"idle", &"wilson_present", &"idle", camp, 0.2),
	]
	var service = ShallowActorAdvanceService.new(actors, [profile], rules, entities, relationships)
	var stimuli := {gerald_ref.sort_key(): [&"wilson_present"]}

	var neutral = service.advance(1.0, stimuli)
	_expect_equal(neutral.decisions.size(), 1, "neutral Gerald makes one decision")
	_expect_equal(neutral.decisions[0].rule_id, &"neutral_watch", "neutral relationship uses fallback behavior")
	_expect_true(entities.get_entity(gerald_id).place_id.equals(camp), "neutral Gerald stays at camp")

	for index in range(3):
		relationships.apply_impact(ActorRelationshipImpact.new(gerald_ref, wilson_ref, 0.65, 1.0, StringName("helpful_interaction_%d" % index)))
	_expect_true(relationships.affinity(gerald_ref, wilson_ref) >= 0.40, "repeated helpful interactions create positive Gerald affinity")

	var friendly = service.advance(1.0, stimuli)
	_expect_equal(friendly.decisions.size(), 1, "friendly Gerald makes one later decision")
	_expect_equal(friendly.decisions[0].rule_id, &"approach_wilson", "positive persistent relationship changes Gerald behavior")
	_expect_true(entities.get_entity(gerald_id).place_id.equals(near_wilson), "friendly Gerald moves toward Wilson")

	for index in range(5):
		relationships.apply_impact(ActorRelationshipImpact.new(gerald_ref, wilson_ref, -1.0, 1.0, StringName("hostile_interaction_%d" % index)))
	_expect_true(relationships.affinity(gerald_ref, wilson_ref) <= -0.40, "repeated hostile interactions can reverse Gerald affinity")

	var wary = service.advance(1.0, stimuli)
	_expect_equal(wary.decisions.size(), 1, "wary Gerald makes one later decision")
	_expect_equal(wary.decisions[0].rule_id, &"avoid_wilson", "negative persistent relationship changes Gerald behavior")
	_expect_true(entities.get_entity(gerald_id).place_id.equals(away_from_wilson), "wary Gerald moves away from Wilson")

	var restored = ActorRelationshipStore.new()
	var entry = relationships.get_relationship(gerald_ref, wilson_ref)
	restored.restore_entry(gerald_ref, wilson_ref, float(entry.affinity), int(entry.evidence_count), entry.last_source_execution_id)
	_expect_true(is_equal_approx(restored.affinity(gerald_ref, wilson_ref), relationships.affinity(gerald_ref, wilson_ref)), "relationship authority reconstructs from durable causes")


func _expect_true(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _expect_equal(actual: Variant, expected: Variant, message: String) -> void:
	if actual != expected:
		_failures.append("%s (expected=%s actual=%s)" % [message, expected, actual])
