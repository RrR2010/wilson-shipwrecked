class_name GodotSimulationHost
extends Node

const SimulationCadenceClock = preload("res://src/application/simulation/simulation_cadence_clock.gd")
const SimulationStepContext = preload("res://src/application/simulation/simulation_step_context.gd")
const GodotReconsiderationTriggerBuffer = preload("res://src/infrastructure/spatial/godot_reconsideration_trigger_buffer.gd")

## Fine-engine host for the application simulation.
##
## Physics/motion progresses at Godot physics cadence. Reconsideration triggers and
## typed physical observations cross into the application only at semantic steps.

var _orchestrator
var _motion_adapter
var _physical_observation_port
var _cadence_clock: SimulationCadenceClock
var _trigger_buffer: GodotReconsiderationTriggerBuffer
var _simulation_time: float = 0.0
var _step_index: int = 0
var _configured := false


func configure(
	orchestrator,
	motion_adapter = null,
	step_seconds: float = 0.1,
	initial_simulation_time: float = 0.0,
	physical_observation_port = null
) -> void:
	assert(orchestrator != null, "GodotSimulationHost requires SimulationOrchestrator")
	assert(is_finite(initial_simulation_time) and initial_simulation_time >= 0.0, "initial simulation time must be finite and non-negative")
	if physical_observation_port != null:
		assert(physical_observation_port.has_method("drain_observations"), "Physical observation port must implement drain_observations()")
	_orchestrator = orchestrator
	_motion_adapter = motion_adapter
	_physical_observation_port = physical_observation_port
	_cadence_clock = SimulationCadenceClock.new(step_seconds)
	_trigger_buffer = GodotReconsiderationTriggerBuffer.new()
	_simulation_time = initial_simulation_time
	_step_index = 0
	_configured = true


func enqueue_reconsideration_trigger(trigger: int) -> bool:
	if not _configured:
		return false
	return _trigger_buffer.enqueue(trigger)


func simulation_time() -> float:
	return _simulation_time


func semantic_step_count() -> int:
	return _step_index


func _physics_process(delta: float) -> void:
	if not _configured:
		return
	if _motion_adapter != null and _motion_adapter.has_method("physics_tick"):
		_motion_adapter.physics_tick(delta)
	var due_steps: int = _cadence_clock.advance(delta)
	for _i in range(due_steps):
		_run_semantic_step()


func advance_engine_time_for_test(delta: float) -> int:
	## Headless helper that exercises the same cadence path without requiring SceneTree physics.
	if not _configured:
		return 0
	if _motion_adapter != null and _motion_adapter.has_method("physics_tick"):
		_motion_adapter.physics_tick(delta)
	var due_steps: int = _cadence_clock.advance(delta)
	for _i in range(due_steps):
		_run_semantic_step()
	return due_steps


func _run_semantic_step() -> void:
	_simulation_time += _cadence_clock.step_seconds
	_step_index += 1
	var triggers: Array[int] = _trigger_buffer.drain()
	var physical_observations: Array = []
	if _physical_observation_port != null:
		physical_observations = _physical_observation_port.drain_observations()
	var step_id := StringName("semantic_step_%d" % _step_index)
	var step = SimulationStepContext.new(
		step_id,
		_cadence_clock.step_seconds,
		_simulation_time,
		null,
		triggers,
		physical_observations
	)
	_orchestrator.advance(step)
