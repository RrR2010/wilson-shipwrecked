class_name EnvironmentWorldAdvanceService
extends RefCounted

const WorldAdvanceResult = preload("res://src/application/simulation/world_advance_result.gd")

var _dynamic_process_advance


func _init(dynamic_process_advance) -> void:
	assert(dynamic_process_advance != null, "EnvironmentWorldAdvanceService requires dynamic process advance service")
	_dynamic_process_advance = dynamic_process_advance


func advance(elapsed: float, _step):
	var process_result: Dictionary = _dynamic_process_advance.advance(elapsed)
	var diagnostics: Array[String] = []
	for diagnostic in process_result["diagnostics"]:
		diagnostics.append(String(diagnostic))
	return WorldAdvanceResult.new([], diagnostics, process_result["change_set"])
