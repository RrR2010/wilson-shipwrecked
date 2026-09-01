class_name RunLifecycleState
extends RefCounted

const MutationResult = preload("res://src/domain/core/mutation_result.gd")

## Current-run lifecycle only. Physical Wilson body truth remains World-owned.
## DEAD here means the run has admitted a grounded death transition; it is not
## a replacement for body/vitality state.

enum Lifecycle { ACTIVE, DEAD, ENDED }

var run_id: StringName
var lifecycle: int = Lifecycle.ACTIVE
var death_count: int = 0
var resurrection_count: int = 0
var last_death_cause: StringName = &""
var end_reason: StringName = &""


func _init(p_run_id: StringName, p_lifecycle: int = Lifecycle.ACTIVE) -> void:
	assert(p_run_id != &"", "RunLifecycleState requires run_id")
	assert(p_lifecycle >= Lifecycle.ACTIVE and p_lifecycle <= Lifecycle.ENDED, "Invalid run lifecycle")
	run_id = p_run_id
	lifecycle = p_lifecycle


func mark_dead(cause: StringName):
	if lifecycle != Lifecycle.ACTIVE:
		return MutationResult.failure(&"run_not_active", ["Only an active run can admit death"])
	if cause == &"":
		return MutationResult.failure(&"missing_death_cause", ["Death requires a semantic cause id"])
	lifecycle = Lifecycle.DEAD
	death_count += 1
	last_death_cause = cause
	return MutationResult.success(&"run_dead")


func mark_resurrected():
	if lifecycle != Lifecycle.DEAD:
		return MutationResult.failure(&"run_not_dead", ["Only a dead run can be resurrected"])
	lifecycle = Lifecycle.ACTIVE
	resurrection_count += 1
	return MutationResult.success(&"run_resurrected")


func end_run(reason: StringName):
	if lifecycle == Lifecycle.ENDED:
		return MutationResult.failure(&"run_already_ended", ["Run is already ended"])
	if reason == &"":
		return MutationResult.failure(&"missing_end_reason", ["EndRun requires a semantic reason id"])
	lifecycle = Lifecycle.ENDED
	end_reason = reason
	return MutationResult.success(&"run_ended")
