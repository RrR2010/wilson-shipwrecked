class_name AssociationBootstrapSeed
extends RefCounted

var subject
var valence: float
var attachment: float
var evidence_count: int
var last_source_execution_id: StringName


func _init(
	p_subject,
	p_valence: float,
	p_attachment: float,
	p_evidence_count: int,
	p_last_source_execution_id: StringName = &""
) -> void:
	assert(p_subject != null and p_subject.has_method("sort_key"), "AssociationBootstrapSeed requires semantic subject")
	assert(is_finite(p_valence) and p_valence >= -1.0 and p_valence <= 1.0, "Association seed valence must be within [-1,1]")
	assert(is_finite(p_attachment) and p_attachment >= 0.0 and p_attachment <= 1.0, "Association seed attachment must be within [0,1]")
	assert(p_evidence_count >= 0, "Association seed evidence count must be non-negative")
	subject = p_subject
	valence = p_valence
	attachment = p_attachment
	evidence_count = p_evidence_count
	last_source_execution_id = p_last_source_execution_id
