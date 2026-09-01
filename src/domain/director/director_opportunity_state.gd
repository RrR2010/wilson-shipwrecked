class_name DirectorOpportunityState
extends RefCounted

enum Lifecycle { ELIGIBLE, ACTIVE, COOLDOWN, EXHAUSTED }

var definition_id: StringName
var lifecycle: int
var cooldown_remaining: float
var activation_count: int

func _init(p_definition_id: StringName, p_lifecycle: int = Lifecycle.ELIGIBLE, p_cooldown_remaining: float = 0.0, p_activation_count: int = 0) -> void:
	assert(p_definition_id != &"", "Director opportunity definition id cannot be empty")
	assert(p_lifecycle >= 0 and p_lifecycle < Lifecycle.size(), "Invalid director opportunity lifecycle")
	assert(p_cooldown_remaining >= 0.0 and is_finite(p_cooldown_remaining), "cooldown remaining must be finite and non-negative")
	assert(p_activation_count >= 0, "activation count must be non-negative")
	definition_id = p_definition_id
	lifecycle = p_lifecycle
	cooldown_remaining = p_cooldown_remaining
	activation_count = p_activation_count
