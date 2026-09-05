class_name EngineScenarioBoundedWait
extends RefCounted

enum Status {
	WAITING,
	SATISFIED,
	TIMED_OUT,
}

var id: StringName
var timeout_seconds: float
var elapsed_seconds := 0.0
var status := Status.WAITING


func _init(p_id: StringName, p_timeout_seconds: float) -> void:
	assert(p_id != &"", "EngineScenarioBoundedWait requires id")
	assert(p_timeout_seconds > 0.0, "EngineScenarioBoundedWait timeout must be > 0")
	id = p_id
	timeout_seconds = p_timeout_seconds


func advance(delta_seconds: float, condition_met: bool) -> int:
	assert(delta_seconds >= 0.0, "Bounded wait delta must be >= 0")
	if status != Status.WAITING:
		return status
	if condition_met:
		status = Status.SATISFIED
		return status
	elapsed_seconds += delta_seconds
	if elapsed_seconds >= timeout_seconds:
		status = Status.TIMED_OUT
	return status


func describe() -> Dictionary:
	return {
		"id": String(id),
		"timeout_seconds": timeout_seconds,
		"elapsed_seconds": elapsed_seconds,
		"status": status,
	}
