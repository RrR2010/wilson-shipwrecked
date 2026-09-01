class_name ActorProfileDefinition
extends RefCounted

var id: StringName
var default_mode: StringName
var decision_interval: float


func _init(p_id: StringName, p_default_mode: StringName = &"idle", p_decision_interval: float = 1.0) -> void:
	assert(p_id != &"", "ActorProfileDefinition requires id")
	assert(p_default_mode != &"", "ActorProfileDefinition requires default mode")
	assert(is_finite(p_decision_interval) and p_decision_interval > 0.0, "Actor decision interval must be finite and positive")
	id = p_id
	default_mode = p_default_mode
	decision_interval = p_decision_interval
