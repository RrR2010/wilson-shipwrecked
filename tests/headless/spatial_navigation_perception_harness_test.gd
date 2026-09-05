extends SceneTree

const FIXTURE_PATH := "res://tests/scenes/spatial_navigation_perception/spatial_navigation_perception.tscn"
const EngineScenarioHarness = preload("res://tests/support/engine_scenario/engine_scenario_harness.gd")
const EngineScenarioSceneAdapter = preload("res://tests/support/engine_scenario/engine_scenario_scene_adapter.gd")

var _failures: Array[String] = []


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var packed: PackedScene = load(FIXTURE_PATH)
	_expect_true(packed != null, "representative engine scenario loads")
	if packed == null:
		_finish()
		return

	var fixture = packed.instantiate()
	fixture.auto_start = true
	fixture.pause_at_checkpoints = false
	var harness = EngineScenarioHarness.new(EngineScenarioHarness.Mode.AUTOMATED)
	var adapter = EngineScenarioSceneAdapter.new()
	adapter.configure(fixture, harness)
	root.add_child(fixture)

	for _frame in range(1800):
		if fixture.is_completed():
			break
		await process_frame

	_expect_true(fixture.is_completed(), "engine scenario finishes within bounded test frames")
	_expect_true(harness.completed(), "successful engine scenario completes harness")
	_expect_true(not harness.failed(), "successful engine scenario does not fail harness")

	var names: Array[StringName] = []
	for checkpoint in harness.checkpoints():
		names.append(checkpoint.name)
	_expect_true(names.has(&"SCENE_READY"), "real scene emits SCENE_READY through harness")
	_expect_true(names.has(&"PASSIVE_WHILE_MOVING"), "real scene emits passive-perception checkpoint through harness")
	_expect_true(names.has(&"ARRIVED"), "real scene emits motion-arrival checkpoint through harness")
	_expect_true(names.has(&"LOS_BLOCKED"), "real scene emits LOS checkpoint through harness")
	_expect_true(names.has(&"COMPLETE"), "real scene emits COMPLETE checkpoint through harness")
	_expect_true(harness.trace().size() >= harness.checkpoints().size() + 1, "harness trace contains checkpoints plus terminal record")

	fixture.queue_free()
	await process_frame
	_finish()


func _expect_true(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print("PASS spatial_navigation_perception_harness_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL spatial_navigation_perception_harness_test: %d failure(s)" % _failures.size())
	quit(1)
