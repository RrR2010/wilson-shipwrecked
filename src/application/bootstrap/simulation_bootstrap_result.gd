class_name SimulationBootstrapResult
extends RefCounted

var ok: bool
var code: StringName
var diagnostics: Array[String]
var owners

func _init(p_ok: bool, p_code: StringName, p_diagnostics: Array[String] = [], p_owners = null) -> void:
	ok = p_ok
	code = p_code
	diagnostics = p_diagnostics.duplicate()
	owners = p_owners

static func success(p_owners):
	return new(true, &"simulation_bootstrapped", [], p_owners)

static func failure(p_code: StringName, p_diagnostics: Array[String]):
	return new(false, p_code, p_diagnostics, null)
