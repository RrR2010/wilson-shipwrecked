class_name NewRunBootstrapResult
extends RefCounted

var ok: bool
var code: StringName
var diagnostics: Array[String]
var run_id: StringName
var gameplay_seed: int
var owners
var runtime
var run_lifecycle
var director
var player


func _init(
	p_ok: bool,
	p_code: StringName,
	p_diagnostics: Array[String] = [],
	p_run_id: StringName = &"",
	p_gameplay_seed: int = 0,
	p_owners = null,
	p_runtime = null,
	p_run_lifecycle = null,
	p_director = null,
	p_player = null
) -> void:
	ok = p_ok
	code = p_code
	diagnostics = p_diagnostics.duplicate()
	run_id = p_run_id
	gameplay_seed = p_gameplay_seed
	owners = p_owners
	runtime = p_runtime
	run_lifecycle = p_run_lifecycle
	director = p_director
	player = p_player


static func success(
	p_run_id: StringName,
	p_gameplay_seed: int,
	p_owners,
	p_runtime,
	p_run_lifecycle,
	p_director,
	p_player
):
	return new(
		true,
		&"new_run_bootstrapped",
		[],
		p_run_id,
		p_gameplay_seed,
		p_owners,
		p_runtime,
		p_run_lifecycle,
		p_director,
		p_player
	)


static func failure(
	p_code: StringName,
	p_diagnostics: Array[String],
	p_run_id: StringName = &"",
	p_gameplay_seed: int = 0
):
	return new(false, p_code, p_diagnostics, p_run_id, p_gameplay_seed)
