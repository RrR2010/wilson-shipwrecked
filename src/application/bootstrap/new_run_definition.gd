class_name NewRunDefinition
extends RefCounted

## Durable causes required to create one fresh current run.
##
## This is input metadata for bootstrap, not an authoritative runtime owner.
## Authoritative simulation state is still created by SimulationOwnerBootstrapper;
## run-local lifecycle/player/director owners are created by NewRunBootstrapService.

var run_id: StringName
var gameplay_seed: int
var simulation
var initial_god_power: float
var initial_permissions: Array[StringName]


func _init(
	p_run_id: StringName,
	p_gameplay_seed: int,
	p_simulation,
	p_initial_god_power: float = 0.0,
	p_initial_permissions: Array[StringName] = []
) -> void:
	assert(p_run_id != &"", "NewRunDefinition requires run_id")
	assert(p_simulation != null, "NewRunDefinition requires SimulationBootstrapDefinition")
	assert(is_finite(p_initial_god_power) and p_initial_god_power >= 0.0, "Initial God Power must be finite and non-negative")
	run_id = p_run_id
	gameplay_seed = p_gameplay_seed
	simulation = p_simulation
	initial_god_power = p_initial_god_power
	initial_permissions = p_initial_permissions.duplicate()
	for permission in initial_permissions:
		assert(permission != &"", "NewRunDefinition permission cannot be empty")
