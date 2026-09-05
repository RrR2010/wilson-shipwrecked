extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const EntityInstance = preload("res://src/domain/world/entity_instance.gd")
const EntityStore = preload("res://src/domain/world/entity_store.gd")
const WorldRelationStore = preload("res://src/domain/world/world_relation_store.gd")
const WilsonWorldState = preload("res://src/domain/world/wilson_world_state.gd")
const BeliefStore = preload("res://src/domain/cognition/belief_store.gd")
const CurrentIntentionStore = preload("res://src/domain/cognition/current_intention_store.gd")
const ActorProfileDefinition = preload("res://src/domain/actors/actor_profile_definition.gd")
const ActorRuntimeState = preload("res://src/domain/actors/actor_runtime_state.gd")
const ActorStateStore = preload("res://src/domain/actors/actor_state_store.gd")
const ActorBehaviorRule = preload("res://src/domain/actors/actor_behavior_rule.gd")
const ShallowActorAdvanceService = preload("res://src/domain/actors/shallow_actor_advance_service.gd")
const SimulationSnapshotService = preload("res://src/infrastructure/persistence/simulation_snapshot_service.gd")

var _failures: Array[String] = []
var _completed := false


func _init() -> void:
	_run_slice()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS shallow_actor_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL shallow_actor_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_slice() -> void:
	var crab_type = DomainId.entity_type(&"crab")
	var gerald_id = DomainId.entity(&"gerald")
	var beach = DomainId.place(&"beach")
	var mangrove = DomainId.place(&"mangrove")
	var rocks = DomainId.place(&"rocks")
	var gerald = RuntimeWorldRef.entity(gerald_id)

	var entities = EntityStore.new()
	_expect_true(entities.add_entity(EntityInstance.new(gerald_id, crab_type, beach)).ok, "Gerald entity added")
	var states = ActorStateStore.new()
	var state = ActorRuntimeState.new(gerald, &"shore_crab", &"idle")
	_expect_true(states.add(state), "Gerald actor state added")

	var profile = ActorProfileDefinition.new(&"shore_crab", &"idle", 2.0)
	var forage = ActorBehaviorRule.new(&"forage", &"shore_crab", &"idle", &"", &"foraging", mangrove, 0.4)
	var flee = ActorBehaviorRule.new(&"flee_wilson", &"shore_crab", &"idle", &"wilson_close", &"fleeing", rocks, 0.9)
	var service = ShallowActorAdvanceService.new(states, [profile], [forage, flee], entities)

	var first = service.advance(0.1, {gerald.sort_key(): [&"wilson_close"]})
	_expect_equal(first["decisions"].size(), 1, "eligible actor produces one shallow decision")
	_expect_equal(state.last_rule_id, &"flee_wilson", "higher-priority matching flee rule wins")
	_expect_equal(state.mode, &"fleeing", "actor mode updates from selected rule")
	_expect_equal(entities.get_entity(gerald_id).place_id.key(), rocks.key(), "actor movement mutates authoritative World placement")
	_expect_float(state.decision_cooldown, 2.0, "selected rule resets authored decision cooldown")

	var second = service.advance(0.5, {gerald.sort_key(): [&"wilson_close"]})
	_expect_equal(second["decisions"].size(), 0, "cooldown prevents per-tick reevaluation")
	_expect_float(state.decision_cooldown, 1.5, "cooldown advances deterministically")

	var persistence = SimulationSnapshotService.new()
	var snapshot = persistence.capture(
		entities,
		WorldRelationStore.new(),
		WilsonWorldState.new(beach),
		BeliefStore.new(),
		CurrentIntentionStore.new(),
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		states
	)
	_expect_equal(snapshot["schema_version"], 10, "actor persistence uses current simulation snapshot schema")
	_expect_equal(snapshot["actors"].size(), 1, "actor runtime cause is persisted")
	var parsed = JSON.parse_string(JSON.stringify(snapshot))
	var restored = persistence.restore(parsed)
	_expect_true(restored != null, "actor snapshot restores")
	if restored != null:
		var restored_gerald = RuntimeWorldRef.entity(gerald_id)
		var restored_state = restored.actors.get_state(restored_gerald)
		_expect_true(restored_state != null, "actor runtime state survives save/load")
		if restored_state != null:
			_expect_equal(restored_state.profile_id, &"shore_crab", "actor profile binding survives")
			_expect_equal(restored_state.mode, &"fleeing", "actor mode survives")
			_expect_float(restored_state.decision_cooldown, 1.5, "actor cooldown survives")
			_expect_equal(restored_state.last_rule_id, &"flee_wilson", "actor decision provenance survives")
		_expect_equal(restored.entities.get_entity(gerald_id).place_id.key(), rocks.key(), "actor World placement survives save/load")

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
