extends SceneTree

const FIXTURE_PATH := "res://tests/scenes/physical_accident/physical_accident.tscn"
const EngineScenarioHarness = preload("res://tests/support/engine_scenario/engine_scenario_harness.gd")
const EngineScenarioSceneAdapter = preload("res://tests/support/engine_scenario/engine_scenario_scene_adapter.gd")

var _failures: Array[String] = []


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var packed: PackedScene = load(FIXTURE_PATH)
	_expect_true(packed != null, "physical accident fixture loads")
	if packed == null:
		_finish()
		return

	var scene = packed.instantiate()
	var harness = EngineScenarioHarness.new(EngineScenarioHarness.Mode.AUTOMATED)
	var adapter = EngineScenarioSceneAdapter.new()
	adapter.configure(scene, harness)
	root.add_child(scene)

	for _frame in range(360):
		if harness.completed() or harness.failed():
			break
		await process_frame

	_expect_true(not harness.failed(), "physical accident scenario does not fail")
	if harness.failed():
		_failures.append("scenario failure: %s %s" % [String(harness.failure_code()), str(harness.failure_diagnostics())])
	_expect_true(harness.completed(), "physical accident scenario completes within bounded frames")

	var checkpoints = harness.checkpoints()
	var names: Array[StringName] = []
	for checkpoint in checkpoints:
		names.append(checkpoint.name)
	_expect_equal(
		names,
		[&"BOOTSTRAPPED", &"CONTACT_OBSERVED", &"EVENT_ADMITTED", &"BODY_DAMAGED", &"COMPLETE"],
		"scenario exposes engine-contact-to-grounded-body-consequence sequence"
	)

	if checkpoints.size() >= 5:
		var contact = checkpoints[1]
		var admitted = checkpoints[2]
		var damaged = checkpoints[3]
		_expect_true(float(contact.probes.get("contact_magnitude", 0.0)) > 0.0, "real Godot fall produces positive observed contact magnitude")
		_expect_equal(int(admitted.probes.get("semantic_event_count", 0)), 1, "authored contact admission produces one semantic event")
		_expect_equal(int(damaged.probes.get("body_event_count", 0)), 1, "authored body consequence produces one injury event")
		_expect_true(is_equal_approx(float(damaged.probes.get("vitality", -1.0)), 0.75), "Wilson vitality changes only after grounded body resolution")

	assert(adapter != null)
	scene.queue_free()
	_finish()


func _finish() -> void:
	if _failures.is_empty():
		print("PASS physical_accident_scenario_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL physical_accident_scenario_test: %d failure(s)" % _failures.size())
	quit(1)


func _expect_true(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _expect_equal(actual: Variant, expected: Variant, message: String) -> void:
	if actual != expected:
		_failures.append("%s (expected=%s actual=%s)" % [message, expected, actual])
