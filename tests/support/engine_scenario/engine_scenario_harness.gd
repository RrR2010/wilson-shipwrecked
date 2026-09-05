class_name EngineScenarioHarness
extends RefCounted

const EngineScenarioCheckpoint = preload("res://tests/support/engine_scenario/engine_scenario_checkpoint.gd")
const EngineScenarioBoundedWait = preload("res://tests/support/engine_scenario/engine_scenario_bounded_wait.gd")

enum Mode {
	AUTOMATED,
	ASSISTED,
}

var mode: int
var emit_jsonl: bool
var _checkpoints: Array = []
var _records: Array[Dictionary] = []
var _waiting_for_continue := false
var _failed := false
var _completed := false
var _failure_code: StringName = &""
var _failure_diagnostics: Array[String] = []


func _init(p_mode: int = Mode.AUTOMATED, p_emit_jsonl: bool = false) -> void:
	assert(p_mode == Mode.AUTOMATED or p_mode == Mode.ASSISTED, "Invalid EngineScenarioHarness mode")
	mode = p_mode
	emit_jsonl = p_emit_jsonl


func checkpoint(
	name: StringName,
	probes: Dictionary = {},
	instruction: String = "",
	simulation_time: float = -1.0,
	semantic_step: int = -1,
	physics_frame: int = -1
) -> EngineScenarioCheckpoint:
	assert(not _completed, "Cannot emit checkpoint after completion")
	assert(not _failed, "Cannot emit checkpoint after failure")
	assert(not _waiting_for_continue, "Assisted scenario must continue before emitting another checkpoint")
	var checkpoint_record = EngineScenarioCheckpoint.new(
		name,
		instruction,
		simulation_time,
		semantic_step,
		physics_frame,
		probes
	)
	_checkpoints.append(checkpoint_record)
	_record(checkpoint_record.describe())
	if mode == Mode.ASSISTED:
		_waiting_for_continue = true
	return checkpoint_record


func log(label: StringName, payload: Dictionary = {}) -> void:
	assert(label != &"", "Scenario log requires label")
	assert(not _completed and not _failed, "Cannot log after scenario termination")
	_record({
		"type": "log",
		"label": String(label),
		"payload": payload.duplicate(true),
	})


func create_bounded_wait(wait_id: StringName, timeout_seconds: float) -> EngineScenarioBoundedWait:
	assert(not _completed and not _failed, "Cannot create bounded wait after scenario termination")
	return EngineScenarioBoundedWait.new(wait_id, timeout_seconds)


func observe_bounded_wait(wait: EngineScenarioBoundedWait, delta_seconds: float, condition_met: bool) -> int:
	assert(wait != null, "observe_bounded_wait requires wait")
	assert(not _completed and not _failed, "Cannot observe bounded wait after scenario termination")
	var previous_status: int = wait.status
	var status: int = wait.advance(delta_seconds, condition_met)
	if status != previous_status:
		_record({"type": "bounded_wait", "wait": wait.describe()})
	if status == EngineScenarioBoundedWait.Status.TIMED_OUT:
		fail(&"scenario_wait_timeout", [
			"Bounded wait %s timed out after %.3f s" % [String(wait.id), wait.elapsed_seconds]
		])
	return status


func waiting_for_continue() -> bool:
	return _waiting_for_continue


func continue_from_checkpoint() -> bool:
	if not _waiting_for_continue:
		return false
	_waiting_for_continue = false
	_record({"type": "continue"})
	return true


func complete(probes: Dictionary = {}) -> void:
	assert(not _failed, "Failed scenario cannot complete")
	assert(not _waiting_for_continue, "Assisted scenario must continue before completion")
	assert(not _completed, "Scenario already completed")
	_completed = true
	_record({"type": "complete", "probes": probes.duplicate(true)})


func fail(code: StringName, diagnostics: Array[String] = []) -> void:
	assert(code != &"", "Scenario failure requires code")
	assert(not _completed, "Completed scenario cannot fail")
	assert(not _failed, "Scenario already failed")
	_failed = true
	_waiting_for_continue = false
	_failure_code = code
	_failure_diagnostics = diagnostics.duplicate()
	_record({
		"type": "failure",
		"code": String(code),
		"diagnostics": _failure_diagnostics.duplicate(),
	})


func completed() -> bool:
	return _completed


func failed() -> bool:
	return _failed


func failure_code() -> StringName:
	return _failure_code


func failure_diagnostics() -> Array[String]:
	return _failure_diagnostics.duplicate()


func checkpoints() -> Array:
	return _checkpoints.duplicate()


func trace() -> Array[Dictionary]:
	return _records.duplicate(true)


func _record(record: Dictionary) -> void:
	var snapshot: Dictionary = record.duplicate(true)
	_records.append(snapshot)
	if emit_jsonl:
		print(JSON.stringify(snapshot))
