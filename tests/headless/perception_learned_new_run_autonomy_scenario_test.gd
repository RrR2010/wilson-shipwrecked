extends SceneTree

const FIXTURE_PATH := "res://tests/scenes/perception_learned_new_run_autonomy/perception_learned_new_run_autonomy.tscn"
const EngineScenarioHarness = preload("res://tests/support/engine_scenario/engine_scenario_harness.gd")
const EngineScenarioSceneAdapter = preload("res://tests/support/engine_scenario/engine_scenario_scene_adapter.gd")

var _failures: Array[String] = []


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var packed: PackedScene = load(FIXTURE_PATH)
	_expect_true(packed != null, "perception-learned autonomy fixture loads")
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

	_expect_true(not harness.failed(), "perception-learned autonomy scenario does not fail")
	if harness.failed():
		_failures.append("scenario failure: %s %s" % [String(harness.failure_code()), str(harness.failure_diagnostics())])
	_expect_true(harness.completed(), "perception-learned autonomy scenario completes within bounded frames")

	var checkpoints = harness.checkpoints()
	var names: Array[StringName] = []
	for checkpoint in checkpoints:
		names.append(checkpoint.name)
	_expect_equal(
		names,
		[
			&"BOOTSTRAPPED",
			&"PERCEPTION_LEARNED",
			&"DRIVE_PRESSING",
			&"INTENTION_SELECTED",
			&"MOVING",
			&"ARRIVED",
			&"ACTION_STARTED",
			&"ACTION_COMMITTED",
			&"HUNGER_REDUCED",
			&"COMPLETE",
		],
		"scenario exposes perception-learning-to-grounded-consumption sequence"
	)

	if checkpoints.size() >= 10:
		var boot = checkpoints[0]
		var learned = checkpoints[1]
		var pressing = checkpoints[2]
		var selected = checkpoints[3]
		var moving = checkpoints[4]
		var arrived = checkpoints[5]
		var action_started = checkpoints[6]
		var action_committed = checkpoints[7]
		var hunger_reduced = checkpoints[8]
		var complete = checkpoints[9]
		_expect_equal(boot.probes.get("run_id"), "perception_learned_new_run_autonomy_run", "bootstrap checkpoint keeps production run identity")
		_expect_equal(int(boot.probes.get("seed", -1)), 61043, "bootstrap checkpoint keeps deterministic gameplay seed")
		_expect_true(bool(boot.probes.get("run_active", false)), "production new run begins ACTIVE")
		_expect_equal(int(boot.probes.get("belief_count", -1)), 0, "new run begins without pre-seeded opportunity belief")
		_expect_true(not bool(boot.probes.get("has_current_intention", true)), "new run begins without authoritative intention")
		_expect_true(bool(learned.probes.get("learned_target_relation", false)), "real passive perception becomes Wilson-owned belief")
		_expect_true(int(learned.probes.get("belief_count", 0)) > 0, "learning checkpoint exposes durable cognition state")
		_expect_true(int(pressing.probes.get("hunger_band", -1)) >= 1, "drive later crosses pressing urgency")
		_expect_true(String(selected.probes.get("current_intention", "")).contains("seek_food"), "drive-triggered reconsideration selects seek_food")
		_expect_true(String(selected.probes.get("current_target", "")).contains("visible_food_patch"), "selected intention targets perceived relation object")
		_expect_true(int(moving.probes.get("motion_status", -1)) == 1, "selected intention produces MOVING status")
		_expect_true(int(arrived.probes.get("semantic_step", -1)) > int(learned.probes.get("semantic_step", -1)), "arrival occurs after perception and semantic progression")
		var final_position: Array = Array(arrived.probes.get("position", []))
		_expect_true(final_position.size() == 3 and float(final_position[0]) > 5.0, "Wilson physically reaches the perceived food side of the scene")
		_expect_true(bool(action_started.probes.get("consume_started", false)), "arrival starts authored consume ActionExecution")
		_expect_true(not bool(action_started.probes.get("consume_committed", true)), "consume begins before its irreversible checkpoint")
		_expect_true(bool(action_committed.probes.get("consume_committed", false)), "consume crosses ActionExecution commit checkpoint")
		var hunger_at_start := float(action_started.probes.get("hunger_at_action_start", -1.0))
		var hunger_after := float(hunger_reduced.probes.get("hunger", 2.0))
		_expect_true(hunger_at_start >= 0.0, "action-start checkpoint captures pre-consumption hunger")
		_expect_true(hunger_after <= hunger_at_start - 0.30, "accepted consume outcome produces grounded hunger reduction")
		_expect_true(bool(hunger_reduced.probes.get("consume_committed", false)), "hunger reduction occurs only after consume commit")
		_expect_true(float(complete.probes.get("hunger", 2.0)) <= hunger_at_start - 0.30, "scenario completes with reduced authoritative hunger")

	assert(adapter != null)
	scene.queue_free()
	_finish()


func _finish() -> void:
	if _failures.is_empty():
		print("PASS perception_learned_new_run_autonomy_scenario_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL perception_learned_new_run_autonomy_scenario_test: %d failure(s)" % _failures.size())
	quit(1)


func _expect_true(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _expect_equal(actual: Variant, expected: Variant, message: String) -> void:
	if actual != expected:
		_failures.append("%s (expected=%s actual=%s)" % [message, expected, actual])