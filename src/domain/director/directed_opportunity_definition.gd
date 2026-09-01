class_name DirectedOpportunityDefinition
extends RefCounted

const DomainId = preload("res://src/domain/core/domain_id.gd")

var id: StringName
var intention_id
var bindings
var candidate_bias: float
var cooldown_seconds: float
var max_activations: int

func _init(p_id: StringName, p_intention_id, p_bindings, p_candidate_bias: float = 0.15, p_cooldown_seconds: float = 30.0, p_max_activations: int = 1) -> void:
	assert(p_id != &"", "Directed opportunity id cannot be empty")
	p_intention_id.assert_kind(DomainId.Kind.SEMANTIC_INTENTION)
	assert(p_bindings != null, "Directed opportunity requires bindings")
	assert(p_candidate_bias >= -0.25 and p_candidate_bias <= 0.25, "candidate bias must be within [-0.25,0.25]")
	assert(p_cooldown_seconds >= 0.0 and is_finite(p_cooldown_seconds), "cooldown must be finite and non-negative")
	assert(p_max_activations >= 1, "max activations must be positive")
	id = p_id
	intention_id = p_intention_id
	bindings = p_bindings.duplicate_binding()
	candidate_bias = p_candidate_bias
	cooldown_seconds = p_cooldown_seconds
	max_activations = p_max_activations
