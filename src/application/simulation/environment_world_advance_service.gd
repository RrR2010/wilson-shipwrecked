class_name EnvironmentWorldAdvanceService
extends RefCounted

const WorldAdvanceResult = preload("res://src/application/simulation/world_advance_result.gd")

var _dynamic_process_advance
var _actor_advance
var _actor_stimulus_provider
var _dynamic_process_due_gate
var _semantic_event_projector
var _weather_progression
var _weather_event_projector


func _init(
	dynamic_process_advance,
	actor_advance = null,
	actor_stimulus_provider = null,
	dynamic_process_due_gate = null,
	semantic_event_projector = null,
	weather_progression = null,
	weather_event_projector = null
) -> void:
	assert(dynamic_process_advance != null, "EnvironmentWorldAdvanceService requires dynamic process advance service")
	assert(actor_advance != null or actor_stimulus_provider == null, "Actor stimulus provider requires actor advance service")
	assert(weather_progression != null or weather_event_projector == null, "Weather event projector requires weather progression")
	if dynamic_process_due_gate != null:
		assert(dynamic_process_due_gate.has_method("elapsed_for_step"), "Dynamic-process due gate must implement elapsed_for_step()")
	if semantic_event_projector != null:
		assert(semantic_event_projector.has_method("project"), "Gradual semantic event projector must implement project(transitions, step_id)")
	if weather_progression != null:
		assert(weather_progression.has_method("advance"), "Weather progression must implement advance(elapsed)")
	if weather_event_projector != null:
		assert(weather_event_projector.has_method("project"), "Weather event projector must implement project(transitions, step_id)")
	_dynamic_process_advance = dynamic_process_advance
	_actor_advance = actor_advance
	_actor_stimulus_provider = actor_stimulus_provider
	_dynamic_process_due_gate = dynamic_process_due_gate
	_semantic_event_projector = semantic_event_projector
	_weather_progression = weather_progression
	_weather_event_projector = weather_event_projector


func advance(elapsed: float, step):
	var diagnostics: Array[String] = []
	var events: Array = []

	# Macro environment state advances before ordinary property processes so later
	# environment-response composition may consume the new regime in the same World phase.
	if _weather_progression != null:
		var weather_result: Dictionary = _weather_progression.advance(elapsed)
		if _weather_event_projector != null:
			events.append_array(_weather_event_projector.project(
				Array(weather_result.get("transitions", [])),
				step.step_id
			))

	var process_elapsed: float = elapsed
	if _dynamic_process_due_gate != null:
		process_elapsed = _dynamic_process_due_gate.elapsed_for_step(elapsed, step.simulation_time)
	var process_result: Dictionary = _dynamic_process_advance.advance(process_elapsed)
	for diagnostic in process_result["diagnostics"]:
		diagnostics.append(String(diagnostic))
	if _semantic_event_projector != null:
		var transitions: Array = Array(process_result.get("transitions", []))
		events.append_array(_semantic_event_projector.project(transitions, step.step_id))
	if _actor_advance != null:
		var stimuli: Dictionary = {}
		if _actor_stimulus_provider != null:
			stimuli = _actor_stimulus_provider.resolve(step)
		var actor_result: Dictionary = _actor_advance.advance(elapsed, stimuli)
		for diagnostic in actor_result["diagnostics"]:
			diagnostics.append(String(diagnostic))
	return WorldAdvanceResult.new(events, diagnostics, process_result["change_set"])
