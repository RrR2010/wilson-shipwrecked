class_name ActionExecutionService
extends RefCounted

const MutationResult = preload("res://src/domain/core/mutation_result.gd")
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


func restore_state(
	execution_id: StringName,
	action_definition,
	resolution_definition,
	bindings,
	elapsed: float,
	committed: bool,
	completed: bool,
	outcome_emitted: bool
) -> MutationResult:
	assert(execution_id != &"", "restore_state requires execution id")
	assert(action_definition != null, "restore_state requires ActionDefinition")
	assert(resolution_definition != null, "restore_state requires ActionResolutionDefinition")
	assert(bindings != null, "restore_state requires bindings")
	if _states.has(execution_id):
		return MutationResult.failure(&"duplicate_action_execution", ["Execution already exists: %s" % String(execution_id)])
	if elapsed < 0.0 or elapsed > resolution_definition.duration:
		return MutationResult.failure(&"invalid_action_execution_elapsed", ["Elapsed is outside resolution duration"])
	if outcome_emitted and not committed:
		return MutationResult.failure(&"invalid_action_execution_commit_state", ["Outcome cannot be emitted before commit"])
	if completed and not is_equal_approx(elapsed, resolution_definition.duration):
		return MutationResult.failure(&"invalid_action_execution_completion_state", ["Completed execution must be at full duration"])
	var progress: float = elapsed / resolution_definition.duration
	if committed and progress < resolution_definition.commit_fraction:
		return MutationResult.failure(&"invalid_action_execution_commit_state", ["Committed execution is before commit checkpoint"])
	if not committed and progress >= resolution_definition.commit_fraction:
		return MutationResult.failure(&"invalid_action_execution_commit_state", ["Uncommitted execution is at or beyond commit checkpoint"])

	# Do not rerun attemptability here. A committed action may have already changed
	# World truth such that the original attempt is no longer currently attemptable;
	# reconstruction must restore the legitimate causal state, not reconsider it.
	var state = ActionExecutionState.new(execution_id, action_definition, resolution_definition, bindings)
	state.elapsed = elapsed
	state.committed = committed
	state.completed = completed
	state.outcome_emitted = outcome_emitted
	_states[execution_id] = state
	return MutationResult.success(&"action_execution_restored", state)


func get_state(execution_id: StringName):
	return _states.get(execution_id)


func states() -> Array:
	var result: Array = _states.values()
	result.sort_custom(func(a, b): return String(a.execution_id) < String(b.execution_id))
	return result


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
