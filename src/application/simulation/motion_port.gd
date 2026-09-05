class_name MotionPort
extends RefCounted

const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")

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

func request_move(_actor_ref: RuntimeWorldRef, _target_ref: RuntimeWorldRef) -> bool:
	push_error("MotionPort.request_move() is abstract")
	return false

func cancel_move(_actor_ref: RuntimeWorldRef) -> void:
	push_error("MotionPort.cancel_move() is abstract")

func get_status(_actor_ref: RuntimeWorldRef) -> int:
	push_error("MotionPort.get_status() is abstract")
	return MotionStatus.IDLE

func get_target(_actor_ref: RuntimeWorldRef) -> RuntimeWorldRef:
	push_error("MotionPort.get_target() is abstract")
	return null
