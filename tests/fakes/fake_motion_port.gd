class_name FakeMotionPort
extends "res://src/application/simulation/motion_port.gd"

var _status_by_actor: Dictionary = {}
var _target_by_actor: Dictionary = {}
var request_history: Array = []
var cancel_history: Array = []

func request_move(actor_ref: RuntimeWorldRef, target_ref: RuntimeWorldRef) -> bool:
	_target_by_actor[actor_ref.key()] = target_ref
	_status_by_actor[actor_ref.key()] = MotionStatus.MOVING
	request_history.append({"actor": actor_ref, "target": target_ref})
	return true

func cancel_move(actor_ref: RuntimeWorldRef) -> void:
	var key: StringName = actor_ref.key()
	cancel_history.append(actor_ref)
	if _status_by_actor.has(key):
		_status_by_actor[key] = MotionStatus.CANCELLED

func get_status(actor_ref: RuntimeWorldRef) -> int:
	return int(_status_by_actor.get(actor_ref.key(), MotionStatus.IDLE))

func set_status(actor_ref: RuntimeWorldRef, status: int) -> void:
	_status_by_actor[actor_ref.key()] = status

func get_target(actor_ref: RuntimeWorldRef) -> RuntimeWorldRef:
	return _target_by_actor.get(actor_ref.key()) as RuntimeWorldRef
