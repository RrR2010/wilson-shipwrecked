class_name DriveCandidateDefinition
extends RefCounted

const DomainId = preload("res://src/domain/core/domain_id.gd")
const DecisionCandidate = preload("res://src/domain/cognition/decision_candidate.gd")
const DriveState = preload("res://src/domain/cognition/drive_state.gd")

var drive_id: StringName
var intention_id
var base_score: float
var minimum_band: int


func _init(
	p_drive_id: StringName,
	p_intention_id,
	p_base_score: float = 0.0,
	p_minimum_band: int = DriveState.UrgencyBand.PRESSING
) -> void:
	assert(DriveState.DRIVE_IDS.has(p_drive_id), "DriveCandidateDefinition requires a known drive")
	assert(p_intention_id != null, "DriveCandidateDefinition requires SemanticIntentionId")
	p_intention_id.assert_kind(DomainId.Kind.SEMANTIC_INTENTION)
	assert(is_finite(p_base_score), "Drive candidate base score must be finite")
	assert(p_base_score >= -1.0 and p_base_score <= 1.0, "Drive candidate base score must be within [-1,1]")
	assert(p_minimum_band >= DriveState.UrgencyBand.PRESSING and p_minimum_band <= DriveState.UrgencyBand.URGENT, "Drive candidates must require a meaningful urgency band")
	drive_id = p_drive_id
	intention_id = p_intention_id
	base_score = p_base_score
	minimum_band = p_minimum_band
