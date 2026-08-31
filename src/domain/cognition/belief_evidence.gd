class_name BeliefEvidence
extends RefCounted

var proposition
var supports: bool
var strength: float
var source_execution_id: StringName
var modality: StringName

func _init(p_proposition, p_supports: bool, p_strength: float, p_source_execution_id: StringName, p_modality: StringName) -> void:
	assert(p_proposition != null, "BeliefEvidence requires proposition")
	assert(p_strength >= 0.0 and p_strength <= 1.0, "strength must be within [0,1]")
	proposition = p_proposition
	supports = p_supports
	strength = p_strength
	source_execution_id = p_source_execution_id
	modality = p_modality
