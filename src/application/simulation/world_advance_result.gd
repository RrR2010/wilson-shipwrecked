class_name WorldAdvanceResult
extends RefCounted

## Explicit result from authoritative world/process progression.
## Events here are already committed facts and may enter perception immediately.

var events: Array
var diagnostics: Array[String]


func _init(p_events: Array = [], p_diagnostics: Array[String] = []) -> void:
	events = p_events.duplicate()
	diagnostics = p_diagnostics.duplicate()
