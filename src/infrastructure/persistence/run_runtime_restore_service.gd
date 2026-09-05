class_name RunRuntimeRestoreService
extends RefCounted

const SimulationSnapshotService = preload("res://src/infrastructure/persistence/simulation_snapshot_service.gd")
const ActionExecutionSnapshotService = preload("res://src/infrastructure/persistence/action_execution_snapshot_service.gd")
const RunRuntimeComposer = preload("res://src/application/simulation/run_runtime_composer.gd")
const RunRuntimeRestoreResult = preload("res://src/infrastructure/persistence/run_runtime_restore_result.gd")

## Application-facing restore boundary for a reconstructible run runtime.
##
## Simulation owners are restored first through the common owner bootstrap path.
## Runtime services are then composed from those owners plus sealed authored
## content. Only after the fresh ActionExecutionService exists are active action
## executions rehydrated against authored action/resolution definitions.


func restore(
	simulation_snapshot: Dictionary,
	action_execution_snapshot: Dictionary,
	content
):
	assert(content != null, "RunRuntimeRestoreService.restore requires ContentRegistry")

	var simulation = SimulationSnapshotService.new().restore(simulation_snapshot)
	if simulation == null:
		return RunRuntimeRestoreResult.failure(
			&"simulation_restore_failed",
			["Simulation snapshot did not produce restored authoritative state"]
		)

	var composition_result = RunRuntimeComposer.new().compose(
		simulation.entities,
		simulation.relations,
		simulation.wilson_world_state,
		simulation.beliefs,
		simulation.current_intention,
		content
	)
	if not composition_result.ok:
		return RunRuntimeRestoreResult.failure(
			composition_result.code,
			composition_result.diagnostics
		)

	var runtime = composition_result.composition
	var action_restore_results = ActionExecutionSnapshotService.new().restore(
		action_execution_snapshot,
		runtime.action_execution,
		content
	)
	for restore_result in action_restore_results:
		if restore_result == null:
			return RunRuntimeRestoreResult.failure(
				&"action_execution_restore_failed",
				["Action execution restore returned null result"]
			)
		if not restore_result.ok:
			return RunRuntimeRestoreResult.failure(
				restore_result.code,
				restore_result.diagnostics
			)

	return RunRuntimeRestoreResult.success(
		simulation,
		runtime,
		action_restore_results
	)
