class_name PerceivedCueRule
extends RefCounted

const DomainId = preload("res://src/domain/core/domain_id.gd")

## Authored mapping from current Wilson-relative perceptual evidence to a semantic
## context cue that may activate learned habits. This consumes perception only and
## does not inspect hidden World state or historical memory directly.

var event_type
var perceived_role: StringName
var cue_id: StringName
var minimum_confidence: float
var required_modality: StringName


func _init(
	p_event_type,
	p_perceived_role: StringName,
	p_cue_id: StringName,
	p_minimum_confidence: float = 0.25,
	p_required_modality: StringName = &""
) -> void:
	assert(p_event_type != null, "PerceivedCueRule requires event type")
	p_event_type.assert_kind(DomainId.Kind.EVENT_DEFINITION)
	assert(p_perceived_role != &"", "PerceivedCueRule requires perceived role")
	assert(p_cue_id != &"", "PerceivedCueRule requires cue id")
	assert(is_finite(p_minimum_confidence) and p_minimum_confidence >= 0.0 and p_minimum_confidence <= 1.0, "minimum confidence must be within [0,1]")
	event_type = p_event_type
	perceived_role = p_perceived_role
	cue_id = p_cue_id
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
