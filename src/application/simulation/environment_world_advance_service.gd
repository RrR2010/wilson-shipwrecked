class_name EnvironmentWorldAdvanceService
extends RefCounted

const WorldAdvanceResult = preload("res://src/application/simulation/world_advance_result.gd")

var _dynamic_process_advance
var _actor_advance
var _actor_stimulus_provider


func _init(dynamic_process_advance, actor_advance = null, actor_stimulus_provider = null) -> void:
	assert(dynamic_process_advance != null, "EnvironmentWorldAdvanceService requires dynamic process advance service")
	assert(actor_advance != null or actor_stimulus_provider == null, "Actor stimulus provider requires actor advance service")
	_dynamic_process_advance = dynamic_process_advance
	_actor_advance = actor_advance
	_actor_stimulus_provider = actor_stimulus_provider


func advance(elapsed: float, step):
	var process_result: Dictionary = _dynamic_process_advance.advance(elapsed)
	var diagnostics: Array[String] = []
	for diagnostic in process_result["diagnostics"]:
		diagnostics.append(String(diagnostic))
	if _actor_advance != null:
		var stimuli: Dictionary = {}
		if _actor_stimulus_provider != null:
			stimuli = _actor_stimulus_provider.resolve(step)
		var actor_result: Dictionary = _actor_advance.advance(elapsed, stimuli)
		for diagnostic in actor_result["diagnostics"]:
			diagnostics.append(String(diagnostic))
	return WorldAdvanceResult.new([], diagnostics, process_result["change_set"])
