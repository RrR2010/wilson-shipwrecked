class_name DeterministicScenarioBootstrapResult
extends RefCounted

var ok: bool
var code: StringName
var diagnostics: Array[String]
var scenario_name: StringName
var gameplay_seed: int
var owners
var runtime

func _init(p_ok: bool, p_code: StringName, p_diagnostics: Array[String] = [], p_scenario_name: StringName = &"", p_gameplay_seed: int = 0, p_owners = null, p_runtime = null) -> void:
	ok = p_ok
	code = p_code
	diagnostics = p_diagnostics.duplicate()
	scenario_name = p_scenario_name
	gameplay_seed = p_gameplay_seed
	owners = p_owners
	runtime = p_runtime

static func success(p_scenario_name: StringName, p_gameplay_seed: int, p_owners, p_runtime):
	return new(true, &"deterministic_scenario_bootstrapped", [], p_scenario_name, p_gameplay_seed, p_owners, p_runtime)

static func failure(p_code: StringName, p_diagnostics: Array[String], p_scenario_name: StringName = &"", p_gameplay_seed: int = 0):
	return new(false, p_code, p_diagnostics, p_scenario_name, p_gameplay_seed, null, null)
