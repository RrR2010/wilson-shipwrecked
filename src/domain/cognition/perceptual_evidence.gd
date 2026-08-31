class_name PerceptualEvidence
extends RefCounted

## Owner-local evidence proposal derived from an observation.
## Carries confidence/access metadata but does not mutate beliefs directly.

var subject
var predicate: StringName
var value: Variant
var confidence: float
var source_execution_id: StringName
var modality: StringName


func _init(
	p_subject,
	p_predicate: StringName,
	p_value: Variant,
	p_confidence: float,
	p_source_execution_id: StringName,
	p_modality: StringName
) -> void:
	assert(p_subject != null, "PerceptualEvidence requires subject")
	assert(p_predicate != &"", "PerceptualEvidence requires predicate")
	assert(p_confidence >= 0.0 and p_confidence <= 1.0, "confidence must be within [0,1]")
	assert(p_source_execution_id != &"", "PerceptualEvidence requires source execution id")
	assert(p_modality != &"", "PerceptualEvidence requires modality")
	subject = p_subject
	predicate = p_predicate
	value = p_value
	confidence = p_confidence
	source_execution_id = p_source_execution_id
	modality = p_modality
