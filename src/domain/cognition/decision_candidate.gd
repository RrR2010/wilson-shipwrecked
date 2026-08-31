class_name DecisionCandidate
extends RefCounted

const DomainId = preload("res://src/domain/core/domain_id.gd")

enum Scope { TACTICAL, INTENTIONAL, IMMEDIATE_THREAT }

var intention_id
var bindings
var scope: int
var base_score: float
var salience_score: float
var belief_score: float
var urgency_score: float
var external_bias: float
var provenance: Dictionary

func _init(
	p_intention_id,
	p_bindings,
	p_scope: int,
	p_base_score: float,
	p_salience_score: float = 0.0,
	p_belief_score: float = 0.0,
	p_urgency_score: float = 0.0,
	p_external_bias: float = 0.0,
	p_provenance: Dictionary = {}
) -> void:
	assert(p_intention_id != null, "DecisionCandidate requires SemanticIntentionId")
	p_intention_id.assert_kind(DomainId.Kind.SEMANTIC_INTENTION)
	assert(p_bindings != null, "DecisionCandidate requires bindings")
	assert(p_scope >= Scope.TACTICAL and p_scope <= Scope.IMMEDIATE_THREAT, "Invalid DecisionCandidate scope")
	assert(p_salience_score >= 0.0 and p_salience_score <= 1.0, "salience_score must be within [0,1]")
	assert(p_belief_score >= 0.0 and p_belief_score <= 1.0, "belief_score must be within [0,1]")
	assert(p_urgency_score >= 0.0 and p_urgency_score <= 1.0, "urgency_score must be within [0,1]")
	assert(p_external_bias >= -0.25 and p_external_bias <= 0.25, "external_bias must be within [-0.25,0.25]")
	intention_id = p_intention_id
	bindings = p_bindings
	scope = p_scope
	base_score = p_base_score
	salience_score = p_salience_score
	belief_score = p_belief_score
	urgency_score = p_urgency_score
	external_bias = p_external_bias
	provenance = p_provenance.duplicate(true)

func total_score() -> float:
	return base_score + salience_score + belief_score + urgency_score + external_bias

func stable_key() -> String:
	return "%s|%s" % [intention_id.sort_key(), bindings.stable_key()]
