class_name PhysicalConsequenceWorldAdvanceDecorator
extends RefCounted

const WorldAdvanceResult = preload("res://src/application/simulation/world_advance_result.gd")

## Application composition boundary. The wrapped World advance remains authoritative
## for elapsed-time progression; typed engine observations are admitted separately
## and merged only after authored consequence resolution.

var _inner
var _physical_consequence_resolver


func _init(inner, physical_consequence_resolver) -> void:
	assert(inner != null and inner.has_method("advance"), "Physical consequence decorator requires World advance service")
	assert(physical_consequence_resolver != null and physical_consequence_resolver.has_method("resolve"), "Physical consequence decorator requires resolver")
	_inner = inner
	_physical_consequence_resolver = physical_consequence_resolver


func advance(elapsed: float, step):
	var inner_result = _inner.advance(elapsed, step)
	assert(inner_result != null, "Wrapped World advance must return WorldAdvanceResult")
	var events: Array = inner_result.events.duplicate()
	var diagnostics: Array[String] = inner_result.diagnostics.duplicate()
	var observations: Array = []
	if step != null and step.physical_observations != null:
		observations = step.physical_observations
	var physical_events: Array = _physical_consequence_resolver.resolve(observations, step.step_id)
	events.append_array(physical_events)
	if not observations.is_empty():
		diagnostics.append("Physical observations=%d admitted_events=%d" % [observations.size(), physical_events.size()])
	return WorldAdvanceResult.new(events, diagnostics, inner_result.change_set)
