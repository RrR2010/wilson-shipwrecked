class_name WorldCommitResult
extends RefCounted

var ok: bool
var mutation_results: Array
var events: Array
var diagnostics: Array[String]


func _init(p_ok: bool, p_mutation_results: Array, p_events: Array, p_diagnostics: Array[String] = []) -> void:
	ok = p_ok
	mutation_results = p_mutation_results.duplicate()
	events = p_events.duplicate()
	diagnostics = p_diagnostics.duplicate()
