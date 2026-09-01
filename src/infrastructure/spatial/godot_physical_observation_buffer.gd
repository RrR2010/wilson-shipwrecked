class_name GodotPhysicalObservationBuffer
extends PhysicalObservationPort

## Ordered bridge from fine-grained Godot physics callbacks to semantic simulation steps.
##
## Engine adapters enqueue typed facts as they occur. The simulation drains the batch at
## an explicit orchestration boundary; draining never applies gameplay consequences.

var _pending: Array[PhysicalObservation] = []

func enqueue(observation: PhysicalObservation) -> bool:
	if observation == null:
		return false
	_pending.append(observation)
	return true

func drain_observations() -> Array[PhysicalObservation]:
	var result: Array[PhysicalObservation] = _pending.duplicate()
	_pending.clear()
	return result

func pending_count() -> int:
	return _pending.size()

func clear() -> void:
	_pending.clear()
