class_name PerceivedOpportunityDefinition
extends RefCounted

const DomainId = preload("res://src/domain/core/domain_id.gd")
const EpistemicClaim = preload("res://src/domain/cognition/epistemic_claim.gd")
const DecisionCandidate = preload("res://src/domain/cognition/decision_candidate.gd")

var claim_kind: int
var semantic_id
var intention_id
var scope: int
var base_score: float
var target_role: StringName


func _init(
	p_claim_kind: int,
	p_semantic_id,
	p_intention_id,
	p_scope: int,
	p_base_score: float,
	p_target_role: StringName = &"target"
) -> void:
	assert(p_claim_kind >= 0 and p_claim_kind < EpistemicClaim.Kind.size(), "Invalid opportunity claim kind")
	assert(p_intention_id != null, "PerceivedOpportunityDefinition requires SemanticIntentionId")
	p_intention_id.assert_kind(DomainId.Kind.SEMANTIC_INTENTION)
	assert(p_scope >= DecisionCandidate.Scope.TACTICAL and p_scope <= DecisionCandidate.Scope.IMMEDIATE_THREAT, "Invalid opportunity scope")
	assert(p_target_role != &"", "PerceivedOpportunityDefinition target role cannot be empty")
	claim_kind = p_claim_kind
	semantic_id = p_semantic_id
	if semantic_id != null:
		match claim_kind:
			EpistemicClaim.Kind.PROPERTY: semantic_id.assert_kind(DomainId.Kind.PROPERTY)
			EpistemicClaim.Kind.RELATION: semantic_id.assert_kind(DomainId.Kind.RELATION_TYPE)
			EpistemicClaim.Kind.EVENT: semantic_id.assert_kind(DomainId.Kind.EVENT_DEFINITION)
	intention_id = p_intention_id
	scope = p_scope
	base_score = p_base_score
	target_role = p_target_role


func matches(claim) -> bool:
	if claim == null or claim.kind != claim_kind:
		return false
	return semantic_id == null or semantic_id.equals(claim.semantic_id)
