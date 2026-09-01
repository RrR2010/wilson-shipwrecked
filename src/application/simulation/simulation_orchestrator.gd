class_name SimulationOrchestrator
extends RefCounted

const SimulationStepResult = preload("res://src/application/simulation/simulation_step_result.gd")
const SimulationStepTrace = preload("res://src/infrastructure/diagnostics/simulation_step_trace.gd")

## Thin application-layer coordinator. Owns deterministic ordering only.
## Durable truth remains in World, ActionExecution, Wilson Cognition and Projects owners.
##
## Authoritative ordering:
## world progression -> derived invalidation -> action progression
## -> committed outcome application -> derived invalidation -> grounded project progression
## -> perception -> immediate Wilson learning -> drive progression
## -> perceived-threat + ordinary candidate generation -> routing
## -> selected intention commit.

var _world_advance
var _action_execution
var _world_commands
var _derived_invalidator
var _activity_query
var _perception_access
var _perception
var _learning
var _opportunity_service
var _belief_store
var _opportunity_definitions: Array
var _decision_router
var _decision_commit
var _trace_sink
var _drive_progression
var _drive_candidate_source
var _project_contribution
var _project_candidate_source
var _additional_candidate_sources: Array
var _immediate_threat_candidate_source


func _init(
	world_advance,
	action_execution,
	world_commands,
	derived_invalidator,
	activity_query,
	perception_access,
	perception,
	learning,
	opportunity_service,
	belief_store,
	opportunity_definitions: Array,
	decision_router,
	decision_commit,
	trace_sink,
	drive_progression = null,
	drive_candidate_source = null,
	project_contribution = null,
	project_candidate_source = null,
	additional_candidate_sources: Array = [],
	immediate_threat_candidate_source = null
) -> void:
	assert(world_advance != null, "SimulationOrchestrator requires world advance service")
	assert(action_execution != null, "SimulationOrchestrator requires action execution")
	assert(world_commands != null, "SimulationOrchestrator requires World command port")
	assert(derived_invalidator != null, "SimulationOrchestrator requires derived state invalidator")
	assert(activity_query != null, "SimulationOrchestrator requires activity query")
	assert(perception_access != null, "SimulationOrchestrator requires perception access resolver")
	assert(perception != null, "SimulationOrchestrator requires perception service")
	assert(learning != null, "SimulationOrchestrator requires learning coordinator")
	assert(opportunity_service != null, "SimulationOrchestrator requires opportunity service")
	assert(belief_store != null, "SimulationOrchestrator requires BeliefStore")
	assert(decision_router != null, "SimulationOrchestrator requires decision router")
	assert(decision_commit != null, "SimulationOrchestrator requires decision commit coordinator")
	assert(trace_sink != null, "SimulationOrchestrator requires trace sink")
	assert((drive_progression == null) == (drive_candidate_source == null), "Drive progression and candidate source must be provided together")
	assert((project_contribution == null) == (project_candidate_source == null), "Project contribution and candidate source must be provided together")
	for source in additional_candidate_sources:
		assert(source != null and source.has_method("generate"), "Additional candidate sources must implement generate()")
	if immediate_threat_candidate_source != null:
		assert(immediate_threat_candidate_source.has_method("generate"), "Immediate threat source must implement generate(perception_result)")
	_world_advance = world_advance
	_action_execution = action_execution
	_world_commands = world_commands
	_derived_invalidator = derived_invalidator
	_activity_query = activity_query
	_perception_access = perception_access
	_perception = perception
	_learning = learning
	_opportunity_service = opportunity_service
	_belief_store = belief_store
	_opportunity_definitions = opportunity_definitions.duplicate()
	_decision_router = decision_router
	_decision_commit = decision_commit
	_trace_sink = trace_sink
	_drive_progression = drive_progression
	_drive_candidate_source = drive_candidate_source
	_project_contribution = project_contribution
	_project_candidate_source = project_candidate_source
	_additional_candidate_sources = additional_candidate_sources.duplicate()
	_immediate_threat_candidate_source = immediate_threat_candidate_source


func advance(step):
	assert(step != null, "advance requires SimulationStepContext")
	var trace = SimulationStepTrace.new(step.step_id)
	trace.record_input(&"elapsed", step.elapsed)
	trace.record_input(&"simulation_time", step.simulation_time)

	var world_advance_result = _world_advance.advance(step.elapsed, step)
	assert(world_advance_result != null, "world advance must return WorldAdvanceResult")
	trace.record_result(&"world_advance", world_advance_result)
	if world_advance_result.change_set != null and not world_advance_result.change_set.is_empty():
		var world_invalidation_result = _derived_invalidator.apply(world_advance_result.change_set)
		trace.record_result(&"world_derived_invalidation", world_invalidation_result)

	var action_progress = null
	var commit_result = null
	var project_progress = null
	var execution_id: StringName = _activity_query.active_execution_id()
	if execution_id != &"":
		action_progress = _action_execution.advance(execution_id, step.elapsed)
		trace.record_result(&"action_progress", action_progress)
		if action_progress != null and action_progress.new_outcome != null:
			commit_result = _world_commands.apply_outcome(action_progress.new_outcome)
			trace.record_result(&"world_commit", commit_result)
			if commit_result.ok:
				var invalidation_result = _derived_invalidator.apply(commit_result.change_set)
				trace.record_result(&"derived_invalidation", invalidation_result)
			if _project_contribution != null:
				project_progress = _project_contribution.apply_grounded(action_progress.new_outcome, commit_result)
				trace.record_result(&"project_progression", project_progress)

	var committed_events: Array = world_advance_result.events.duplicate()
	if commit_result != null and commit_result.ok:
		committed_events.append_array(commit_result.events)
	trace.record_result(&"committed_events", committed_events)

	var access_by_execution: Dictionary = _perception_access.resolve(committed_events, step)
	trace.record_result(&"perception_access", access_by_execution)
	var perception_result = _perception.perceive(committed_events, access_by_execution)
	trace.record_result(&"perception", perception_result)

	var learning_result = _learning.process(perception_result)
	trace.record_result(&"immediate_learning", learning_result)

	if _drive_progression != null:
		var drive_progress = _drive_progression.advance(step.elapsed)
		trace.record_result(&"drive_progression", drive_progress)

	var candidates: Array = _opportunity_service.generate(
		perception_result,
		_belief_store,
		_opportunity_definitions
	)
	if _immediate_threat_candidate_source != null:
		var threat_candidates: Array = _immediate_threat_candidate_source.generate(perception_result)
		candidates.append_array(threat_candidates)
		trace.record_result(&"immediate_threat_candidates", threat_candidates)
	if _drive_candidate_source != null:
		candidates.append_array(_drive_candidate_source.generate())
	if _project_candidate_source != null:
		candidates.append_array(_project_candidate_source.generate())
	for source in _additional_candidate_sources:
		candidates.append_array(source.generate())
	candidates.sort_custom(func(a, b): return a.stable_key() < b.stable_key())
	trace.record_result(&"decision_candidates", candidates)
	var decision_result = _decision_router.resolve(candidates, _activity_query.current_intention())
	trace.record_result(&"decision", decision_result)

	var intention_commit = _decision_commit.apply(decision_result, step.step_id)
	trace.record_result(&"intention_commit", intention_commit)

	var result = SimulationStepResult.new(
		step.step_id,
		world_advance_result,
		action_progress,
		perception_result,
		learning_result,
		candidates,
		decision_result,
		intention_commit,
		commit_result
	)
	trace.complete(result)
	_trace_sink.record(trace)
	return result
