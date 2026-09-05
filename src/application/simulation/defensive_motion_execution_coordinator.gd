class_name DefensiveMotionExecutionCoordinator
extends RefCounted

const MotionPort = preload("res://src/application/simulation/motion_port.gd")

## Executes already-selected defensive cognition through the semantic motion port.
## Threat perception never calls this directly; only a committed CurrentIntention
## is eligible to produce movement side effects.

var _motion
var _escape_resolver
var _actor_ref
var _defensive_intention_keys: Dictionary = {}
var _threat_role: StringName


func _init(
	motion,
	escape_resolver,
	actor_ref,
	defensive_intention_ids: Array,
	threat_role: StringName = &"threat_source"
) -> void:
	assert(motion != null, "DefensiveMotionExecutionCoordinator requires MotionPort")
	assert(escape_resolver != null and escape_resolver.has_method("resolve"), "DefensiveMotionExecutionCoordinator requires escape resolver")
	assert(actor_ref != null, "DefensiveMotionExecutionCoordinator requires actor RuntimeWorldRef")
	assert(threat_role != &"", "threat role cannot be empty")
	_motion = motion
	_escape_resolver = escape_resolver
	_actor_ref = actor_ref
	_threat_role = threat_role
	for intention_id in defensive_intention_ids:
		assert(intention_id != null, "defensive intention ids cannot contain null")
		_defensive_intention_keys[String(intention_id.sort_key())] = true


func apply(intention_state) -> Dictionary:
	if intention_state == null or intention_state.intention_id == null:
		return _result(false, false, null, &"no_intention")
	if not _defensive_intention_keys.has(String(intention_state.intention_id.sort_key())):
		return _result(false, false, null, &"not_defensive")
	if intention_state.bindings == null or not intention_state.bindings.has(_threat_role):
		return _result(true, false, null, &"missing_threat_source")

	var threat_ref = intention_state.bindings.get_subject(_threat_role)
	var destination = _escape_resolver.resolve(_actor_ref, threat_ref)
	if destination == null:
		return _result(true, false, null, &"no_escape_destination")

	var previous_status: int = _motion.get_status(_actor_ref)
	if previous_status == MotionPort.MotionStatus.MOVING:
		_motion.cancel_move(_actor_ref)
	if not _motion.request_move(_actor_ref, destination):
		return _result(true, false, destination, &"move_rejected")
	return _result(true, true, destination, &"redirected")


func _result(handled: bool, redirected: bool, target_ref, reason: StringName) -> Dictionary:
	return {
		"handled": handled,
		"redirected": redirected,
		"target_ref": target_ref,
		"reason": reason,
	}
