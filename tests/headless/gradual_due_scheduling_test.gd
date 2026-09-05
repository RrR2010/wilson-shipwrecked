extends SceneTree

const DueElapsedGate = preload("res://src/application/simulation/due_elapsed_gate.gd")
const EnvironmentWorldAdvanceService = preload("res://src/application/simulation/environment_world_advance_service.gd")
const SemanticDueScheduler = preload("res://src/application/simulation/semantic_due_scheduler.gd")
const SemanticChangeSet = preload("res://src/domain/world/semantic_change_set.gd")
const SimulationStepContext = preload("res://src/application/simulation/simulation_step_context.gd")

var _failures: Array[String] = []
var _completed := false


class RecordingDynamicProcessAdvance:
	extends RefCounted
	var elapsed_calls: Array[float] = []

	func advance(elapsed: float) -> Dictionary:
		elapsed_calls.append(elapsed)
		return {
			"change_set": SemanticChangeSet.new(),
			"progressed": [],
			"completed": [],
			"diagnostics": [],
		}


func _init() -> void:
	_run_slice()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS gradual_due_scheduling_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL gradual_due_scheduling_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_slice() -> void:
	var scheduler = SemanticDueScheduler.new()
	scheduler.register(&"drives", 1.0, 0.0)
	scheduler.register(&"dynamic_processes", 2.0, 0.0)
	var drive_gate = DueElapsedGate.new(scheduler, &"drives")
	var process_gate = DueElapsedGate.new(scheduler, &"dynamic_processes")
	var process_advance = RecordingDynamicProcessAdvance.new()
	var world_advance = EnvironmentWorldAdvanceService.new(process_advance, null, null, process_gate)

	for index in range(19):
		var simulation_time: float = float(index + 1) * 0.1
		var drive_elapsed: float = drive_gate.elapsed_for_step(0.1, simulation_time)
		world_advance.advance(0.1, SimulationStepContext.new(
			StringName("gradual_%02d" % index), 0.1, simulation_time, null, []
		))
		if simulation_time < 1.0 - 1.0e-9:
			_expect_true(is_equal_approx(drive_elapsed, 0.0), "drive gate stays closed before its deadline")
		elif is_equal_approx(simulation_time, 1.0):
			_expect_true(is_equal_approx(drive_elapsed, 1.0), "drive key consumes only its accumulated first second")

	_expect_equal(_positive_elapsed_values(process_advance.elapsed_calls).size(), 0, "dynamic processes do not progress during nineteen 0.1 s heartbeats")
	_expect_true(is_equal_approx(scheduler.next_due_time(&"dynamic_processes"), 2.0), "consuming drive deadlines does not steal the process deadline")

	var drive_at_two: float = drive_gate.elapsed_for_step(0.1, 2.0)
	world_advance.advance(0.1, SimulationStepContext.new(&"gradual_due_20", 0.1, 2.0, null, []))
	_expect_true(is_equal_approx(drive_at_two, 1.0), "drive key remains independently due at two seconds")
	var positive_process_elapsed: Array[float] = _positive_elapsed_values(process_advance.elapsed_calls)
	_expect_equal(positive_process_elapsed.size(), 1, "process owner receives one positive progression invocation at its due boundary")
	if positive_process_elapsed.size() == 1:
		_expect_true(is_equal_approx(positive_process_elapsed[0], 2.0), "process due invocation conserves twenty skipped semantic-step deltas")
	_expect_true(is_equal_approx(scheduler.next_due_time(&"drives"), 3.0), "drive next deadline advances independently")
	_expect_true(is_equal_approx(scheduler.next_due_time(&"dynamic_processes"), 4.0), "process next deadline advances independently")

	var process_jump_elapsed: float = process_gate.elapsed_for_step(4.0, 6.0)
	_expect_true(is_equal_approx(process_jump_elapsed, 4.0), "missed process periods coalesce into one accumulated owner invocation")
	_expect_true(is_equal_approx(scheduler.next_due_time(&"dynamic_processes"), 8.0), "missed process deadlines advance deterministically beyond authoritative time")

	_completed = true


func _positive_elapsed_values(values: Array[float]) -> Array[float]:
	var result: Array[float] = []
	for value in values:
		if value > 0.0:
			result.append(value)
	return result


func _expect_true(actual: bool, label: String) -> void:
	if not actual:
		_failures.append("Expected true: %s" % label)


func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
