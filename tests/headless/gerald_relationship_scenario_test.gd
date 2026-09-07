extends SceneTree

const FIXTURE_PATH := "res://tests/scenes/gerald_relationship/gerald_relationship.tscn"
const EngineScenarioHarness = preload("res://tests/support/engine_scenario/engine_scenario_harness.gd")
const EngineScenarioSceneAdapter = preload("res://tests/support/engine_scenario/engine_scenario_scene_adapter.gd")

var _failures: Array[String] = []


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var packed: PackedScene = load(FIXTURE_PATH)
	_expect_true(packed != null, "Gerald relationship fixture loads")
	if packed == null:
		_finish()
		return

	var scene = packed.instantiate()
	var harness = EngineScenarioHarness.new(EngineScenarioHarness.Mode.AUTOMATED)
	var adapter = EngineScenarioSceneAdapter.new()
	adapter.configure(scene, harness)
	root.add_child(scene)

	for _frame in range(300):
		if harness.completed() or harness.failed():
			break
		await process_frame

	_expect_true(not harness.failed(), "Gerald relationship scenario does not fail")
	if harness.failed():
		_failures.append("scenario failure: %s %s" % [String(harness.failure_code()), str(harness.failure_diagnostics())])
	_expect_true(harness.completed(), "Gerald relationship scenario completes within bounded frames")

	var checkpoints = harness.checkpoints()
	var names: Array[StringName] = []
	for checkpoint in checkpoints:
		names.append(checkpoint.name)
	_expect_equal(
		names,
		[&"BOOTSTRAPPED", &"NEUTRAL_WATCH", &"RELATIONSHIP_WARMED", &"APPROACHED_WILSON", &"COMPLETE"],
		"scenario exposes relationship-to-visible-behavior sequence"
	)

	if checkpoints.size() >= 5:
		var boot = checkpoints[0]
		var neutral = checkpoints[1]
		var warmed = checkpoints[2]
		var approached = checkpoints[3]
		_expect_equal(boot.probes.get("scenario"), "gerald_relationship", "bootstrap keeps scenario identity")
		_expect_true(is_zero_approx(float(boot.probes.get("affinity", 99.0))), "Gerald starts relationship-neutral")
		_expect_equal(neutral.probes.get("gerald_place"), "Place:gerald_camp", "neutral Gerald stays at ordinary camp")
		_expect_true(float(warmed.probes.get("affinity", 0.0)) >= 0.40, "helpful interactions produce friendly Gerald affinity")
		_expect_true(int(warmed.probes.get("evidence_count", 0)) == 3, "relationship records repeated evidence")
		_expect_equal(approached.probes.get("gerald_place"), "Place:near_wilson", "friendly Gerald chooses semantic place near Wilson")
		var neutral_position: Array = Array(neutral.probes.get("gerald_position", []))
		var approached_position: Array = Array(approached.probes.get("gerald_position", []))
		_expect_true(neutral_position.size() == 3 and approached_position.size() == 3 and float(approached_position[0]) - float(neutral_position[0]) > 3.0, "presentation visibly reflects Gerald approaching Wilson")

	assert(adapter != null)
	scene.queue_free()
	_finish()


func _finish() -> void:
	if _failures.is_empty():
		print("PASS gerald_relationship_scenario_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL gerald_relationship_scenario_test: %d failure(s)" % _failures.size())
	quit(1)


func _expect_true(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _expect_equal(actual: Variant, expected: Variant, message: String) -> void:
	if actual != expected:
		_failures.append("%s (expected=%s actual=%s)" % [message, expected, actual])
