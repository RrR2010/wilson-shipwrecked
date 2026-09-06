class_name TargetedActionExecutionCoordinator
extends RefCounted

const MotionPort = preload("res://src/application/simulation/motion_port.gd")

## Reifies a committed target-bearing intention as a two-stage execution:
## semantic motion first, then an authored ActionExecution after arrival.
##
## Cognition owns the intention, MotionPort owns fine movement and
## ActionExecutionService owns action progress/commit. This coordinator owns no
## durable gameplay truth; execution identity is derived deterministically from
## the committed intention selection step and authored action id.

var _motion
var _action_execution
var _actor_ref
var _intention_id
var _action_definition
var _resolution_definition
var _target_role: StringName
var _actor_role: StringName


func _init(
	motion,
	action_execution,
	actor_ref,
	intention_id,
	action_definition,
	resolution_definition,
	target_role: StringName = &"target",
	actor_role: StringName = &"actor"
) -> void:
	assert(motion != null, "TargetedActionExecutionCoordinator requires MotionPort")
	assert(action_execution != null, "TargetedActionExecutionCoordinator requires ActionExecutionService")
	assert(actor_ref != null, "TargetedActionExecutionCoordinator requires actor RuntimeWorldRef")
	assert(intention_id != null, "TargetedActionExecutionCoordinator requires intention id")
	assert(action_definition != null, "TargetedActionExecutionCoordinator requires ActionDefinition")
	assert(resolution_definition != null, "TargetedActionExecutionCoordinator requires ActionResolutionDefinition")
	assert(action_definition.id.equals(resolution_definition.action_id), "Action resolution must belong to authored action")
	assert(target_role != &"", "target role cannot be empty")
	assert(actor_role != &"", "actor role cannot be empty")
	_motion = motion
	_action_execution = action_execution
	_actor_ref = actor_ref
	_intention_id = intention_id
	_action_definition = action_definition
	_resolution_definition = resolution_definition
	_target_role = target_role
	_actor_role = actor_role


func apply(intention_state) -> Dictionary:
	var admission = _admit(intention_state)
	if not admission.handled or not admission.valid:
		return admission.result

	var execution_id: StringName = _execution_id(intention_state)
	if _action_execution.get_state(execution_id) != null:
		return _result(true, false, execution_id, admission.target_ref, &"action_already_started")

	var status: int = _motion.get_status(_actor_ref)
	var motion_target = _motion.get_target(_actor_ref)
	if status == MotionPort.MotionStatus.ARRIVED and _same_ref(motion_target, admission.target_ref):
		return _start_action(intention_state, admission.target_ref)
	if status == MotionPort.MotionStatus.MOVING and _same_ref(motion_target, admission.target_ref):
		return _result(true, false, &"", admission.target_ref, &"already_moving")
	if status == MotionPort.MotionStatus.MOVING:
		_motion.cancel_move(_actor_ref)
	if not _motion.request_move(_actor_ref, admission.target_ref):
		return _result(true, false, &"", admission.target_ref, &"move_rejected")
	return _result(true, false, &"", admission.target_ref, &"move_requested")


func advance(intention_state) -> Dictionary:
	var admission = _admit(intention_state)
	if not admission.handled or not admission.valid:
		return admission.result

	var execution_id: StringName = _execution_id(intention_state)
	if _action_execution.get_state(execution_id) != null:
		return _result(true, false, execution_id, admission.target_ref, &"action_already_started")

	var status: int = _motion.get_status(_actor_ref)
	var motion_target = _motion.get_target(_actor_ref)
	if status != MotionPort.MotionStatus.ARRIVED:
		return _result(true, false, &"", admission.target_ref, &"awaiting_arrival")
	if not _same_ref(motion_target, admission.target_ref):
		return _result(true, false, &"", admission.target_ref, &"arrival_target_mismatch")
	return _start_action(intention_state, admission.target_ref)


func _start_action(intention_state, target_ref) -> Dictionary:
	var execution_id: StringName = _execution_id(intention_state)
	var bindings = intention_state.bindings.duplicate_binding()
	if not bindings.has(_actor_role):
		bindings.bind(_actor_role, _actor_ref)
	var state = _action_execution.start(
		execution_id,
		_action_definition,
		_resolution_definition,
		bindings
	)
	if state == null:
		return _result(true, false, execution_id, target_ref, &"action_start_rejected")
	return _result(true, true, execution_id, target_ref, &"action_started")


func _admit(intention_state) -> Dictionary:
	if intention_state == null or intention_state.intention_id == null:
		return {
			"handled": false,
			"valid": false,
			"target_ref": null,
			"result": _result(false, false, &"", null, &"no_intention"),
		}
	if not intention_state.intention_id.equals(_intention_id):
		return {
			"handled": false,
			"valid": false,
			"target_ref": null,
			"result": _result(false, false, &"", null, &"not_handled"),
		}
	if intention_state.bindings == null or not intention_state.bindings.has(_target_role):
		return {
			"handled": true,
			"valid": false,
			"target_ref": null,
			"result": _result(true, false, &"", null, &"missing_target"),
		}
	return {
		"handled": true,
		"valid": true,
		"target_ref": intention_state.bindings.get_subject(_target_role),
		"result": {},
	}


func _execution_id(intention_state) -> StringName:
	return StringName("intention_%s_action_%s" % [
		String(intention_state.selected_step_id),
		String(_action_definition.id.value),
	])


func _same_ref(first, second) -> bool:
	return first != null and second != null and first.equals(second)


func _result(
	handled: bool,
	started: bool,
	execution_id: StringName,
	target_ref,
	reason: StringName
) -> Dictionary:
	return {
		"handled": handled,
		"started": started,
		"execution_id": execution_id,
		"target_ref": target_ref,
		"reason": reason,
	}
