class_name EnvironmentWorldAdvanceService
extends RefCounted

const WorldAdvanceResult = preload("res://src/application/simulation/world_advance_result.gd")

var _dynamic_process_advance
var _actor_advance
var _actor_stimulus_provider
var _dynamic_process_due_gate
var _semantic_event_projector


func _init(
	dynamic_process_advance,
	actor_advance = null,
	actor_stimulus_provider = null,
	dynamic_process_due_gate = null,
	semantic_event_projector = null
) -> void:
	assert(dynamic_process_advance != null, "EnvironmentWorldAdvanceService requires dynamic process advance service")
	assert(actor_advance != null or actor_stimulus_provider == null, "Actor stimulus provider requires actor advance service")
	if dynamic_process_due_gate != null:
		assert(dynamic_process_due_gate.has_method("elapsed_for_step"), "Dynamic-process due gate must implement elapsed_for_step()")
	if semantic_event_projector != null:
		assert(semantic_event_projector.has_method("project"), "Gradual semantic event projector must implement project(transitions, step_id)")
	_dynamic_process_advance = dynamic_process_advance
	_actor_advance = actor_advance
	_actor_stimulus_provider = actor_stimulus_provider
	_dynamic_process_due_gate = dynamic_process_due_gate
	_semantic_event_projector = semantic_event_projector


func advance(elapsed: float, step):
	var process_elapsed: float = elapsed
	if _dynamic_process_due_gate != null:
		process_elapsed = _dynamic_process_due_gate.elapsed_for_step(elapsed, step.simulation_time)
	var process_result: Dictionary = _dynamic_process_advance.advance(process_elapsed)
	var diagnostics: Array[String] = []
	for diagnostic in process_result["diagnostics"]:
		diagnostics.append(String(diagnostic))
	var events: Array = []
	if _semantic_event_projector != null:
		var transitions: Array = Array(process_result.get("transitions", []))
		events = _semantic_event_projector.project(transitions, step.step_id)
	if _actor_advance != null:
		var stimuli: Dictionary = {}
		if _actor_stimulus_provider != null:
			stimuli = _actor_stimulus_provider.resolve(step)
		var actor_result: Dictionary = _actor_advance.advance(elapsed, stimuli)
		for diagnostic in actor_result["diagnostics"]:
			diagnostics.append(String(diagnostic))
	return WorldAdvanceResult.new(events, diagnostics, process_result["change_set"])
