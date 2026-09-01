class_name PlayerSuggestion
extends RefCounted

const DomainId = preload("res://src/domain/core/domain_id.gd")

var intention_id
var bindings
var bias: float
var remaining_insistence: int

func _init(p_intention_id, p_bindings, p_bias: float = 0.2, p_remaining_insistence: int = 1) -> void:
	p_intention_id.assert_kind(DomainId.Kind.SEMANTIC_INTENTION)
	assert(p_bindings != null, "PlayerSuggestion requires bindings")
	assert(p_bias >= -0.25 and p_bias <= 0.25, "Suggestion bias must be within [-0.25,0.25]")
	assert(p_remaining_insistence >= 0, "remaining insistence must be non-negative")
	intention_id = p_intention_id
	bindings = p_bindings.duplicate_binding()
	bias = p_bias
	remaining_insistence = p_remaining_insistence

func key() -> String:
	return "%s|%s" % [intention_id.sort_key(), bindings.stable_key()]
