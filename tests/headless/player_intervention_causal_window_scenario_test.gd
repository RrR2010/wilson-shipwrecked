extends SceneTree

const FIXTURE_PATH := "res://tests/scenes/player_intervention_causal_window/player_intervention_causal_window.tscn"
const EngineScenarioHarness = preload("res://tests/support/engine_scenario/engine_scenario_harness.gd")
const EngineScenarioSceneAdapter = preload("res://tests/support/engine_scenario/engine_scenario_scene_adapter.gd")

var _failures: Array[String] = []


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var packed: PackedScene = load(FIXTURE_PATH)
	_expect_true(packed != null, "player intervention causal-window fixture loads")
	if packed == null:
		_finish()
		return

	var scene = packed.instantiate()
	var harness = EngineScenarioHarness.new(EngineScenarioHarness.Mode.AUTOMATED)
	var adapter = EngineScenarioSceneAdapter.new()
	adapter.configure(scene, harness)
	root.add_child(scene)

	for _frame in range(540):
		if harness.completed() or harness.failed():
			break
		await process_frame

	_expect_true(not harness.failed(), "player intervention causal-window scenario does not fail")
	if harness.failed():
		_failures.append("scenario failure: %s %s" % [String(harness.failure_code()), str(harness.failure_diagnostics())])
	_expect_true(harness.completed(), "player intervention causal-window scenario completes within bounded frames")

	var checkpoints = harness.checkpoints()
	var names: Array[StringName] = []
	for checkpoint in checkpoints:
		names.append(checkpoint.name)
	_expect_equal(
		names,
		[
			&"BOOTSTRAPPED",
			&"EARLY_INTERVENTION_COMMITTED",
			&"EARLY_COLLISION_AVOIDED",
			&"LATE_COLLISION_COMMITTED",
			&"LATE_INTERVENTION_COMMITTED",
			&"COMMITTED_INJURY_PRESERVED",
			&"COMPLETE",
		],
		"scenario exposes early-open versus post-consequence causal windows"
	)

	if checkpoints.size() >= 7:
		var avoided = checkpoints[2]
		var collision = checkpoints[3]
		var late = checkpoints[4]
		var preserved = checkpoints[5]
		_expect_true(bool(avoided.probes.get("early_avoided", false)), "early intervention changes unresolved collision future")
		_expect_true(is_equal_approx(float(avoided.probes.get("vitality", -1.0)), 1.0), "early intervention prevents injury before collision commitment")
		_expect_equal(int(collision.probes.get("injury_event_count", 0)), 1, "late palm grounds one committed injury event")
		_expect_true(is_equal_approx(float(collision.probes.get("vitality", -1.0)), 0.75), "late collision reduces vitality before later intervention")
		_expect_equal(int(late.probes.get("world_intervention_calls", 0)), 2, "both physical future-motion interventions commit through World port")
		_expect_true(is_equal_approx(float(late.probes.get("god_power", -1.0)), 6.0), "only committed interventions spend authored God Power")
		_expect_true(is_equal_approx(float(preserved.probes.get("vitality", -1.0)), 0.75), "late intervention cannot retroactively restore committed injury")
		_expect_equal(int(preserved.probes.get("injury_event_count", 0)), 1, "committed injury history remains stable")

	assert(adapter != null)
	scene.queue_free()
	_finish()


func _finish() -> void:
	if _failures.is_empty():
		print("PASS player_intervention_causal_window_scenario_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL player_intervention_causal_window_scenario_test: %d failure(s)" % _failures.size())
	quit(1)


func _expect_true(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _expect_equal(actual: Variant, expected: Variant, message: String) -> void:
	if actual != expected:
		_failures.append("%s (expected=%s actual=%s)" % [message, expected, actual])
