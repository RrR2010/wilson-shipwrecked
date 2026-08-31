class_name SimulationOrchestrator
extends RefCounted

const SimulationStepContext = preload("res://src/application/simulation/simulation_step_context.gd")
const SimulationStepResult = preload("res://src/application/simulation/simulation_step_result.gd")
const SimulationStepTrace = preload("res://src/infrastructure/diagnostics/simulation_step_trace.gd")

## Thin application-layer coordinator. Owns ordering only, never durable truth.

var _world_clock
var _world_advance
var _action_execution
var _perception
var _decision_router
var _learning
var _owner_commands
var _trace_sink


func _init(world_clock, world_advance, action_execution, perception, decision_router, learning, owner_commands, trace_sink) -> void:
	_world_clock = world_clock
	_world_advance = world_advance
	_action_execution = action_execution
	_perception = perception
	_decision_router = decision_router
	_learning = learning
	_owner_commands = owner_commands
	_trace_sink = trace_sink


func advance(step: SimulationStepContext) -> SimulationStepResult:
	var trace := SimulationStepTrace.new(step.step_id)
	trace.record_input(&"elapsed", step.elapsed)
	var world_advance_result = _world_advance.advance(step.elapsed, step)
	trace.record_result(&"world_advance", world_advance_result)
	var action_progress = _action_execution.advance(step.elapsed, step)
	trace.record_result(&"action_progress", action_progress)
	var perception_result = _perception.perceive(step, world_advance_result, action_progress)
	trace.record_result(&"perception", perception_result)
	var learning_result = _learning.process_immediate(perception_result, action_progress, step)
	trace.record_result(&"immediate_learning", learning_result)
	var decision_result = _decision_router.resolve(step, perception_result, learning_result)
	trace.record_result(&"decision", decision_result)
	var command_result = _owner_commands.apply(decision_result.owner_commands)
	trace.record_result(&"owner_commands", command_result)
	var result := SimulationStepResult.new(step.step_id, world_advance_result, action_progress, perception_result, learning_result, decision_result, command_result)
	trace.complete(result)
	_trace_sink.record(trace)
	return result
