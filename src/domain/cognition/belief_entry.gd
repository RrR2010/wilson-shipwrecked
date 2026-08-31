class_name BeliefEntry
extends RefCounted

var proposition
var confidence: float
var evidence_count: int = 0
var last_source_execution_id: StringName = &""
var last_modality: StringName = &""

func _init(p_proposition, p_confidence: float = 0.0) -> void:
	assert(p_proposition != null, "BeliefEntry requires proposition")
	assert(p_confidence >= 0.0 and p_confidence <= 1.0, "confidence must be within [0,1]")
	proposition = p_proposition
	confidence = p_confidence

func apply_evidence(evidence) -> void:
	assert(evidence != null, "apply_evidence requires BeliefEvidence")
	assert(evidence.proposition.key() == proposition.key(), "Evidence proposition mismatch")
	if evidence.supports:
		confidence = confidence + evidence.strength * (1.0 - confidence)
	else:
		confidence = confidence - evidence.strength * confidence
	confidence = clampf(confidence, 0.0, 1.0)
	evidence_count += 1
	last_source_execution_id = evidence.source_execution_id
	last_modality = evidence.modality
