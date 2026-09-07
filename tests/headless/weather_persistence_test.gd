extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const EntityStore = preload("res://src/domain/world/entity_store.gd")
const WorldRelationStore = preload("res://src/domain/world/world_relation_store.gd")
const WilsonWorldState = preload("res://src/domain/world/wilson_world_state.gd")
const EnvironmentState = preload("res://src/domain/world/environment_state.gd")
const BeliefStore = preload("res://src/domain/cognition/belief_store.gd")
const CurrentIntentionStore = preload("res://src/domain/cognition/current_intention_store.gd")
const SimulationSnapshotService = preload("res://src/infrastructure/persistence/simulation_snapshot_service.gd")

var _failures: Array[String] = []
var _completed := false


func _init() -> void:
	_run_slice()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS weather_persistence_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL weather_persistence_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_slice() -> void:
	var environment = EnvironmentState.new(&"rain", &"day", 0.75, 3.5, 7)
	var persistence = SimulationSnapshotService.new()
	var snapshot = persistence.capture(
		EntityStore.new(),
		WorldRelationStore.new(),
		WilsonWorldState.new(DomainId.place(&"beach")),
		BeliefStore.new(),
		CurrentIntentionStore.new(),
		null,
		null,
		null,
		null,
		null,
		null,
		environment
	)
	_expect_equal(snapshot["schema_version"], 12, "procedural weather persistence advances simulation schema")
	_expect_true(is_equal_approx(float(snapshot["environment"]["weather_elapsed"]), 0.75), "snapshot captures weather elapsed")
	_expect_true(is_equal_approx(float(snapshot["environment"]["weather_planned_duration"]), 3.5), "snapshot captures planned regime duration")
	_expect_equal(int(snapshot["environment"]["weather_transition_index"]), 7, "snapshot captures deterministic transition index")

	var restored = persistence.restore(JSON.parse_string(JSON.stringify(snapshot)))
	_expect_equal(restored.environment.weather, &"rain", "weather regime restores")
	_expect_true(is_equal_approx(restored.environment.weather_elapsed, 0.75), "weather elapsed restores")
	_expect_true(is_equal_approx(restored.environment.weather_planned_duration, 3.5), "planned regime duration restores")
	_expect_equal(restored.environment.weather_transition_index, 7, "transition index restores")

	_completed = true


func _expect_true(actual: bool, label: String) -> void:
	if not actual:
		_failures.append("Expected true: %s" % label)


func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
