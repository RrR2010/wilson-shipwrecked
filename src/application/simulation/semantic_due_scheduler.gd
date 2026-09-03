class_name SemanticDueScheduler
extends RefCounted

## Shared due-work scheduler driven by one authoritative simulation time.
##
## This is not a collection of subsystem clocks. Callers register named work with
## a cadence, then ask which work is due at a given authoritative simulation time.

var _interval_by_key: Dictionary = {}
var _next_due_by_key: Dictionary = {}


func register(key: StringName, interval_seconds: float, start_time: float = 0.0) -> void:
	assert(key != &"", "SemanticDueScheduler requires a non-empty key")
	assert(is_finite(interval_seconds) and interval_seconds > 0.0, "interval must be finite and positive")
	assert(is_finite(start_time), "start_time must be finite")
	_interval_by_key[key] = interval_seconds
	_next_due_by_key[key] = start_time + interval_seconds


func unregister(key: StringName) -> void:
	_interval_by_key.erase(key)
	_next_due_by_key.erase(key)


func is_registered(key: StringName) -> bool:
	return _interval_by_key.has(key)


func collect_due(simulation_time: float) -> Array[StringName]:
	assert(is_finite(simulation_time), "simulation_time must be finite")
	var due: Array[StringName] = []
	var keys: Array = _interval_by_key.keys()
	keys.sort_custom(func(a, b): return String(a) < String(b))
	for raw_key in keys:
		var key := StringName(raw_key)
		var next_due: float = _next_due_by_key[key]
		if simulation_time + 1.0e-9 < next_due:
			continue
		due.append(key)
		var interval: float = _interval_by_key[key]
		var periods := int(floor(((simulation_time - next_due) + 1.0e-9) / interval)) + 1
		_next_due_by_key[key] = next_due + float(periods) * interval
	return due


func next_due_time(key: StringName) -> float:
	if not _next_due_by_key.has(key):
		return INF
	return _next_due_by_key[key]
