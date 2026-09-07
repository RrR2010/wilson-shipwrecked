class_name PresenceAttributionRule
extends RefCounted

const DomainId = preload("res://src/domain/core/domain_id.gd")

## Authored Wilson-relative interpretation of a perceived semantic event as evidence
## for an unseen agency. Rules consume perception only; they never receive player
## commands, intervention definitions, or Director intent.

var event_type
var perceived_role: StringName
var agency_delta: float
var outcome_valence: float
var dependency_delta: float
var minimum_confidence: float
var required_modality: StringName


func _init(
	p_event_type,
	p_perceived_role: StringName,
	p_agency_delta: float,
	p_outcome_valence: float,
	p_dependency_delta: float,
	p_minimum_confidence: float = 0.25,
	p_required_modality: StringName = &""
) -> void:
	assert(p_event_type != null, "PresenceAttributionRule requires event type")
	p_event_type.assert_kind(DomainId.Kind.EVENT_DEFINITION)
	assert(p_perceived_role != &"", "PresenceAttributionRule requires perceived role")
	assert(is_finite(p_agency_delta) and p_agency_delta >= -1.0 and p_agency_delta <= 1.0, "agency delta must be within [-1,1]")
	assert(is_finite(p_outcome_valence) and p_outcome_valence >= -1.0 and p_outcome_valence <= 1.0, "outcome valence must be within [-1,1]")
	assert(is_finite(p_dependency_delta) and p_dependency_delta >= -1.0 and p_dependency_delta <= 1.0, "dependency delta must be within [-1,1]")
	assert(is_finite(p_minimum_confidence) and p_minimum_confidence >= 0.0 and p_minimum_confidence <= 1.0, "minimum confidence must be within [0,1]")
	event_type = p_event_type
	perceived_role = p_perceived_role
	agency_delta = p_agency_delta
	outcome_valence = p_outcome_valence
	dependency_delta = p_dependency_delta
	minimum_confidence = p_minimum_confidence
	required_modality = p_required_modality


func matches(evidence) -> bool:
	if evidence == null or evidence.claim == null:
		return false
	if evidence.confidence < minimum_confidence:
		return false
	if required_modality != &"" and evidence.modality != required_modality:
		return false
	return evidence.claim.semantic_id.equals(event_type) and evidence.claim.role_name == perceived_role
