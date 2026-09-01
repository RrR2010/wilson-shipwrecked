class_name PresenceAttributionEvidence
extends RefCounted

## Wilson-relative interpreted evidence about an unseen agency.
## This is downstream of perception/causal attribution and never carries player-private intent.

var agency_delta: float
var outcome_valence: float
var dependency_delta: float
var confidence: float
var source_execution_id: StringName


func _init(
	p_agency_delta: float,
	p_outcome_valence: float,
	p_dependency_delta: float,
	p_confidence: float,
	p_source_execution_id: StringName
) -> void:
	assert(is_finite(p_agency_delta) and p_agency_delta >= -1.0 and p_agency_delta <= 1.0, "Presence agency delta must be within [-1,1]")
	assert(is_finite(p_outcome_valence) and p_outcome_valence >= -1.0 and p_outcome_valence <= 1.0, "Presence outcome valence must be within [-1,1]")
	assert(is_finite(p_dependency_delta) and p_dependency_delta >= -1.0 and p_dependency_delta <= 1.0, "Presence dependency delta must be within [-1,1]")
	assert(is_finite(p_confidence) and p_confidence >= 0.0 and p_confidence <= 1.0, "Presence attribution confidence must be within [0,1]")
	assert(p_source_execution_id != &"", "PresenceAttributionEvidence requires source execution id")
	agency_delta = p_agency_delta
	outcome_valence = p_outcome_valence
	dependency_delta = p_dependency_delta
	confidence = p_confidence
	source_execution_id = p_source_execution_id
