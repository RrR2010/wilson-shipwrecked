extends SceneTree

const FIXTURE_PATH := "res://tests/scenes/post_accident_learning/post_accident_learning.tscn"
const EngineScenarioHarness = preload("res://tests/support/engine_scenario/engine_scenario_harness.gd")
const EngineScenarioSceneAdapter = preload("res://tests/support/engine_scenario/engine_scenario_scene_adapter.gd")

var _failures: Array[String] = []


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var packed: PackedScene = load(FIXTURE_PATH)
	_expect_true(packed != null, "post-accident learning fixture loads")
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
	_expect_true(not harness.failed(), "post-accident learning scenario does not fail")
	if harness.failed():
		_failures.append("scenario failure: %s %s" % [String(harness.failure_code()), str(harness.failure_diagnostics())])
	_expect_true(harness.completed(), "post-accident learning scenario completes within bounded frames")
	var checkpoints = harness.checkpoints()
	var names: Array[StringName] = []
	for checkpoint in checkpoints:
		names.append(checkpoint.name)
	_expect_equal(names, [&"BOOTSTRAPPED", &"ACCIDENT_OBSERVED", &"BODY_DAMAGED", &"ACCIDENT_LEARNED", &"LONG_ROUTE_SELECTED", &"DETOUR_ENTERED", &"DETOUR_CROSSED", &"ARRIVED", &"COMPLETE"], "scenario exposes accident-to-learning-to-later-avoidance sequence")
	if checkpoints.size() >= 9:
		var damaged = checkpoints[2]
		var learned = checkpoints[3]
		var selected = checkpoints[4]
		_expect_true(is_equal_approx(float(damaged.probes.get("vitality", 1.0)), 0.75), "grounded accident reduces Wilson vitality")
		_expect_true(float(learned.probes.get("learned_valence", 0.0)) <= -0.80, "accessible injury creates strong palm aversion")
		_expect_equal(selected.probes.get("route"), "around_palm", "learned aversion selects the detour")
		_expect_true(float(selected.probes.get("short_physical_cost", INF)) < float(selected.probes.get("long_physical_cost", INF)), "short route remains physically cheaper")
		_expect_true(float(selected.probes.get("short_adjusted_cost", 0.0)) > float(selected.probes.get("long_adjusted_cost", INF)), "memory changes preference without changing physical route cost")
	assert(adapter != null)
	scene.queue_free()
	_finish()


func _finish() -> void:
	if _failures.is_empty():
		print("PASS post_accident_learning_scenario_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL post_accident_learning_scenario_test: %d failure(s)" % _failures.size())
	quit(1)


func _expect_true(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _expect_equal(actual: Variant, expected: Variant, message: String) -> void:
	if actual != expected:
		_failures.append("%s (expected=%s actual=%s)" % [message, expected, actual])
