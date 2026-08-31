class_name MutationResult
extends RefCounted

## Small shared envelope for owner-local mutation commands.
## Public domain operations should introduce narrower result types when their
## diagnostics become semantically richer than this generic command result.

var ok: bool
var code: StringName
var diagnostics: Array[String]
var value: Variant


func _init(
	p_ok: bool,
	p_code: StringName,
	p_diagnostics: Array[String] = [],
	p_value: Variant = null
) -> void:
	ok = p_ok
	code = p_code
	diagnostics = p_diagnostics.duplicate()
	value = p_value


func _to_string() -> String:
	return "MutationResult(ok=%s, code=%s, diagnostics=%s)" % [ok, String(code), diagnostics]


static func success(p_code: StringName = &"ok", p_value: Variant = null):
	return new(true, p_code, [], p_value)


static func failure(p_code: StringName, p_diagnostics: Array[String]):
	return new(false, p_code, p_diagnostics)
