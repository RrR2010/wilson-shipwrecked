extends SceneTree

const FIXTURE_PATH := "res://tests/scenes/shallow_actor_physical_locomotion/shallow_actor_physical_locomotion.tscn"
const EngineScenarioHarness = preload("res://tests/support/engine_scenario/engine_scenario_harness.gd")
const EngineScenarioSceneAdapter = preload("res://tests/support/engine_scenario/engine_scenario_scene_adapter.gd")
const MotionPort = preload("res://src/application/simulation/motion_port.gd")

var _failures: Array[String] = []


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var packed: PackedScene = load(FIXTURE_PATH)
	_expect_true(packed != null, "Shallow actor physical locomotion fixture loads")
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

	_expect_true(not harness.failed(), "Shallow actor physical locomotion scenario does not fail")
	if harness.failed():
		_failures.append("scenario failure: %s %s" % [String(harness.failure_code()), str(harness.failure_diagnostics())])
	_expect_true(harness.completed(), "Shallow actor physical locomotion scenario completes within bounded frames")

	var checkpoints = harness.checkpoints()
	var names: Array[StringName] = []
	for checkpoint in checkpoints:
		names.append(checkpoint.name)
	_expect_equal(
		names,
		[&"BOOTSTRAPPED", &"MOVE_REQUESTED", &"PHYSICAL_TRANSIT", &"SEMANTIC_ARRIVAL_COMMITTED", &"COMPLETE"],
		"scenario exposes decision-to-physical-transit-to-semantic-arrival sequence"
	)

	if checkpoints.size() >= 5:
		var boot = checkpoints[0]
		var requested = checkpoints[1]
		var transit = checkpoints[2]
		var committed = checkpoints[3]
		_expect_equal(boot.probes.get("scenario"), "shallow_actor_physical_locomotion", "bootstrap checkpoint keeps scenario identity")
		_expect_true(float(boot.probes.get("affinity", 0.0)) >= 0.40, "Gerald begins friendly enough to approach Wilson")
		_expect_true(String(requested.probes.get("gerald_place", "")).ends_with("gerald_camp"), "movement request does not teleport semantic place")
		_expect_equal(int(requested.probes.get("motion_status", -1)), MotionPort.MotionStatus.MOVING, "movement request enters MOVING state")
		_expect_true(bool(requested.probes.get("pending_motion", false)), "movement request is pending before arrival")

		var boot_position: Array = Array(boot.probes.get("gerald_position", []))
		var transit_position: Array = Array(transit.probes.get("gerald_position", []))
		if boot_position.size() == 3 and transit_position.size() == 3:
			var dx := float(transit_position[0]) - float(boot_position[0])
			var dz := float(transit_position[2]) - float(boot_position[2])
			_expect_true(Vector2(dx, dz).length() > 0.75, "Gerald visibly moves through Godot before semantic arrival")
		else:
			_failures.append("Gerald position probes must contain three coordinates")
		_expect_true(String(transit.probes.get("gerald_place", "")).ends_with("gerald_camp"), "semantic place remains camp during physical transit")
		_expect_equal(int(transit.probes.get("motion_status", -1)), MotionPort.MotionStatus.MOVING, "physical transit remains MOVING")

		_expect_true(String(committed.probes.get("gerald_place", "")).ends_with("near_wilson"), "ARRIVED commits Gerald near Wilson")
		_expect_equal(int(committed.probes.get("motion_status", -1)), MotionPort.MotionStatus.ARRIVED, "semantic commit follows ARRIVED status")
		_expect_true(not bool(committed.probes.get("pending_motion", true)), "arrival clears pending movement")
		var final_position: Array = Array(committed.probes.get("gerald_position", []))
		_expect_true(final_position.size() == 3 and float(final_position[0]) > 3.5, "Gerald physically reaches Wilson side of the scene")

	assert(adapter != null)
	scene.queue_free()
	_finish()


func _finish() -> void:
	if _failures.is_empty():
		print("PASS shallow_actor_physical_locomotion_scenario_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL shallow_actor_physical_locomotion_scenario_test: %d failure(s)" % _failures.size())
	quit(1)


func _expect_true(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _expect_equal(actual: Variant, expected: Variant, message: String) -> void:
	if actual != expected:
		_failures.append("%s (expected=%s actual=%s)" % [message, expected, actual])
