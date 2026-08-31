class_name WorldCommitResult
extends RefCounted

const SemanticChangeSet = preload("res://src/domain/world/semantic_change_set.gd")

var ok: bool
var mutation_results: Array
var events: Array
var diagnostics: Array[String]
var change_set


func _init(
	p_ok: bool,
	p_mutation_results: Array,
	p_events: Array,
	p_diagnostics: Array[String] = [],
	p_change_set = null
) -> void:
	ok = p_ok
	mutation_results = p_mutation_results.duplicate()
	events = p_events.duplicate()
	diagnostics = p_diagnostics.duplicate()
	change_set = p_change_set if p_change_set != null else SemanticChangeSet.new()
