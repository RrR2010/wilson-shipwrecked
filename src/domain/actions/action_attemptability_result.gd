class_name ActionAttemptabilityResult
extends RefCounted

var attemptable: bool
var code: StringName
var diagnostics: Array[String]


func _init(p_attemptable: bool, p_code: StringName, p_diagnostics: Array[String] = []) -> void:
	attemptable = p_attemptable
	code = p_code
	diagnostics = p_diagnostics.duplicate()


static func allowed(p_diagnostics: Array[String] = []):
	return new(true, &"attemptable", p_diagnostics)


static func rejected(p_code: StringName, p_diagnostics: Array[String]):
	return new(false, p_code, p_diagnostics)
