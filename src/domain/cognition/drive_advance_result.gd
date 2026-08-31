class_name DriveAdvanceResult
extends RefCounted

var previous_values: Dictionary
var current_values: Dictionary
var upward_band_crossings: Array[StringName]


func _init(
	p_previous_values: Dictionary,
	p_current_values: Dictionary,
	p_upward_band_crossings: Array[StringName]
) -> void:
	previous_values = p_previous_values.duplicate(true)
	current_values = p_current_values.duplicate(true)
	upward_band_crossings = p_upward_band_crossings.duplicate()


func requires_reconsideration() -> bool:
	return not upward_band_crossings.is_empty()
