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
const EnvironmentWorldAdvanceService = preload("res://src/application/simulation/environment_world_advance_service.gd")
const EmptyDynamicProcessAdvance = preload("res://tests/headless/fixtures/empty_dynamic_process_advance.gd")
const StaticActorStimulusProvider = preload("res://tests/headless/fixtures/static_actor_stimulus_provider.gd")

var _failures: Array[String] = []
var _completed := false


func _init() -> void:
	_run_slice()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS actor_simulation_integration_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL actor_simulation_integration_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_slice() -> void:
	var bird_type = DomainId.entity_type(&"shore_bird")
	var bird_id = DomainId.entity(&"bird_1")
	var beach = DomainId.place(&"beach")
	var palms = DomainId.place(&"palms")
	var bird = RuntimeWorldRef.entity(bird_id)
	var entities = EntityStore.new()
	_expect_true(entities.add_entity(EntityInstance.new(bird_id, bird_type, beach)).ok, "bird entity added")

	var states = ActorStateStore.new()
	_expect_true(states.add(ActorRuntimeState.new(bird, &"shore_bird", &"idle")), "bird actor state added")
	var actor_advance = ShallowActorAdvanceService.new(
		states,
		[ActorProfileDefinition.new(&"shore_bird", &"idle", 1.0)],
		[ActorBehaviorRule.new(&"avoid_wilson", &"shore_bird", &"idle", &"wilson_close", &"fleeing", palms, 0.8)],
		entities
	)
	var stimuli = StaticActorStimulusProvider.new({bird.sort_key(): [&"wilson_close"]})
	var world_advance = EnvironmentWorldAdvanceService.new(EmptyDynamicProcessAdvance.new(), actor_advance, stimuli)

	var result = world_advance.advance(0.25, null)
	_expect_true(result != null, "composed World advance returns result")
	_expect_equal(entities.get_entity(bird_id).place_id.key(), palms.key(), "shallow actor progresses inside authoritative World advance")
	_expect_equal(states.get_state(bird).mode, &"fleeing", "actor runtime mode advances inside World step")
	_expect_equal(result.diagnostics.size(), 0, "actor World advance introduces no diagnostics")
	_expect_true(result.change_set.is_empty(), "coarse actor relocation does not pretend to be physical-profile invalidation")

	_completed = true


func _expect_true(actual: bool, label: String) -> void:
	if not actual:
		_failures.append("Expected true: %s" % label)


func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
