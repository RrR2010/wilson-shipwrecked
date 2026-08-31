class_name PerceivedOpportunityDefinition
extends RefCounted

const DomainId = preload("res://src/domain/core/domain_id.gd")
const DecisionCandidate = preload("res://src/domain/cognition/decision_candidate.gd")

var evidence_predicate: StringName
var intention_id
var scope: int
var base_score: float
var target_role: StringName

func _init(
	p_evidence_predicate: StringName,
	p_intention_id,
	p_scope: int,
	p_base_score: float,
	p_target_role: StringName = &"target"
) -> void:
	assert(p_evidence_predicate != &"", "PerceivedOpportunityDefinition requires evidence predicate")
	assert(p_intention_id != null, "PerceivedOpportunityDefinition requires SemanticIntentionId")
	p_intention_id.assert_kind(DomainId.Kind.SEMANTIC_INTENTION)
	assert(p_scope >= DecisionCandidate.Scope.TACTICAL and p_scope <= DecisionCandidate.Scope.IMMEDIATE_THREAT, "Invalid opportunity scope")
	assert(p_target_role != &"", "PerceivedOpportunityDefinition target role cannot be empty")
	evidence_predicate = p_evidence_predicate
	intention_id = p_intention_id
	scope = p_scope
	base_score = p_base_score
	target_role = p_target_role
