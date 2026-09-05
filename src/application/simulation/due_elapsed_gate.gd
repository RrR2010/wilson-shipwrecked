class_name DueElapsedGate
extends RefCounted

## Conserves semantic elapsed time while allowing a gradual owner to run only when
## its shared SemanticDueScheduler key is due.
##
## The scheduler owns deadlines. This gate owns only accumulated elapsed time for
## one owner; it is not an independent clock.

var _scheduler
var _key: StringName
var _pending_elapsed: float = 0.0


func _init(scheduler, key: StringName) -> void:
	assert(scheduler != null, "DueElapsedGate requires SemanticDueScheduler")
	assert(key != &"", "DueElapsedGate requires a non-empty key")
	assert(scheduler.is_registered(key), "DueElapsedGate key must be registered before gate construction")
	_scheduler = scheduler
	_key = key


func elapsed_for_step(elapsed: float, simulation_time: float) -> float:
	assert(is_finite(elapsed) and elapsed >= 0.0, "elapsed must be finite and non-negative")
	assert(is_finite(simulation_time), "simulation_time must be finite")
	_pending_elapsed += elapsed
	if not _scheduler.consume_if_due(_key, simulation_time):
		return 0.0
	var due_elapsed: float = _pending_elapsed
	_pending_elapsed = 0.0
	return due_elapsed


func pending_elapsed() -> float:
	return _pending_elapsed


func key() -> StringName:
	return _key
