class_name ProductNewRunGenerationResult
extends RefCounted

var ok: bool
var code: StringName
var definition
var diagnostics: Array[String]


func _init(p_ok: bool, p_code: StringName, p_definition = null, p_diagnostics: Array[String] = []) -> void:
	ok = p_ok
	code = p_code
	definition = p_definition
	diagnostics = p_diagnostics.duplicate()


static func success(p_definition):
	return new(true, &"product_new_run_generated", p_definition, [])


static func failure(p_code: StringName, p_diagnostics: Array[String] = []):
	assert(p_code != &"", "ProductNewRunGenerationResult failure code cannot be empty")
	return new(false, p_code, null, p_diagnostics)
