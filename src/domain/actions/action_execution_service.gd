class_name ActionExecutionService
extends RefCounted

const ActionExecutionState = preload("res://src/domain/actions/action_execution_state.gd")
const ActionProgressResult = preload("res://src/domain/actions/action_progress_result.gd")
const ActionOutcome = preload("res://src/domain/actions/action_outcome.gd")

var _attemptability
var _states: Dictionary = {}


func _init(attemptability_service) -> void:
	assert(attemptability_service != null, "ActionExecutionService requires attemptability service")
	_attemptability = attemptability_service


func start(execution_id: StringName, action_definition, resolution_definition, bindings):
	assert(execution_id != &"", "start requires execution id")
	if _states.has(execution_id):
		return null
	var attemptability = _attemptability.query(action_definition, bindings)
	if not attemptability.attemptable:
		return null
	var state = ActionExecutionState.new(execution_id, action_definition, resolution_definition, bindings)
	_states[execution_id] = state
	return state


func get_state(execution_id: StringName):
	return _states.get(execution_id)


func advance(execution_id: StringName, elapsed: float):
	assert(elapsed >= 0.0, "advance elapsed must be >= 0")
	var state = _states.get(execution_id)
	assert(state != null, "Unknown action execution: %s" % String(execution_id))
	if state.completed:
		return ActionProgressResult.new(execution_id, 1.0, state.committed, true)

	state.elapsed = min(state.elapsed + elapsed, state.resolution_definition.duration)
	var progress: float = state.elapsed / state.resolution_definition.duration
	var outcome = null
	if not state.committed and progress >= state.resolution_definition.commit_fraction:
		state.committed = true
		if not state.outcome_emitted:
			state.outcome_emitted = true
			outcome = ActionOutcome.new(
				state.execution_id,
				state.action_definition.id,
				state.bindings,
				state.resolution_definition.effects,
				state.resolution_definition.event_type
			)

	if state.elapsed >= state.resolution_definition.duration:
		state.completed = true

	return ActionProgressResult.new(execution_id, progress, state.committed, state.completed, outcome)


func can_interrupt(execution_id: StringName) -> bool:
	var state = _states.get(execution_id)
	assert(state != null, "Unknown action execution")
	return not state.committed


func interrupt(execution_id: StringName) -> bool:
	var state = _states.get(execution_id)
	assert(state != null, "Unknown action execution")
	if state.committed:
		return false
	_states.erase(execution_id)
	return true
