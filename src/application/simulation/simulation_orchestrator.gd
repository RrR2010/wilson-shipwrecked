class_name SimulationOrchestrator
extends RefCounted

## Thin application-layer coordinator.
##
## This object owns ordering only. It does not own durable gameplay truth and must
## not reach into concrete stores. Every dependency is a narrow semantic port.

var _world_clock
var _world_advance
var _action_execution
var _perception
var _decision_router
var _learning
var _owner_commands
var _trace_sink


func _init(
	world_clock,
	world_advance,
	action_execution,
	perception,
	decision_router,
	learning,
	owner_commands,
	trace_sink
) -> void:
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
	trace.record_input("elapsed", step.elapsed)

	# 1. Advance authoritative time/world/body/processes.
	var world_advance_result = _world_advance.advance(step.elapsed, step)
	trace.record_result("world_advance", world_advance_result)

	# 2. Advance the currently executing action, if any.
	var action_progress = _action_execution.advance(step.elapsed, step)
	trace.record_result("action_progress", action_progress)

	# 3. Perceive only the world/event projection accessible to Wilson.
	var perception_result = _perception.perceive(step, world_advance_result, action_progress)
	trace.record_result("perception", perception_result)

	# 4. Apply only immediate learning required to affect this same decision chain.
	var learning_result = _learning.process_immediate(perception_result, action_progress, step)
	trace.record_result("immediate_learning", learning_result)

	# 5. Route to NONE / TACTICAL / INTENTIONAL / IMMEDIATE_THREAT.
	var decision_result = _decision_router.resolve(step, perception_result, learning_result)
	trace.record_result("decision", decision_result)

	# 6. Apply explicit owner-local commands produced by the pipeline.
	# The application layer coordinates commands; derived services never mutate stores.
	var command_result = _owner_commands.apply(decision_result.owner_commands)
	trace.record_result("owner_commands", command_result)

	var result := SimulationStepResult.new(
		step.step_id,
		world_advance_result,
		action_progress,
		perception_result,
		learning_result,
		decision_result,
		command_result
	)
	trace.complete(result)
	_trace_sink.record(trace)
	return result
