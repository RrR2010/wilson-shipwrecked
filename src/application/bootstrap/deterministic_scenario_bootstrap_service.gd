class_name DeterministicScenarioBootstrapService
extends RefCounted

const SimulationOwnerBootstrapper = preload("res://src/application/bootstrap/simulation_owner_bootstrapper.gd")
const RunRuntimeComposer = preload("res://src/application/simulation/run_runtime_composer.gd")
const DeterministicScenarioBootstrapResult = preload("res://src/application/bootstrap/deterministic_scenario_bootstrap_result.gd")

## Development scenario adapter over the normal bootstrap/composition path.
## Scenario names and seeds remain development metadata, not gameplay identity.

func bootstrap(definition, content):
	assert(definition != null, "bootstrap requires DeterministicScenarioDefinition")
	assert(content != null, "bootstrap requires sealed ContentRegistry")
	var owner_result = SimulationOwnerBootstrapper.new().bootstrap(definition.simulation)
	if not owner_result.ok:
		return DeterministicScenarioBootstrapResult.failure(
			owner_result.code,
			owner_result.diagnostics,
			definition.scenario_name,
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
		return DeterministicScenarioBootstrapResult.failure(
			runtime_result.code,
			runtime_result.diagnostics,
			definition.scenario_name,
			definition.gameplay_seed
		)
	return DeterministicScenarioBootstrapResult.success(
		definition.scenario_name,
		definition.gameplay_seed,
		owners,
		runtime_result.composition
	)
