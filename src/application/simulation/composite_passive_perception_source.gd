class_name CompositePassivePerceptionSource
extends RefCounted

const PerceptionResult = preload("res://src/domain/cognition/perception_result.gd")

var _sources: Array


func _init(sources: Array) -> void:
	_sources = sources.duplicate()


func collect(step = null):
	var events: Array = []
	var evidence: Array = []
	var diagnostics: Array[String] = []
	for source in _sources:
		var part = source.collect(step)
		events.append_array(part.observed_events)
		evidence.append_array(part.evidence)
		diagnostics.append_array(part.diagnostics)
	return PerceptionResult.new(events, evidence, diagnostics)


func notify_semantic_changes(changes) -> void:
	for source in _sources:
		if source.has_method("notify_semantic_changes"):
			source.notify_semantic_changes(changes)
