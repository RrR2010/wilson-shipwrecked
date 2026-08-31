class_name DecisionSelectionResult
extends RefCounted

var selected_candidate
var regime: StringName
var diagnostics: Array[String]

func _init(p_selected_candidate = null, p_regime: StringName = &"none", p_diagnostics: Array[String] = []) -> void:
	selected_candidate = p_selected_candidate
	regime = p_regime
	diagnostics = p_diagnostics.duplicate()

func has_selection() -> bool:
	return selected_candidate != null
