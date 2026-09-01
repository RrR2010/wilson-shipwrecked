class_name DefensiveCandidateDefinition
extends RefCounted

const DomainId = preload("res://src/domain/core/domain_id.gd")

var intention_id
var base_score: float


func _init(p_intention_id, p_base_score: float) -> void:
	assert(p_intention_id != null, "DefensiveCandidateDefinition requires SemanticIntentionId")
	p_intention_id.assert_kind(DomainId.Kind.SEMANTIC_INTENTION)
	assert(is_finite(p_base_score) and p_base_score >= 0.0 and p_base_score <= 1.0, "defensive base score must be within [0,1]")
	intention_id = p_intention_id
	base_score = p_base_score
