class_name AssociationImpact
extends RefCounted

var subject
var valence_delta: float
var attachment_delta: float
var weight: float
var source_execution_id: StringName


func _init(
	p_subject,
	p_valence_delta: float,
	p_attachment_delta: float,
	p_weight: float,
	p_source_execution_id: StringName
) -> void:
	assert(p_subject != null and p_subject.has_method("sort_key"), "AssociationImpact requires semantic subject")
	assert(is_finite(p_valence_delta) and p_valence_delta >= -1.0 and p_valence_delta <= 1.0, "Association valence delta must be within [-1,1]")
	assert(is_finite(p_attachment_delta) and p_attachment_delta >= 0.0 and p_attachment_delta <= 1.0, "Association attachment delta must be within [0,1]")
	assert(is_finite(p_weight) and p_weight >= 0.0 and p_weight <= 1.0, "Association impact weight must be within [0,1]")
	assert(p_source_execution_id != &"", "AssociationImpact requires source execution id")
	subject = p_subject
	valence_delta = p_valence_delta
	attachment_delta = p_attachment_delta
	weight = p_weight
	source_execution_id = p_source_execution_id
