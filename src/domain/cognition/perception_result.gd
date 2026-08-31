class_name PerceptionResult
extends RefCounted

var observed_events: Array
var evidence: Array
var diagnostics: Array[String]


func _init(p_observed_events: Array = [], p_evidence: Array = [], p_diagnostics: Array[String] = []) -> void:
	observed_events = p_observed_events.duplicate()
	evidence = p_evidence.duplicate()
	diagnostics = p_diagnostics.duplicate()
