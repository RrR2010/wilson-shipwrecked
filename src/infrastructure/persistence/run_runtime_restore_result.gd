class_name RunRuntimeRestoreResult
extends RefCounted

## Result carrier for restoring authoritative simulation owners and the
## content-dependent reconstructible runtime that consumes them.
## It owns no gameplay truth.

var ok: bool
var code: StringName
var diagnostics: Array[String]
var simulation
var runtime
var action_restore_results: Array


func _init(
	p_ok: bool,
	p_code: StringName,
	p_diagnostics: Array[String] = [],
	p_simulation = null,
	p_runtime = null,
	p_action_restore_results: Array = []
) -> void:
	ok = p_ok
	code = p_code
	diagnostics = p_diagnostics.duplicate()
	simulation = p_simulation
	runtime = p_runtime
	action_restore_results = p_action_restore_results.duplicate()


static func success(p_simulation, p_runtime, p_action_restore_results: Array):
	assert(p_simulation != null, "Successful runtime restore requires simulation state")
	assert(p_runtime != null, "Successful runtime restore requires runtime composition")
	return new(
		true,
		&"run_runtime_restored",
		[],
		p_simulation,
		p_runtime,
		p_action_restore_results
	)


static func failure(p_code: StringName, p_diagnostics: Array[String]):
	return new(false, p_code, p_diagnostics)
