extends SceneTree

const FIXTURE_PATH := "res://tests/scenes/deterministic_playable_bootstrap/deterministic_playable_bootstrap.tscn"
const EngineScenarioHarness = preload("res://tests/support/engine_scenario/engine_scenario_harness.gd")
const EngineScenarioSceneAdapter = preload("res://tests/support/engine_scenario/engine_scenario_scene_adapter.gd")

var _failures: Array[String] = []


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var packed: PackedScene = load(FIXTURE_PATH)
	_expect_true(packed != null, "playable bootstrap fixture loads")
	if packed == null:
		_finish()
		return

	var scene = packed.instantiate()
	var harness = EngineScenarioHarness.new(EngineScenarioHarness.Mode.AUTOMATED)
	EngineScenarioSceneAdapter.new().configure(scene, harness)
	root.add_child(scene)

	for _frame in range(900):
		if harness.completed() or harness.failed():
			break
		await process_frame

	_expect_true(not harness.failed(), "playable bootstrap scenario does not fail")
	if harness.failed():
		_failures.append("scenario failure: %s %s" % [String(harness.failure_code()), str(harness.failure_diagnostics())])
	_expect_true(harness.completed(), "playable bootstrap scenario completes within bounded frames")

	var checkpoints = harness.checkpoints()
	var names: Array[StringName] = []
	for checkpoint in checkpoints:
		names.append(checkpoint.name)
	_expect_equal(
		names,
		[&"BOOTSTRAPPED", &"INTENTION_RESUMED", &"MOVING", &"ARRIVED", &"COMPLETE"],
		"scenario exposes causal bootstrap-to-arrival checkpoint sequence"
	)

	if checkpoints.size() >= 5:
		var boot = checkpoints[0]
		var resumed = checkpoints[1]
		var moving = checkpoints[2]
		var arrived = checkpoints[3]
		_expect_equal(boot.probes.get("scenario"), "deterministic_playable_bootstrap", "bootstrap checkpoint keeps deterministic scenario identity")
		_expect_equal(int(boot.probes.get("seed", -1)), 41027, "bootstrap checkpoint keeps deterministic gameplay seed")
		_expect_true(String(boot.probes.get("current_intention", "")).contains("seek_food"), "bootstrap reconstructs authoritative selected intention")
		_expect_true(int(resumed.probes.get("motion_status", -1)) == 1, "resumed intention produces semantic MOVING status")
		_expect_true(int(moving.semantic_step) >= 0, "moving checkpoint is observable while GodotSimulationHost is active")
		_expect_true(int(arrived.semantic_step) > 0, "arrival occurs after semantic host progression")
		var final_position: Array = Array(arrived.probes.get("position", []))
		_expect_true(final_position.size() == 3 and float(final_position[0]) > 5.0, "Wilson physically reaches the target side of the 3D scene")

	scene.queue_free()
	_finish()


func _finish() -> void:
	if _failures.is_empty():
		print("PASS deterministic_playable_bootstrap_scenario_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL deterministic_playable_bootstrap_scenario_test: %d failure(s)" % _failures.size())
	quit(1)


func _expect_true(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _expect_equal(actual: Variant, expected: Variant, message: String) -> void:
	if actual != expected:
		_failures.append("%s (expected=%s actual=%s)" % [message, expected, actual])
