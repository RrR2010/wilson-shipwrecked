class_name DirectTargetMotionExecutionCoordinator
extends RefCounted

const MotionPort = preload("res://src/application/simulation/motion_port.gd")

## Reifies an already-committed intention whose binding names a concrete motion
## target. Cognition remains authoritative for intention selection; this
## coordinator only translates the selected semantic target into MotionPort.

var _motion
var _actor_ref
var _target_role: StringName
var _handled_intention_keys: Dictionary = {}


func _init(
	motion,
	actor_ref,
	handled_intention_ids: Array,
	target_role: StringName = &"target"
) -> void:
	assert(motion != null, "DirectTargetMotionExecutionCoordinator requires MotionPort")
	assert(actor_ref != null, "DirectTargetMotionExecutionCoordinator requires actor RuntimeWorldRef")
	assert(target_role != &"", "target role cannot be empty")
	_motion = motion
	_actor_ref = actor_ref
	_target_role = target_role
	for intention_id in handled_intention_ids:
		assert(intention_id != null, "handled intention ids cannot contain null")
		_handled_intention_keys[String(intention_id.sort_key())] = true


func apply(intention_state) -> Dictionary:
	var admission = _admit(intention_state)
	if not admission.handled or not admission.valid:
		return admission.result
	var target_ref = admission.target_ref
	var previous_status: int = _motion.get_status(_actor_ref)
	var previous_target = _motion.get_target(_actor_ref)
	if previous_status == MotionPort.MotionStatus.MOVING and _same_ref(previous_target, target_ref):
		return _result(true, true, target_ref, &"already_moving")
	if previous_status == MotionPort.MotionStatus.ARRIVED and _same_ref(previous_target, target_ref):
		return _result(true, false, target_ref, &"arrived")
	if previous_status == MotionPort.MotionStatus.MOVING:
		_motion.cancel_move(_actor_ref)
	if not _motion.request_move(_actor_ref, target_ref):
		return _result(true, false, target_ref, &"move_rejected")
	return _result(true, true, target_ref, &"move_requested")


func advance(intention_state) -> Dictionary:
	## Progression is observational only. A motion-only intention stays committed at
	## ARRIVED until cognition replaces/completes it; advance() must never restart
	## movement simply because the actor has reached the target.
	var admission = _admit(intention_state)
	if not admission.handled or not admission.valid:
		return admission.result
	var target_ref = admission.target_ref
	var status: int = _motion.get_status(_actor_ref)
	var current_target = _motion.get_target(_actor_ref)
	if not _same_ref(current_target, target_ref):
		return _result(true, false, target_ref, &"target_mismatch")
	if status == MotionPort.MotionStatus.MOVING:
		return _result(true, true, target_ref, &"moving")
	if status == MotionPort.MotionStatus.ARRIVED:
		return _result(true, false, target_ref, &"arrived")
	if status == MotionPort.MotionStatus.BLOCKED:
		return _result(true, false, target_ref, &"blocked")
	if status == MotionPort.MotionStatus.ROUTE_INVALID:
		return _result(true, false, target_ref, &"route_invalid")
	return _result(true, false, target_ref, &"idle")


func _admit(intention_state) -> Dictionary:
	if intention_state == null or intention_state.intention_id == null:
		return {
			"handled": false,
			"valid": false,
			"target_ref": null,
			"result": _result(false, false, null, &"no_intention"),
		}
	if not _handled_intention_keys.has(String(intention_state.intention_id.sort_key())):
		return {
			"handled": false,
			"valid": false,
			"target_ref": null,
			"result": _result(false, false, null, &"not_handled"),
		}
	if intention_state.bindings == null or not intention_state.bindings.has(_target_role):
		return {
			"handled": true,
			"valid": false,
			"target_ref": null,
			"result": _result(true, false, null, &"missing_target"),
		}
	return {
		"handled": true,
		"valid": true,
		"target_ref": intention_state.bindings.get_subject(_target_role),
		"result": {},
	}


func _same_ref(first, second) -> bool:
	return first != null and second != null and first.equals(second)


func _result(handled: bool, moving: bool, target_ref, reason: StringName) -> Dictionary:
	return {
		"handled": handled,
		"moving": moving,
		"target_ref": target_ref,
		"reason": reason,
	}
