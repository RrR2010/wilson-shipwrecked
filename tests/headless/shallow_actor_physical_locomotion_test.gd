extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const EntityInstance = preload("res://src/domain/world/entity_instance.gd")
const EntityStore = preload("res://src/domain/world/entity_store.gd")
const ActorProfileDefinition = preload("res://src/domain/actors/actor_profile_definition.gd")
const ActorRuntimeState = preload("res://src/domain/actors/actor_runtime_state.gd")
const ActorStateStore = preload("res://src/domain/actors/actor_state_store.gd")
const ActorBehaviorRule = preload("res://src/domain/actors/actor_behavior_rule.gd")
const ShallowActorAdvanceService = preload("res://src/domain/actors/shallow_actor_advance_service.gd")
const ShallowActorMotionCoordinator = preload("res://src/application/simulation/shallow_actor_motion_coordinator.gd")
const MotionPort = preload("res://src/application/simulation/motion_port.gd")
const FakeMotionPort = preload("res://tests/fakes/fake_motion_port.gd")

var _failures: Array[String] = []


func _init() -> void:
	_run()
	if _failures.is_empty():
		print("PASS shallow_actor_physical_locomotion_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL shallow_actor_physical_locomotion_test: %d failure(s)" % _failures.size())
	quit(1)


func _run() -> void:
	var gerald_id = DomainId.entity(&"gerald")
	var gerald_ref: RuntimeWorldRef = RuntimeWorldRef.entity(gerald_id)
	var camp = DomainId.place(&"gerald_camp")
	var near_wilson = DomainId.place(&"near_wilson")
	var entities = EntityStore.new()
	_expect_true(entities.add_entity(EntityInstance.new(gerald_id, DomainId.entity_type(&"seagull"), camp)).ok, "Gerald entity added")

	var states = ActorStateStore.new()
	_expect_true(states.add(ActorRuntimeState.new(gerald_ref, &"gerald", &"idle")), "Gerald actor state added")
	var actor_advance = ShallowActorAdvanceService.new(
		states,
		[ActorProfileDefinition.new(&"gerald", &"idle", 1.0)],
		[ActorBehaviorRule.new(&"approach_wilson", &"gerald", &"idle", &"wilson_present", &"approaching", near_wilson, 0.9)],
		entities
	)

	var result = actor_advance.advance_deferred(1.0, {gerald_ref.sort_key(): [&"wilson_present"]})
	_expect_equal(result.decisions.size(), 1, "deferred advance still selects Gerald behavior")
	_expect_equal(result.movement_requests.size(), 1, "destination behavior emits one deferred movement request")
	_expect_true(entities.get_entity(gerald_id).place_id.equals(camp), "decision does not teleport authoritative Gerald place")
	_expect_equal(states.get_state(gerald_ref).mode, &"approaching", "behavior mode still advances at decision time")

	var motion = FakeMotionPort.new()
	var coordinator = ShallowActorMotionCoordinator.new(motion, entities)
	_expect_true(coordinator.request(result.movement_requests[0]), "deferred movement starts through MotionPort")
	_expect_equal(motion.request_history.size(), 1, "MotionPort receives exactly one movement request")
	if not motion.request_history.is_empty():
		var target = motion.request_history[0].target
		_expect_equal(target.kind, RuntimeWorldRef.Kind.PLACE, "physical target is a place RuntimeWorldRef")
		_expect_true(target.id.equals(near_wilson), "physical target preserves authored destination place")
	_expect_true(entities.get_entity(gerald_id).place_id.equals(camp), "MOVING status still leaves semantic place at origin")
	_expect_true(coordinator.has_pending(gerald_ref), "coordinator tracks the in-flight actor move")

	var moving = coordinator.reconcile()
	_expect_equal(moving.arrived.size(), 0, "MOVING does not commit destination")
	_expect_true(entities.get_entity(gerald_id).place_id.equals(camp), "reconcile while MOVING preserves origin place")

	motion.set_status(gerald_ref, MotionPort.MotionStatus.ARRIVED)
	var arrived = coordinator.reconcile()
	_expect_equal(arrived.arrived.size(), 1, "ARRIVED commits exactly one actor relocation")
	_expect_true(entities.get_entity(gerald_id).place_id.equals(near_wilson), "ARRIVED commits authoritative destination place")
	_expect_true(not coordinator.has_pending(gerald_ref), "arrival clears pending movement")


func _expect_true(actual: bool, label: String) -> void:
	if not actual:
		_failures.append("Expected true: %s" % label)


func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
