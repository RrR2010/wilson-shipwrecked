class_name MotionPort
extends RefCounted

## Abstract movement execution boundary.
##
## The simulation requests/cancels semantic movement. Implementations own fine-grained
## engine progression and expose only semantic progress/outcomes back to simulation.

enum MotionStatus {
	IDLE,
	MOVING,
	ARRIVED,
	BLOCKED,
	ROUTE_INVALID,
	CANCELLED,
}

func request_move(_actor_ref: StringName, _target_ref: StringName) -> bool:
	push_error("MotionPort.request_move() is abstract")
	return false

func cancel_move(_actor_ref: StringName) -> void:
	push_error("MotionPort.cancel_move() is abstract")

func get_status(_actor_ref: StringName) -> MotionStatus:
	push_error("MotionPort.get_status() is abstract")
	return MotionStatus.IDLE
