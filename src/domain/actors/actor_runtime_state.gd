class_name ActorRuntimeState
extends RefCounted

const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")

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
	assert(p_actor != null and p_actor.kind == RuntimeWorldRef.Kind.ENTITY, "ActorRuntimeState requires entity actor")
	assert(p_profile_id != &"" and p_mode != &"", "ActorRuntimeState ids cannot be empty")
	assert(is_finite(p_decision_cooldown) and p_decision_cooldown >= 0.0, "Actor cooldown must be finite and non-negative")
	actor = p_actor
	profile_id = p_profile_id
	mode = p_mode
	decision_cooldown = p_decision_cooldown
	last_rule_id = p_last_rule_id
