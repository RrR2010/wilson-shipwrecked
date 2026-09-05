extends SceneTree

const EngineScenarioHarness = preload("res://tests/support/engine_scenario/engine_scenario_harness.gd")
const EngineScenarioBoundedWait = preload("res://tests/support/engine_scenario/engine_scenario_bounded_wait.gd")

var _failures: Array[String] = []
var _completed := false


func _init() -> void:
	_run_tests()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS engine_scenario_harness_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL engine_scenario_harness_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_tests() -> void:
	_test_automated_mode_records_semantic_trace_without_pausing()
	_test_assisted_mode_waits_for_explicit_continue()
	_test_bounded_wait_satisfies_and_times_out_deterministically()
	_completed = true


func _test_automated_mode_records_semantic_trace_without_pausing() -> void:
	var harness = EngineScenarioHarness.new(EngineScenarioHarness.Mode.AUTOMATED)
	var checkpoint_record = harness.checkpoint(
		&"SCENE_READY",
		{"actor": "Wilson", "position": [0.0, 0.0, 0.0]},
		"",
		1.25,
		7,
		42
	)
	_expect_false(harness.waiting_for_continue(), "automated checkpoint does not pause")
	_expect_equal(checkpoint_record.name, &"SCENE_READY", "checkpoint keeps semantic name")
	_expect_equal(checkpoint_record.simulation_time, 1.25, "checkpoint keeps authoritative simulation time")
	_expect_equal(checkpoint_record.semantic_step, 7, "checkpoint keeps semantic step")
	_expect_equal(checkpoint_record.physics_frame, 42, "checkpoint keeps diagnostic physics frame")
	_expect_equal(checkpoint_record.probes.get("actor"), "Wilson", "checkpoint preserves opaque probe payload")

	harness.log(&"route_probe", {"available": true, "cost": 3.5})
	harness.complete({"reason": "scenario_assertions_passed"})
	_expect_true(harness.completed(), "automated scenario can complete")
	_expect_false(harness.failed(), "completed automated scenario is not failed")
	var trace = harness.trace()
	_expect_equal(trace.size(), 3, "trace contains checkpoint, log and completion")
	_expect_equal(trace[0].get("type"), "checkpoint", "first trace record is checkpoint")
	_expect_equal(trace[1].get("type"), "log", "second trace record is structured log")
	_expect_equal(trace[2].get("type"), "complete", "last trace record is completion")


func _test_assisted_mode_waits_for_explicit_continue() -> void:
	var harness = EngineScenarioHarness.new(EngineScenarioHarness.Mode.ASSISTED)
	harness.checkpoint(
		&"MOVE_REQUESTED",
		{"target": "camp_anchor"},
		"Inspect Wilson and press Space to continue"
	)
	_expect_true(harness.waiting_for_continue(), "assisted checkpoint waits for operator continue")
	_expect_true(harness.continue_from_checkpoint(), "explicit continue releases assisted checkpoint")
	_expect_false(harness.waiting_for_continue(), "assisted harness resumes after continue")
	_expect_false(harness.continue_from_checkpoint(), "continue is ignored when no checkpoint is waiting")
	harness.complete()
	var trace = harness.trace()
	_expect_equal(trace.size(), 3, "assisted trace includes checkpoint, continue and completion")
	_expect_equal(trace[1].get("type"), "continue", "assisted continuation is traceable")


func _test_bounded_wait_satisfies_and_times_out_deterministically() -> void:
	var harness = EngineScenarioHarness.new(EngineScenarioHarness.Mode.AUTOMATED)
	var satisfied = harness.create_bounded_wait(&"navigation_ready", 1.0)
	_expect_equal(
		harness.observe_bounded_wait(satisfied, 0.4, false),
		EngineScenarioBoundedWait.Status.WAITING,
		"bounded wait remains waiting below timeout"
	)
	_expect_equal(
		harness.observe_bounded_wait(satisfied, 0.2, true),
		EngineScenarioBoundedWait.Status.SATISFIED,
		"bounded wait satisfies when condition becomes true"
	)
	_expect_false(harness.failed(), "satisfied bounded wait does not fail scenario")

	var timeout_harness = EngineScenarioHarness.new(EngineScenarioHarness.Mode.AUTOMATED)
	var timed_out = timeout_harness.create_bounded_wait(&"perception_evidence", 0.5)
	_expect_equal(
		timeout_harness.observe_bounded_wait(timed_out, 0.2, false),
		EngineScenarioBoundedWait.Status.WAITING,
		"timeout wait starts waiting"
	)
	_expect_equal(
		timeout_harness.observe_bounded_wait(timed_out, 0.3, false),
		EngineScenarioBoundedWait.Status.TIMED_OUT,
		"bounded wait times out at deterministic elapsed threshold"
	)
	_expect_true(timeout_harness.failed(), "timeout fails scenario")
	_expect_equal(timeout_harness.failure_code(), &"scenario_wait_timeout", "timeout uses stable failure code")
	_expect_true(not timeout_harness.failure_diagnostics().is_empty(), "timeout exposes bounded diagnostic")


func _expect_true(actual: bool, label: String) -> void:
	if not actual:
		_failures.append("Expected true: %s" % label)


func _expect_false(actual: bool, label: String) -> void:
	if actual:
		_failures.append("Expected false: %s" % label)


func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
