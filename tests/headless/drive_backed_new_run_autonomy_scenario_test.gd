extends SceneTree

const FIXTURE_PATH := "res://tests/scenes/drive_backed_new_run_autonomy/drive_backed_new_run_autonomy.tscn"
const EngineScenarioHarness = preload("res://tests/support/engine_scenario/engine_scenario_harness.gd")
const EngineScenarioSceneAdapter = preload("res://tests/support/engine_scenario/engine_scenario_scene_adapter.gd")

var _failures: Array[String] = []
var _completed := false


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var packed: PackedScene = load(FIXTURE_PATH)
	_expect_true(packed != null, "drive-backed new-run fixture loads")
	if packed == null:
		_finish()
		return

	var scene = packed.instantiate()
	var harness = EngineScenarioHarness.new(EngineScenarioHarness.Mode.AUTOMATED)
	var adapter = EngineScenarioSceneAdapter.new()
	adapter.configure(scene, harness)
	root.add_child(scene)

	for _frame in range(1000):
		if harness.completed() or harness.failed():
			break
		await process_frame

	_expect_true(not harness.failed(), "drive-backed new-run scenario does not fail")
	if harness.failed():
		_failures.append("scenario failure: %s %s" % [String(harness.failure_code()), str(harness.failure_diagnostics())])
	_expect_true(harness.completed(), "drive-backed new-run scenario completes within bounded frames")

	var checkpoints = harness.checkpoints()
	var names: Array[StringName] = []
	for checkpoint in checkpoints:
		names.append(checkpoint.name)
	_expect_equal(
		names,
		[&"BOOTSTRAPPED", &"DRIVE_PRESSING", &"INTENTION_SELECTED", &"MOVING", &"ARRIVED", &"COMPLETE"],
		"scenario exposes drive-to-autonomous-arrival causal sequence"
	)

	if checkpoints.size() >= 6:
		var boot = checkpoints[0]
		var pressing = checkpoints[1]
		var selected = checkpoints[2]
		var moving = checkpoints[3]
		var arrived = checkpoints[4]
		_expect_equal(boot.probes.get("scenario"), "drive_backed_new_run_autonomy", "bootstrap checkpoint keeps deterministic scenario identity")
		_expect_equal(int(boot.probes.get("seed", -1)), 52031, "bootstrap checkpoint keeps deterministic gameplay seed")
		_expect_float(boot.probes.get("hunger"), 0.54, "new run begins below pressing hunger threshold")
		_expect_true(not bool(boot.probes.get("has_current_intention", true)), "new run does not seed a selected intention")
		_expect_equal(int(boot.probes.get("belief_count", -1)), 1, "new run carries one durable known-food belief")
		_expect_true(float(pressing.probes.get("hunger", 0.0)) >= 0.55, "drive progression opens pressing urgency")
		_expect_true(int(pressing.semantic_step) > 0, "drive crossing occurs through semantic host progression")
		_expect_true(String(selected.probes.get("current_intention", "")).contains("seek_food"), "cognition selects seek_food after drive trigger")
		_expect_true(String(selected.probes.get("current_target", "")).contains("known_food_patch"), "selected intention targets Wilson's believed food opportunity")
		_expect_equal(int(moving.probes.get("motion_status", -1)), 1, "selected intention reifies into MOVING Godot motion")
		_expect_true(int(arrived.semantic_step) >= int(selected.semantic_step), "arrival follows autonomous semantic selection")
		var final_position: Array = Array(arrived.probes.get("position", []))
		_expect_true(final_position.size() == 3 and float(final_position[0]) > 5.0, "Wilson physically reaches the believed food target")

	assert(adapter != null)
	scene.queue_free()
	_completed = true
	_finish()


func _finish() -> void:
	if not _completed and _failures.is_empty():
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS drive_backed_new_run_autonomy_scenario_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL drive_backed_new_run_autonomy_scenario_test: %d failure(s)" % _failures.size())
	quit(1)


func _expect_true(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _expect_equal(actual: Variant, expected: Variant, message: String) -> void:
	if actual != expected:
		_failures.append("%s (expected=%s actual=%s)" % [message, expected, actual])


func _expect_float(actual: Variant, expected: float, message: String) -> void:
	if actual == null or not is_equal_approx(float(actual), expected):
		_failures.append("%s (expected=%s actual=%s)" % [message, expected, actual])
