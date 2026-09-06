extends SceneTree

const FIXTURE_PATH := "res://tests/scenes/long_way_around/long_way_around.tscn"
const EngineScenarioHarness = preload("res://tests/support/engine_scenario/engine_scenario_harness.gd")
const EngineScenarioSceneAdapter = preload("res://tests/support/engine_scenario/engine_scenario_scene_adapter.gd")

var _failures: Array[String] = []


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var packed: PackedScene = load(FIXTURE_PATH)
	_expect_true(packed != null, "Long Way Around fixture loads")
	if packed == null:
		_finish()
		return

	var scene = packed.instantiate()
	var harness = EngineScenarioHarness.new(EngineScenarioHarness.Mode.AUTOMATED)
	var adapter = EngineScenarioSceneAdapter.new()
	adapter.configure(scene, harness)
	root.add_child(scene)

	for _frame in range(1200):
		if harness.completed() or harness.failed():
			break
		await process_frame

	_expect_true(not harness.failed(), "Long Way Around scenario does not fail")
	if harness.failed():
		_failures.append("scenario failure: %s %s" % [String(harness.failure_code()), str(harness.failure_diagnostics())])
	_expect_true(harness.completed(), "Long Way Around scenario completes within bounded frames")

	var checkpoints = harness.checkpoints()
	var names: Array[StringName] = []
	for checkpoint in checkpoints:
		names.append(checkpoint.name)
	_expect_equal(
		names,
		[&"BOOTSTRAPPED", &"LONG_ROUTE_SELECTED", &"DETOUR_ENTERED", &"DETOUR_CROSSED", &"ARRIVED", &"COMPLETE"],
		"scenario exposes memory-to-visible-detour sequence"
	)

	if checkpoints.size() >= 6:
		var boot = checkpoints[0]
		var selected = checkpoints[1]
		var detour_entered = checkpoints[2]
		var detour_crossed = checkpoints[3]
		var arrived = checkpoints[4]
		_expect_equal(boot.probes.get("scenario"), "long_way_around", "bootstrap checkpoint keeps scenario identity")
		_expect_true(float(boot.probes.get("remembered_valence", 0.0)) < -0.9, "bootstrap reconstructs strong negative route memory")
		_expect_true(float(boot.probes.get("short_physical_cost", INF)) < float(boot.probes.get("long_physical_cost", -INF)), "short route remains physically cheaper")
		_expect_equal(selected.probes.get("route"), "long", "Wilson selects long route despite physical shortcut")
		_expect_true(float(selected.probes.get("short_adjusted_cost", -INF)) > float(selected.probes.get("long_adjusted_cost", INF)), "remembered aversion reverses route preference")

		var first_detour_position: Array = Array(detour_entered.probes.get("position", []))
		var second_detour_position: Array = Array(detour_crossed.probes.get("position", []))
		var first_detour_z := 0.0 if first_detour_position.size() != 3 else absf(float(first_detour_position[2]))
		var second_detour_z := 0.0 if second_detour_position.size() != 3 else absf(float(second_detour_position[2]))
		_expect_true(first_detour_position.size() == 3 and first_detour_z > 1.5, "Wilson materially leaves the direct corridor at first detour")
		_expect_true(second_detour_position.size() == 3 and second_detour_z > 1.5, "Wilson remains materially off the direct corridor before goal")
		_expect_true(maxf(first_detour_z, second_detour_z) > 2.0, "remembered route produces a clearly visible lateral detour")

		var final_position: Array = Array(arrived.probes.get("position", []))
		_expect_true(final_position.size() == 3 and float(final_position[0]) > 5.0 and absf(float(final_position[2])) < 1.0, "Wilson ultimately reaches the ordinary goal")

	assert(adapter != null)
	scene.queue_free()
	_finish()


func _finish() -> void:
	if _failures.is_empty():
		print("PASS long_way_around_scenario_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL long_way_around_scenario_test: %d failure(s)" % _failures.size())
	quit(1)


func _expect_true(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _expect_equal(actual: Variant, expected: Variant, message: String) -> void:
	if actual != expected:
		_failures.append("%s (expected=%s actual=%s)" % [message, expected, actual])