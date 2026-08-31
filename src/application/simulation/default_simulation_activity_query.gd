class_name DefaultSimulationActivityQuery
extends RefCounted

const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")

## Narrow orchestration read adapter over actual owners.
## It prevents the orchestrator from retaining a stale externally supplied active
## execution id after completion/interruption.

var _action_execution
var _intention_store
var _actor_role: StringName
var _actor


func _init(
	action_execution,
	intention_store,
	actor = null,
	actor_role: StringName = &"actor"
) -> void:
	assert(action_execution != null, "DefaultSimulationActivityQuery requires ActionExecutionService")
	assert(intention_store != null, "DefaultSimulationActivityQuery requires CurrentIntentionStore")
	assert(actor_role != &"", "actor role cannot be empty")
	_action_execution = action_execution
	_intention_store = intention_store
	_actor = actor if actor != null else RuntimeWorldRef.wilson()
	_actor_role = actor_role


func active_execution_id() -> StringName:
	var matches: Array = []
	for state in _action_execution.active_states():
		if not state.bindings.has(_actor_role):
			continue
		var bound_actor = state.bindings.get_subject(_actor_role)
		if bound_actor.equals(_actor):
			matches.append(state)
	assert(matches.size() <= 1, "Actor has multiple active action executions; orchestration requires explicit concurrency policy")
	return &"" if matches.is_empty() else matches[0].execution_id


func current_intention():
	return _intention_store.current() if _intention_store.has_current() else null
