class_name BeliefBootstrapSeed
extends RefCounted

var proposition
var confidence: float
var evidence_count: int
var last_source_execution_id: StringName
var last_modality: StringName


func _init(
	p_proposition,
	p_confidence: float,
	p_evidence_count: int,
	p_last_source_execution_id: StringName = &"",
	p_last_modality: StringName = &""
) -> void:
	assert(p_proposition != null, "BeliefBootstrapSeed requires proposition")
	assert(p_confidence >= 0.0 and p_confidence <= 1.0, "BeliefBootstrapSeed confidence must be within [0,1]")
	assert(p_evidence_count >= 0, "BeliefBootstrapSeed evidence_count must be >= 0")
	proposition = p_proposition
	confidence = p_confidence
	evidence_count = p_evidence_count
	last_source_execution_id = p_last_source_execution_id
	last_modality = p_last_modality
