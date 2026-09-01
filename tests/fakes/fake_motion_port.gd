class_name FakeMotionPort
extends MotionPort

var _status_by_actor: Dictionary = {}
var _target_by_actor: Dictionary = {}

func request_move(actor_ref: StringName, target_ref: StringName) -> bool:
	_target_by_actor[actor_ref] = target_ref
	_status_by_actor[actor_ref] = MotionStatus.MOVING
	return true

func cancel_move(actor_ref: StringName) -> void:
	if _status_by_actor.has(actor_ref):
		_status_by_actor[actor_ref] = MotionStatus.CANCELLED

func get_status(actor_ref: StringName) -> MotionStatus:
	return int(_status_by_actor.get(actor_ref, MotionStatus.IDLE)) as MotionStatus

func set_status(actor_ref: StringName, status: MotionStatus) -> void:
	_status_by_actor[actor_ref] = status

func get_target(actor_ref: StringName) -> StringName:
	return _target_by_actor.get(actor_ref, &"") as StringName
