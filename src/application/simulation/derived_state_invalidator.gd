class_name DerivedStateInvalidator
extends RefCounted

const SemanticChange = preload("res://src/domain/world/semantic_change.gd")

## Application-layer coordinator for discardable derived state.
## It consumes owner-reported changes and never mutates authoritative gameplay state.

var _physical_profiles

func _init(physical_profiles) -> void:
	assert(physical_profiles != null, "DerivedStateInvalidator requires physical profile resolver")
	_physical_profiles = physical_profiles

func apply(change_set) -> Array:
	assert(change_set != null, "apply requires SemanticChangeSet")
	var diagnostics: Array = []
	for change in change_set.changes:
		match change.kind:
			SemanticChange.Kind.PROPERTY:
				var affected = _physical_profiles.invalidate(change.subject, change.semantic_id)
				diagnostics.append({
					"kind": "property",
					"subject": change.subject.sort_key(),
					"semantic_id": change.semantic_id.sort_key(),
					"affected_outputs": affected,
				})
			SemanticChange.Kind.RELATION:
				# Conservative invalidation for future relation-aware composition rules.
				_physical_profiles.invalidate(change.subject)
				_physical_profiles.invalidate(change.object)
				diagnostics.append({
					"kind": "relation",
					"subject": change.subject.sort_key(),
					"semantic_id": change.semantic_id.sort_key(),
					"object": change.object.sort_key(),
				})
	return diagnostics
