class_name ProductNewRunParameters
extends RefCounted

## Product-facing inputs used to select and deterministically generate one fresh run.
##
## These values are upstream bootstrap metadata, not runtime authority.

var run_id: StringName
var gameplay_seed: int
var generation_profile_id: StringName
var initial_god_power: float
var initial_permissions: Array[StringName]


func _init(
	p_run_id: StringName,
	p_gameplay_seed: int,
	p_generation_profile_id: StringName,
	p_initial_god_power: float = 0.0,
	p_initial_permissions: Array[StringName] = []
) -> void:
	assert(p_run_id != &"", "ProductNewRunParameters requires run_id")
	assert(p_generation_profile_id != &"", "ProductNewRunParameters requires generation_profile_id")
	assert(is_finite(p_initial_god_power) and p_initial_god_power >= 0.0, "Initial God Power must be finite and non-negative")
	run_id = p_run_id
	gameplay_seed = p_gameplay_seed
	generation_profile_id = p_generation_profile_id
	initial_god_power = p_initial_god_power
	initial_permissions = p_initial_permissions.duplicate()
	for permission in initial_permissions:
		assert(permission != &"", "ProductNewRunParameters permission cannot be empty")
