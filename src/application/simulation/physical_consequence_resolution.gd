class_name PhysicalConsequenceResolution
extends RefCounted

const SemanticChangeSet = preload("res://src/domain/world/semantic_change_set.gd")

## Result of admitting non-authoritative engine observations into authoritative
## World consequences. Events and changes here exist only after admission/mutation.

var events: Array
var change_set
var diagnostics: Array[String]


func _init(
	p_events: Array = [],
	p_change_set = null,
	p_diagnostics: Array[String] = []
) -> void:
	events = p_events.duplicate()
	change_set = p_change_set if p_change_set != null else SemanticChangeSet.new()
	diagnostics = p_diagnostics.duplicate()
