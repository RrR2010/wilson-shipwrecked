class_name PhysicalConsequenceWorldAdvanceDecorator
extends RefCounted

const PhysicalConsequenceResolution = preload("res://src/application/simulation/physical_consequence_resolution.gd")
const WorldAdvanceResult = preload("res://src/application/simulation/world_advance_result.gd")

## Application composition boundary. The wrapped World advance remains authoritative
## for elapsed-time progression; typed engine observations are admitted separately
## and merged only after authored consequence resolution.

var _inner
var _physical_consequence_resolver


func _init(inner, physical_consequence_resolver) -> void:
	assert(inner != null and inner.has_method("advance"), "Physical consequence decorator requires World advance service")
	assert(
		physical_consequence_resolver != null and (
			physical_consequence_resolver.has_method("resolve_result") or physical_consequence_resolver.has_method("resolve")
		),
		"Physical consequence decorator requires resolver"
	)
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

	var physical_resolution
	if _physical_consequence_resolver.has_method("resolve_result"):
		physical_resolution = _physical_consequence_resolver.resolve_result(observations, step.step_id)
	else:
		physical_resolution = PhysicalConsequenceResolution.new(
			_physical_consequence_resolver.resolve(observations, step.step_id)
		)
	assert(physical_resolution != null, "Physical consequence resolver must return a resolution")

	events.append_array(physical_resolution.events)
	diagnostics.append_array(physical_resolution.diagnostics)
	var combined_changes = inner_result.change_set.duplicate_set()
	for change in physical_resolution.change_set.changes:
		combined_changes.add(change)
	if not observations.is_empty():
		diagnostics.append("Physical observations=%d admitted_events=%d committed_changes=%d" % [
			observations.size(),
			physical_resolution.events.size(),
			physical_resolution.change_set.changes.size(),
		])
	return WorldAdvanceResult.new(events, diagnostics, combined_changes)
