class_name RunRuntimeCompositionResult
extends RefCounted

## Explicit admission result for reconstructing application runtime services.

var ok: bool
var code: StringName
var diagnostics: Array[String]
var composition


func _init(
	p_ok: bool,
	p_code: StringName,
	p_diagnostics: Array[String] = [],
	p_composition = null
) -> void:
	ok = p_ok
	code = p_code
	diagnostics = p_diagnostics.duplicate()
	composition = p_composition


static func success(p_composition):
	assert(p_composition != null, "Successful runtime composition requires value")
	return new(true, &"run_runtime_composed", [], p_composition)


static func failure(p_code: StringName, p_diagnostics: Array[String]):
	return new(false, p_code, p_diagnostics)
