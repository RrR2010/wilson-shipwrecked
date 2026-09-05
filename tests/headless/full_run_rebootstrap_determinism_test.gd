extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const ContentRegistry = preload("res://src/domain/content/content_registry.gd")
const EntityDefinition = preload("res://src/domain/content/entity_definition.gd")
const EventDefinition = preload("res://src/domain/content/event_definition.gd")
const EntityInstance = preload("res://src/domain/world/entity_instance.gd")
const EntityStore = preload("res://src/domain/world/entity_store.gd")
const WorldRelationStore = preload("res://src/domain/world/world_relation_store.gd")
const WilsonWorldState = preload("res://src/domain/world/wilson_world_state.gd")
const BeliefStore = preload("res://src/domain/cognition/belief_store.gd")
const CurrentIntentionStore = preload("res://src/domain/cognition/current_intention_store.gd")
const RequirementPredicate = preload("res://src/domain/actions/requirement_predicate.gd")
const ActionDefinition = preload("res://src/domain/actions/action_definition.gd")
const ActionResolutionDefinition = preload("res://src/domain/actions/action_resolution_definition.gd")
const RoleBinding = preload("res://src/domain/actions/role_binding.gd")
const DirectorStateStore = preload("res://src/domain/director/director_state_store.gd")
const PlayerRunState = preload("res://src/domain/player/player_run_state.gd")
const PlayerProfile = preload("res://src/domain/player/player_profile.gd")
const RunLifecycleState = preload("res://src/application/lifecycle/run_lifecycle_state.gd")
const RunRuntimeComposer = preload("res://src/application/simulation/run_runtime_composer.gd")
const SimulationSnapshotService = preload("res://src/infrastructure/persistence/simulation_snapshot_service.gd")
const ActionExecutionSnapshotService = preload("res://src/infrastructure/persistence/action_execution_snapshot_service.gd")
const RunProfileSnapshotService = preload("res://src/infrastructure/persistence/run_profile_snapshot_service.gd")
const DirectorPlayerSnapshotService = preload("res://src/infrastructure/persistence/director_player_snapshot_service.gd")
const RunRuntimeRestoreService = preload("res://src/infrastructure/persistence/run_runtime_restore_service.gd")

var _failures: Array[String] = []
var _completed := false


func _init() -> void:
	_run()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS full_run_rebootstrap_determinism_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL full_run_rebootstrap_determinism_test: %d failure(s)" % _failures.size())
	quit(1)


func _run() -> void:
	var camp = DomainId.place(&"rebootstrap_camp")
	var crate_type = DomainId.entity_type(&"rebootstrap_crate")
	var crate_id = DomainId.entity(&"rebootstrap_crate_1")
	var action_id = DomainId.action(&"inspect_rebootstrap_crate")
	var event_id = DomainId.event_definition(&"rebootstrap_inspection_committed")
	var action = ActionDefinition.new(action_id, [&"actor", &"target"], RequirementPredicate.all_of([]))
	var resolution = ActionResolutionDefinition.new(
		action_id,
		1.0,
		0.5,
		[],
		event_id,
		&"inspect_rebootstrap_v1"
	)

	var content = ContentRegistry.new()
	_expect_true(content.register_entity_definition(EntityDefinition.new(crate_type, [], {}, [])).ok, "entity definition registers")
	_expect_true(content.register_event_definition(EventDefinition.new(event_id, [&"target"], [&"vision"])).ok, "event definition registers")
	_expect_true(content.register_action_definition(action).ok, "action definition registers")
	_expect_true(content.register_action_resolution_definition(resolution).ok, "resolution definition registers")
	_expect_true(content.seal().ok, "content seals")

	var entities = EntityStore.new()
	_expect_true(entities.add_entity(EntityInstance.new(crate_id, crate_type, camp)).ok, "crate entity admitted")
	var relations = WorldRelationStore.new()
	var wilson_world = WilsonWorldState.new(camp)
	var beliefs = BeliefStore.new()
	var intentions = CurrentIntentionStore.new()
	var runtime_result = RunRuntimeComposer.new().compose(
		entities,
		relations,
		wilson_world,
		beliefs,
		intentions,
		content
	)
	_expect_true(runtime_result.ok, "source runtime composes")
	if not runtime_result.ok:
		_completed = true
		return

	var bindings = RoleBinding.new()
	bindings.bind(&"actor", RuntimeWorldRef.wilson())
	bindings.bind(&"target", RuntimeWorldRef.entity(crate_id))
	_expect_true(runtime_result.composition.action_execution.start(&"rebootstrap_exec", action, resolution, bindings) != null, "source action starts")
	var progress = runtime_result.composition.action_execution.advance(&"rebootstrap_exec", 0.25)
	_expect_true(not progress.committed, "source action remains pre-commit")

	var run_lifecycle = RunLifecycleState.new(&"run_rebootstrap")
	_expect_true(run_lifecycle.mark_dead(&"storm_exposure").ok, "source lifecycle admits death")
	run_lifecycle.resurrection_count = 3
	var profile = PlayerProfile.new()
	profile.increment_stat(&"runs_completed", 4)
	var director = DirectorStateStore.new()
	var player = PlayerRunState.new(9.0, [&"move_small_object"])
	player.record_non_intervention(13.0)

	var simulation_snapshot = SimulationSnapshotService.new().capture(entities, relations, wilson_world, beliefs, intentions)
	var action_snapshot = ActionExecutionSnapshotService.new().capture(runtime_result.composition.action_execution)
	var run_profile_snapshot = RunProfileSnapshotService.new().capture(run_lifecycle, profile)
	var director_player_snapshot = DirectorPlayerSnapshotService.new().capture(director, player)

	var parsed_simulation = JSON.parse_string(JSON.stringify(simulation_snapshot))
	var parsed_actions = JSON.parse_string(JSON.stringify(action_snapshot))
	var parsed_run_profile = JSON.parse_string(JSON.stringify(run_profile_snapshot))
	var parsed_director_player = JSON.parse_string(JSON.stringify(director_player_snapshot))
	if not (parsed_simulation is Dictionary) or not (parsed_actions is Dictionary) or not (parsed_run_profile is Dictionary) or not (parsed_director_player is Dictionary):
		_failures.append("All durable snapshots must survive JSON boundary")
		_completed = true
		return

	var service = RunRuntimeRestoreService.new()
	var first = service.restore(parsed_simulation, parsed_actions, content, parsed_run_profile, parsed_director_player)
	var second = service.restore(parsed_simulation, parsed_actions, content, parsed_run_profile, parsed_director_player)
	_expect_true(first.ok and second.ok, "same durable causes rebootstrap twice")
	if not first.ok or not second.ok:
		_completed = true
		return

	# Fresh ownership: no authoritative or reconstructible mutable runtime object is shared.
	_expect_true(first.simulation.entities != second.simulation.entities, "EntityStore ownership is fresh")
	_expect_true(first.simulation.relations != second.simulation.relations, "relation ownership is fresh")
	_expect_true(first.simulation.wilson_world_state != second.simulation.wilson_world_state, "WilsonWorldState ownership is fresh")
	_expect_true(first.runtime != second.runtime, "runtime composition ownership is fresh")
	_expect_true(first.runtime.action_execution != second.runtime.action_execution, "ActionExecutionService ownership is fresh")
	_expect_true(first.run_lifecycle != second.run_lifecycle, "RunLifecycleState ownership is fresh")
	_expect_true(first.director != second.director, "DirectorStateStore ownership is fresh")
	_expect_true(first.player != second.player, "PlayerRunState ownership is fresh")
	_expect_true(first.simulation.entities.get_entity(crate_id) != second.simulation.entities.get_entity(crate_id), "entity instance ownership is fresh")
	_expect_true(first.runtime.action_execution.get_state(&"rebootstrap_exec") != second.runtime.action_execution.get_state(&"rebootstrap_exec"), "action execution state ownership is fresh")

	# Semantic equivalence: both reconstructions express the same durable causes.
	_expect_equal(first.simulation.wilson_world_state.place_id.sort_key(), second.simulation.wilson_world_state.place_id.sort_key(), "Wilson location is deterministic")
	_expect_equal(first.simulation.wilson_world_state.place_id.sort_key(), camp.sort_key(), "Wilson location reconstructs the durable place")
	_expect_equal(first.simulation.entities.get_entity(crate_id).id.sort_key(), second.simulation.entities.get_entity(crate_id).id.sort_key(), "entity identity is deterministic")
	_expect_equal(first.run_lifecycle.run_id, second.run_lifecycle.run_id, "run id is deterministic")
	_expect_equal(first.run_lifecycle.lifecycle, second.run_lifecycle.lifecycle, "run lifecycle is deterministic")
	_expect_equal(first.run_lifecycle.death_count, second.run_lifecycle.death_count, "death count is deterministic")
	_expect_equal(first.run_lifecycle.resurrection_count, second.run_lifecycle.resurrection_count, "resurrection count is deterministic")
	_expect_float(first.player.god_power, second.player.god_power, "God Power is deterministic")
	_expect_float(first.player.non_intervention_seconds, second.player.non_intervention_seconds, "non-intervention state is deterministic")
	var first_action = first.runtime.action_execution.get_state(&"rebootstrap_exec")
	var second_action = second.runtime.action_execution.get_state(&"rebootstrap_exec")
	_expect_float(first_action.elapsed, second_action.elapsed, "action elapsed is deterministic")
	_expect_equal(first_action.committed, second_action.committed, "action commit marker is deterministic")
	_expect_equal(first_action.outcome_emitted, second_action.outcome_emitted, "action outcome marker is deterministic")

	# Mutating the first reconstructed run cannot contaminate the second or durable input snapshots.
	first.player.spend(2.0)
	first.run_lifecycle.mark_resurrected()
	var crossed = first.runtime.action_execution.advance(&"rebootstrap_exec", 0.25)
	_expect_true(crossed.committed and crossed.new_outcome != null, "first reconstructed action can advance independently")
	_expect_float(second.player.god_power, 9.0, "second player is isolated from first mutation")
	_expect_equal(second.run_lifecycle.lifecycle, RunLifecycleState.Lifecycle.DEAD, "second lifecycle is isolated from first mutation")
	_expect_float(second.runtime.action_execution.get_state(&"rebootstrap_exec").elapsed, 0.25, "second action execution is isolated from first mutation")
	_expect_equal(String(parsed_run_profile["run"]["run_id"]), "run_rebootstrap", "run snapshot remains immutable input")
	_expect_float(parsed_director_player["player"]["god_power"], 9.0, "player snapshot remains immutable input")
	_expect_float(parsed_actions["executions"][0]["elapsed"], 0.25, "action snapshot remains immutable input")

	_completed = true


func _expect_true(actual: bool, label: String) -> void:
	if not actual:
		_failures.append("Expected true: %s" % label)


func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])


func _expect_float(actual: Variant, expected: Variant, label: String) -> void:
	if actual == null or expected == null or not is_equal_approx(float(actual), float(expected)):
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
