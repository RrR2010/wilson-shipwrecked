class_name ResurrectionService
extends RefCounted

const MutationResult = preload("res://src/domain/core/mutation_result.gd")
const RunLifecycleState = preload("res://src/application/lifecycle/run_lifecycle_state.gd")

## Coordinates resurrection without owning physical Wilson state.
## The World/body resurrection port must admit the physical restore first.

var _run_state
var _body_resurrection_port


func _init(run_state, body_resurrection_port) -> void:
	assert(run_state != null, "ResurrectionService requires RunLifecycleState")
	assert(body_resurrection_port != null and body_resurrection_port.has_method("resurrect_wilson"), "ResurrectionService requires body resurrection port")
	_run_state = run_state
	_body_resurrection_port = body_resurrection_port


func resurrect():
	if _run_state.lifecycle != RunLifecycleState.Lifecycle.DEAD:
		return MutationResult.failure(&"run_not_dead", ["Resurrection requires a dead current run"])
	var physical_result = _body_resurrection_port.resurrect_wilson(_run_state.run_id)
	if physical_result == null or not physical_result.ok:
		return MutationResult.failure(&"physical_resurrection_rejected", ["World/body owner rejected resurrection"])
	return _run_state.mark_resurrected()
