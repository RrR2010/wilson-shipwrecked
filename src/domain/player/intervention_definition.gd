class_name InterventionDefinition
extends RefCounted

var id: StringName
var permission: StringName
var god_power_cost: float

func _init(p_id: StringName, p_permission: StringName, p_god_power_cost: float) -> void:
	assert(p_id != &"", "Intervention id cannot be empty")
	assert(p_god_power_cost >= 0.0 and is_finite(p_god_power_cost), "Intervention cost must be finite and non-negative")
	id = p_id
	permission = p_permission
	god_power_cost = p_god_power_cost
