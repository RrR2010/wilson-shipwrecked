class_name GodotReconsiderationTriggerBuffer
extends RefCounted

const ReconsiderationGate = preload("res://src/application/simulation/reconsideration_gate.gd")

## Collects semantic reconsideration triggers produced between semantic boundaries.
## Duplicate engine callbacks collapse before cognition sees the trigger set.

var _gate = ReconsiderationGate.new()
var _pending: Array[int] = []


func enqueue(trigger: int) -> bool:
	if trigger < ReconsiderationGate.Trigger.THREAT or trigger > ReconsiderationGate.Trigger.PERIODIC_REVIEW:
		return false
	_pending.append(trigger)
	return true


func drain() -> Array[int]:
	var result: Array[int] = _gate.coalesce(_pending)
	_pending.clear()
	return result


func pending_count() -> int:
	return _pending.size()
