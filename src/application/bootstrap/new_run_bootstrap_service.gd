class_name NewRunBootstrapService
extends RefCounted

const SimulationOwnerBootstrapper = preload("res://src/application/bootstrap/simulation_owner_bootstrapper.gd")
const RunRuntimeComposer = preload("res://src/application/simulation/run_runtime_composer.gd")
const RunLifecycleState = preload("res://src/application/lifecycle/run_lifecycle_state.gd")
const DirectorStateStore = preload("res://src/domain/director/director_state_store.gd")
const PlayerRunState = preload("res://src/domain/player/player_run_state.gd")
const NewRunBootstrapResult = preload("res://src/application/bootstrap/new_run_bootstrap_result.gd")

## Production-facing fresh-run bootstrap boundary.
##
## It deliberately converges on the same SimulationOwnerBootstrapper and
## RunRuntimeComposer used by deterministic development scenarios and restore.
## It owns no gameplay truth; it only creates the authoritative owners that a
## fresh current run requires and returns them as an explicit composition result.

func bootstrap(definition, content):
	assert(definition != null, "bootstrap requires NewRunDefinition")
	assert(content != null, "bootstrap requires sealed ContentRegistry")

	var owner_result = SimulationOwnerBootstrapper.new().bootstrap(definition.simulation)
	if not owner_result.ok:
		return NewRunBootstrapResult.failure(
			owner_result.code,
			owner_result.diagnostics,
			definition.run_id,
			definition.gameplay_seed
		)

	var owners = owner_result.owners
	var runtime_result = RunRuntimeComposer.new().compose(
		owners.entities,
		owners.relations,
		owners.wilson_world_state,
		owners.beliefs,
		owners.current_intention,
		content
	)
	if not runtime_result.ok:
		return NewRunBootstrapResult.failure(
			runtime_result.code,
			runtime_result.diagnostics,
			definition.run_id,
			definition.gameplay_seed
		)

	var run_lifecycle = RunLifecycleState.new(definition.run_id)
	var director = DirectorStateStore.new()
	var player = PlayerRunState.new(definition.initial_god_power, definition.initial_permissions)

	return NewRunBootstrapResult.success(
		definition.run_id,
		definition.gameplay_seed,
		owners,
		runtime_result.composition,
		run_lifecycle,
		director,
		player
	)
