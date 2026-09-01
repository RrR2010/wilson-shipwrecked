class_name WorldAdvanceResult
extends RefCounted

const SemanticChangeSet = preload("res://src/domain/world/semantic_change_set.gd")

## Explicit result from authoritative world/process progression.
## Events here are already committed facts and may enter perception immediately.
## change_set carries committed World changes requiring derived-state invalidation.

var events: Array
var diagnostics: Array[String]
var change_set


func _init(
	p_events: Array = [],
	p_diagnostics: Array[String] = [],
	p_change_set = null
) -> void:
	events = p_events.duplicate()
	diagnostics = p_diagnostics.duplicate()
	change_set = p_change_set if p_change_set != null else SemanticChangeSet.new()
