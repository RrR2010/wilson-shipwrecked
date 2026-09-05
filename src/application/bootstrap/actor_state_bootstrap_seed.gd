class_name ActorStateBootstrapSeed
extends RefCounted

var actor
var profile_id: StringName
var mode: StringName
var decision_cooldown: float
var last_rule_id: StringName

func _init(
	p_actor,
	p_profile_id: StringName,
	p_mode: StringName,
	p_decision_cooldown: float = 0.0,
	p_last_rule_id: StringName = &""
) -> void:
	assert(p_actor != null, "ActorStateBootstrapSeed requires actor")
	assert(p_profile_id != &"", "ActorStateBootstrapSeed requires profile id")
	assert(p_mode != &"", "ActorStateBootstrapSeed requires mode")
	assert(is_finite(p_decision_cooldown) and p_decision_cooldown >= 0.0, "Actor decision cooldown must be finite and non-negative")
	actor = p_actor
	profile_id = p_profile_id
	mode = p_mode
	decision_cooldown = p_decision_cooldown
	last_rule_id = p_last_rule_id
