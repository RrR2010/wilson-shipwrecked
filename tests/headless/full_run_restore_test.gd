extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const ContentRegistry = preload("res://src/domain/content/content_registry.gd")
const EntityStore = preload("res://src/domain/world/entity_store.gd")
const WorldRelationStore = preload("res://src/domain/world/world_relation_store.gd")
const WilsonWorldState = preload("res://src/domain/world/wilson_world_state.gd")
const BeliefStore = preload("res://src/domain/cognition/belief_store.gd")
const CurrentIntentionStore = preload("res://src/domain/cognition/current_intention_store.gd")
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
		print("PASS full_run_restore_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL full_run_restore_test: %d failure(s)" % _failures.size())
	quit(1)


func _run() -> void:
	var content = ContentRegistry.new()
	_expect_true(content.seal().ok, "empty authored content seals")

	var camp = DomainId.place(&"full_restore_camp")
	var entities = EntityStore.new()
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

	var run_lifecycle = RunLifecycleState.new(&"run_full_restore")
	_expect_true(run_lifecycle.mark_dead(&"exposure").ok, "source run admits death")
	run_lifecycle.resurrection_count = 2

	var profile = PlayerProfile.new()
	profile.increment_stat(&"runs_completed", 7)
	profile.unlock(&"archive_marker")

	var director = DirectorStateStore.new()
	var player = PlayerRunState.new(8.5, [&"move_small_object"])
	player.record_non_intervention(17.0)

	var simulation_snapshot = SimulationSnapshotService.new().capture(
		entities,
		relations,
		wilson_world,
		beliefs,
		intentions
	)
	var action_snapshot = ActionExecutionSnapshotService.new().capture(runtime_result.composition.action_execution)
	var run_profile_snapshot = RunProfileSnapshotService.new().capture(run_lifecycle, profile)
	var director_player_snapshot = DirectorPlayerSnapshotService.new().capture(director, player)

	var parsed_simulation = JSON.parse_string(JSON.stringify(simulation_snapshot))
	var parsed_actions = JSON.parse_string(JSON.stringify(action_snapshot))
	var parsed_run_profile = JSON.parse_string(JSON.stringify(run_profile_snapshot))
	var parsed_director_player = JSON.parse_string(JSON.stringify(director_player_snapshot))
	_expect_true(parsed_simulation is Dictionary, "simulation snapshot survives JSON boundary")
	_expect_true(parsed_actions is Dictionary, "action snapshot survives JSON boundary")
	_expect_true(parsed_run_profile is Dictionary, "run/profile snapshot survives JSON boundary")
	_expect_true(parsed_director_player is Dictionary, "Director/player snapshot survives JSON boundary")
	if not (parsed_simulation is Dictionary) or not (parsed_actions is Dictionary) or not (parsed_run_profile is Dictionary) or not (parsed_director_player is Dictionary):
		_completed = true
		return

	var restored = RunRuntimeRestoreService.new().restore(
		parsed_simulation,
		parsed_actions,
		content,
		parsed_run_profile,
		parsed_director_player
	)
	_expect_true(restored.ok, "full current-run restore succeeds")
	if not restored.ok:
		_completed = true
		return

	_expect_true(restored.simulation.entities != entities, "simulation owners are freshly reconstructed")
	_expect_true(restored.runtime != runtime_result.composition, "runtime is freshly reconstructed")
	_expect_true(restored.run_lifecycle != run_lifecycle, "run lifecycle is freshly reconstructed")
	_expect_true(restored.director != director, "Director owner is freshly reconstructed")
	_expect_true(restored.player != player, "PlayerRunState is freshly reconstructed")
	_expect_equal(restored.run_lifecycle.run_id, &"run_full_restore", "run id survives full restore")
	_expect_equal(restored.run_lifecycle.lifecycle, RunLifecycleState.Lifecycle.DEAD, "run lifecycle survives full restore")
	_expect_equal(restored.run_lifecycle.death_count, 1, "death count survives full restore")
	_expect_equal(restored.run_lifecycle.resurrection_count, 2, "resurrection count survives full restore")
	_expect_equal(restored.run_lifecycle.last_death_cause, &"exposure", "death cause survives full restore")
	_expect_float(restored.player.god_power, 8.5, "God Power survives full restore")
	_expect_true(restored.player.has_permission(&"move_small_object"), "player permission survives full restore")
	_expect_float(restored.player.non_intervention_seconds, 17.0, "non-intervention progress survives full restore")
	_expect_equal(restored.director.states().size(), 0, "empty Director owner survives full restore")
	_expect_equal(restored.action_restore_results.size(), 0, "empty action lifecycle restores deterministically")

	restored.player.spend(1.0)
	_expect_float(player.god_power, 8.5, "restored player mutation does not alias source owner")
	_expect_equal(profile.stat(&"runs_completed"), 7, "cross-run profile remains outside runtime restore")
	_expect_true(profile.is_unlocked(&"archive_marker"), "cross-run profile is not consumed or mutated")

	var incomplete = RunRuntimeRestoreService.new().restore(
		parsed_simulation,
		parsed_actions,
		content,
		parsed_run_profile
	)
	_expect_true(not incomplete.ok, "partial current-run snapshot pair is rejected")
	_expect_equal(incomplete.code, &"incomplete_current_run_snapshot", "partial pair rejection is semantic")

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
