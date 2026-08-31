class_name DriveProgressionService
extends RefCounted

## Owner-local drive progression policy. Keeps time-based motivational updates
## outside application orchestration while mutating only the DriveState owner.

var _drive_state
var _rates_per_second: Dictionary


func _init(drive_state, rates_per_second: Dictionary) -> void:
	assert(drive_state != null, "DriveProgressionService requires DriveState")
	_drive_state = drive_state
	_rates_per_second = rates_per_second.duplicate(true)


func advance(elapsed: float):
	return _drive_state.advance(elapsed, _rates_per_second)


func drive_state():
	return _drive_state
