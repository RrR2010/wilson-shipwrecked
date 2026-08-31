class_name DerivedStateInvalidator
extends RefCounted

const SemanticChange = preload("res://src/domain/world/semantic_change.gd")

## Application-layer coordinator for discardable derived state.
## It consumes owner-reported changes and never mutates authoritative gameplay state.
## Optional CompositionDependencyProjection propagates invalidation from components
## to hosts/containers without making the projection an authority owner.

var _physical_profiles
var _composition_dependencies


func _init(physical_profiles, composition_dependencies = null) -> void:
	assert(physical_profiles != null, "DerivedStateInvalidator requires physical profile resolver")
	_physical_profiles = physical_profiles
	_composition_dependencies = composition_dependencies


func apply(change_set) -> Array:
	assert(change_set != null, "apply requires SemanticChangeSet")
	var diagnostics: Array = []
	for change in change_set.changes:
		match change.kind:
			SemanticChange.Kind.PROPERTY:
				var affected = _physical_profiles.invalidate(change.subject, change.semantic_id)
				var dependents = _invalidate_composition_dependents(change.subject)
				diagnostics.append({
					"kind": "property",
					"subject": change.subject.sort_key(),
					"semantic_id": change.semantic_id.sort_key(),
					"affected_outputs": affected,
					"composition_dependents": _sort_keys(dependents),
				})
			SemanticChange.Kind.RELATION:
				_physical_profiles.invalidate(change.subject)
				_physical_profiles.invalidate(change.object)
				var dependent_map: Dictionary = {}
				for dependent in _invalidate_composition_dependents(change.subject):
					dependent_map[dependent.key()] = dependent
				for dependent in _invalidate_composition_dependents(change.object):
					dependent_map[dependent.key()] = dependent
				diagnostics.append({
					"kind": "relation",
					"subject": change.subject.sort_key(),
					"semantic_id": change.semantic_id.sort_key(),
					"object": change.object.sort_key(),
					"composition_dependents": _sort_keys(dependent_map.values()),
				})
	return diagnostics


func _invalidate_composition_dependents(subject) -> Array:
	if _composition_dependencies == null:
		return []
	var dependents: Array = _composition_dependencies.dependents_of(subject)
	for dependent in dependents:
		_physical_profiles.invalidate(dependent)
	return dependents


func _sort_keys(subjects: Array) -> Array[String]:
	var result: Array[String] = []
	for subject in subjects:
		result.append(subject.sort_key())
	result.sort()
	return result
