class_name EngineScenarioHarness
extends RefCounted

const EngineScenarioCheckpoint = preload("res://tests/support/engine_scenario/engine_scenario_checkpoint.gd")

enum Mode {
	AUTOMATED,
	ASSISTED,
}

var mode: int
var emit_jsonl: bool
var _checkpoints: Array = []
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
	var record = EngineScenarioCheckpoint.new(
		name,
		instruction,
		simulation_time,
		semantic_step,
		physics_frame,
		probes
	)
	_checkpoints.append(record)
	_emit(record.describe())
	if mode == Mode.ASSISTED:
		_waiting_for_continue = true
	return record


func waiting_for_continue() -> bool:
	return _waiting_for_continue


func continue_from_checkpoint() -> bool:
	if not _waiting_for_continue:
		return false
	_waiting_for_continue = false
	return true


func complete(probes: Dictionary = {}) -> void:
	assert(not _failed, "Failed scenario cannot complete")
	assert(not _waiting_for_continue, "Assisted scenario must continue before completion")
	assert(not _completed, "Scenario already completed")
	_completed = true
	_emit({"type": "complete", "probes": probes.duplicate(true)})


func fail(code: StringName, diagnostics: Array[String] = []) -> void:
	assert(code != &"", "Scenario failure requires code")
	assert(not _completed, "Completed scenario cannot fail")
	assert(not _failed, "Scenario already failed")
	_failed = true
	_waiting_for_continue = false
	_failure_code = code
	_failure_diagnostics = diagnostics.duplicate()
	_emit({
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
	var result: Array[Dictionary] = []
	for checkpoint_record in _checkpoints:
		result.append(checkpoint_record.describe())
	return result


func _emit(record: Dictionary) -> void:
	if emit_jsonl:
		print(JSON.stringify(record))
