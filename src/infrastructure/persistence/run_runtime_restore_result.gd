class_name RunRuntimeRestoreResult
extends RefCounted

## Result carrier for restoring authoritative current-run state and the
## reconstructible runtime that consumes it. PlayerProfile remains cross-run
## state and is intentionally not carried here.

var ok: bool
var code: StringName
var diagnostics: Array[String]
var simulation
var runtime
var action_restore_results: Array
var run_lifecycle
var director
var player


func _init(
	p_ok: bool,
	p_code: StringName,
	p_diagnostics: Array[String] = [],
	p_simulation = null,
	p_runtime = null,
	p_action_restore_results: Array = [],
	p_run_lifecycle = null,
	p_director = null,
	p_player = null
) -> void:
	ok = p_ok
	code = p_code
	diagnostics = p_diagnostics.duplicate()
	simulation = p_simulation
	runtime = p_runtime
	action_restore_results = p_action_restore_results.duplicate()
	run_lifecycle = p_run_lifecycle
	director = p_director
	player = p_player


static func success(
	p_simulation,
	p_runtime,
	p_action_restore_results: Array,
	p_run_lifecycle = null,
	p_director = null,
	p_player = null
):
	assert(p_simulation != null, "Successful runtime restore requires simulation state")
	assert(p_runtime != null, "Successful runtime restore requires runtime composition")
	return new(
		true,
		&"run_runtime_restored",
		[],
		p_simulation,
		p_runtime,
		p_action_restore_results,
		p_run_lifecycle,
		p_director,
		p_player
	)


static func failure(p_code: StringName, p_diagnostics: Array[String]):
	return new(false, p_code, p_diagnostics)
