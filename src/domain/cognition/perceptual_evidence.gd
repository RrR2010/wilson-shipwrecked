class_name PerceptualEvidence
extends RefCounted

const EpistemicClaim = preload("res://src/domain/cognition/epistemic_claim.gd")

## Owner-local evidence proposal derived from an observation.
## The semantic payload is a typed EpistemicClaim. Confidence/access metadata is
## provenance only; this object never mutates beliefs directly.

var claim
var confidence: float
var source_execution_id: StringName
var modality: StringName


func _init(
	p_claim,
	p_confidence: float,
	p_source_execution_id: StringName,
	p_modality: StringName
) -> void:
	assert(p_claim != null and p_claim.get_script() == EpistemicClaim, "PerceptualEvidence requires EpistemicClaim")
	assert(p_confidence >= 0.0 and p_confidence <= 1.0, "confidence must be within [0,1]")
	assert(p_source_execution_id != &"", "PerceptualEvidence requires source execution id")
	assert(p_modality != &"", "PerceptualEvidence requires modality")
	claim = p_claim
	confidence = p_confidence
	source_execution_id = p_source_execution_id
	modality = p_modality
