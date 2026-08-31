class_name SimulationOrchestrator
extends RefCounted

const SimulationStepResult = preload("res://src/application/simulation/simulation_step_result.gd")
const SimulationStepTrace = preload("res://src/infrastructure/diagnostics/simulation_step_trace.gd")

## Thin application-layer coordinator. Owns deterministic ordering only.
## Durable truth remains in World, ActionExecution and Wilson Cognition owners.
##
## Authoritative ordering:
## world progression -> action progression -> committed outcome application
## -> perception -> immediate belief learning -> candidate generation -> routing.

var _world_advance
var _action_execution
var _world_commands
var _activity_query
var _perception_access
var _perception
var _learning
var _opportunity_service
var _belief_store
var _opportunity_definitions: Array
var _decision_router
var _trace_sink


func _init(
	world_advance,
	action_execution,
	world_commands,
	activity_query,
	perception_access,
	perception,
	learning,
	opportunity_service,
	belief_store,
	opportunity_definitions: Array,
	decision_router,
	trace_sink
) -> void:
	assert(world_advance != null, "SimulationOrchestrator requires world advance service")
	assert(action_execution != null, "SimulationOrchestrator requires action execution")
	assert(world_commands != null, "SimulationOrchestrator requires World command port")
	assert(activity_query != null, "SimulationOrchestrator requires activity query")
	assert(perception_access != null, "SimulationOrchestrator requires perception access resolver")
	assert(perception != null, "SimulationOrchestrator requires perception service")
	assert(learning != null, "SimulationOrchestrator requires learning coordinator")
	assert(opportunity_service != null, "SimulationOrchestrator requires opportunity service")
	assert(belief_store != null, "SimulationOrchestrator requires BeliefStore")
	assert(decision_router != null, "SimulationOrchestrator requires decision router")
	assert(trace_sink != null, "SimulationOrchestrator requires trace sink")
	_world_advance = world_advance
	_action_execution = action_execution
	_world_commands = world_commands
	_activity_query = activity_query
	_perception_access = perception_access
	_perception = perception
	_learning = learning
	_opportunity_service = opportunity_service
	_belief_store = belief_store
	_opportunity_definitions = opportunity_definitions.duplicate()
	_decision_router = decision_router
	_trace_sink = trace_sink


func advance(step):
	assert(step != null, "advance requires SimulationStepContext")
	var trace = SimulationStepTrace.new(step.step_id)
	trace.record_input(&"elapsed", step.elapsed)
	trace.record_input(&"simulation_time", step.simulation_time)

	var world_advance_result = _world_advance.advance(step.elapsed, step)
	assert(world_advance_result != null, "world advance must return WorldAdvanceResult")
	trace.record_result(&"world_advance", world_advance_result)

	var action_progress = null
	var commit_result = null
	var execution_id: StringName = _activity_query.active_execution_id()
	if execution_id != &"":
		action_progress = _action_execution.advance(execution_id, step.elapsed)
		trace.record_result(&"action_progress", action_progress)
		if action_progress != null and action_progress.outcome != null:
			commit_result = _world_commands.apply_outcome(action_progress.outcome)
			trace.record_result(&"world_commit", commit_result)

	var committed_events: Array = world_advance_result.events.duplicate()
	if commit_result != null and commit_result.committed:
		committed_events.append_array(commit_result.events)
	trace.record_result(&"committed_events", committed_events)

	var access_by_execution: Dictionary = _perception_access.resolve(committed_events, step)
	trace.record_result(&"perception_access", access_by_execution)
	var perception_result = _perception.perceive(committed_events, access_by_execution)
	trace.record_result(&"perception", perception_result)

	var learning_result = _learning.process(perception_result)
	trace.record_result(&"immediate_learning", learning_result)

	var candidates: Array = _opportunity_service.generate(
		perception_result,
		_belief_store,
		_opportunity_definitions
	)
	trace.record_result(&"decision_candidates", candidates)
	var decision_result = _decision_router.resolve(candidates, _activity_query.current_intention())
	trace.record_result(&"decision", decision_result)

	var result = SimulationStepResult.new(
		step.step_id,
		world_advance_result,
		action_progress,
		perception_result,
		learning_result,
		candidates,
		decision_result,
		commit_result
	)
	trace.complete(result)
	_trace_sink.record(trace)
	return result
