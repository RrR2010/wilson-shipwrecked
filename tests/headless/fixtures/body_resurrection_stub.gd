class_name BodyResurrectionStub
extends RefCounted

const MutationResult = preload("res://src/domain/core/mutation_result.gd")

var should_accept: bool = true
var calls: int = 0
var last_run_id: StringName = &""


func resurrect_wilson(run_id: StringName):
	calls += 1
	last_run_id = run_id
	if should_accept:
		return MutationResult.success(&"physical_resurrection_committed")
	return MutationResult.failure(&"physical_resurrection_rejected", ["fixture rejection"])
