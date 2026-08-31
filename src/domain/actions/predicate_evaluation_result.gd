class_name PredicateEvaluationResult
extends RefCounted

var passed: bool
var diagnostics: Array[String]


func _init(p_passed: bool, p_diagnostics: Array[String] = []) -> void:
	passed = p_passed
	diagnostics = p_diagnostics.duplicate()


static func success(p_diagnostics: Array[String] = []):
	return new(true, p_diagnostics)


static func failure(p_diagnostics: Array[String]):
	return new(false, p_diagnostics)
