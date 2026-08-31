class_name DefaultWorldCommandPort
extends RefCounted

const ActionEffect = preload("res://src/domain/actions/action_effect.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const WorldRelation = preload("res://src/domain/world/world_relation.gd")
const WorldEvent = preload("res://src/domain/actions/world_event.gd")
const WorldCommitResult = preload("res://src/domain/world/world_commit_result.gd")
const SemanticChange = preload("res://src/domain/world/semantic_change.gd")
const SemanticChangeSet = preload("res://src/domain/world/semantic_change_set.gd")

## Owner-local mutation boundary for committed ActionOutcome effects.
## Prevalidation simulates relation presence in effect order so the supported
## mutation set is logically transactional without requiring generic rollback.

var _entities
var _relations
var _property_schema_query


func _init(entities, relations, property_schema_query = null) -> void:
	assert(entities != null, "DefaultWorldCommandPort requires EntityStore")
	assert(relations != null, "DefaultWorldCommandPort requires WorldRelationStore")
	_entities = entities
	_relations = relations
	_property_schema_query = property_schema_query


func apply_outcome(outcome):
	assert(outcome != null, "apply_outcome requires ActionOutcome")
	var validation_errors: Array[String] = []
	var relation_shadow: Dictionary = {}
	for effect in outcome.effects:
		_validate_effect(effect, outcome.bindings, validation_errors, relation_shadow)
	if not validation_errors.is_empty():
		return WorldCommitResult.new(false, [], [], validation_errors)

	var mutation_results: Array = []
	var change_set = SemanticChangeSet.new()
	for effect in outcome.effects:
		var result = _apply_effect(effect, outcome.bindings)
		mutation_results.append(result)
		if result.ok:
			_record_change(effect, outcome.bindings, change_set)
		if not result.ok:
			return WorldCommitResult.new(
				false,
				mutation_results,
				[],
				["World mutation failed after successful sequential prevalidation: %s" % String(result.code)],
				change_set
			)

	var event = WorldEvent.new(
		outcome.event_type,
		outcome.action_id,
		outcome.bindings,
		outcome.execution_id
	)
	return WorldCommitResult.new(true, mutation_results, [event], [], change_set)


func _validate_effect(
	effect,
	bindings,
	errors: Array[String],
	relation_shadow: Dictionary
) -> void:
	assert(effect != null, "ActionOutcome effects cannot contain null")
	if not bindings.has(effect.subject_role):
		errors.append("Missing effect subject role: %s" % String(effect.subject_role))
		return
	var subject = bindings.get_subject(effect.subject_role)
	match effect.kind:
		ActionEffect.Kind.SET_PROPERTY:
			if subject.kind != RuntimeWorldRef.Kind.ENTITY:
				errors.append("SET_PROPERTY subject must be an entity")
				return
			if not _entities.has_entity(subject.id):
				errors.append("SET_PROPERTY entity not found: %s" % subject.sort_key())
				return
			if _property_schema_query != null and _property_schema_query.has_method("validate_property_value"):
				if not _property_schema_query.validate_property_value(effect.semantic_id, effect.value):
					errors.append("Invalid property value for %s" % effect.semantic_id.sort_key())
		ActionEffect.Kind.CREATE_RELATION, ActionEffect.Kind.REMOVE_RELATION:
			if not bindings.has(effect.object_role):
				errors.append("Missing effect object role: %s" % String(effect.object_role))
				return
			var relation = _relation_for_effect(effect, bindings)
			var relation_key = relation.key()
			var present: bool
			if relation_shadow.has(relation_key):
				present = bool(relation_shadow[relation_key])
			else:
				present = _relations.get_relation(relation_key) != null
			if effect.kind == ActionEffect.Kind.CREATE_RELATION:
				if present:
					errors.append("Exact relation already exists in sequential batch state: %s" % relation.sort_key())
					return
				relation_shadow[relation_key] = true
			else:
				if not present:
					errors.append("Exact relation does not exist in sequential batch state: %s" % relation.sort_key())
					return
				relation_shadow[relation_key] = false


func _apply_effect(effect, bindings):
	var subject = bindings.get_subject(effect.subject_role)
	match effect.kind:
		ActionEffect.Kind.SET_PROPERTY:
			return _entities.set_property_override(subject.id, effect.semantic_id, effect.value)
		ActionEffect.Kind.CREATE_RELATION:
			return _relations.add_relation(_relation_for_effect(effect, bindings))
		ActionEffect.Kind.REMOVE_RELATION:
			var relation = _relation_for_effect(effect, bindings)
			var stored = _relations.get_relation(relation.key())
			return _relations.remove_relation(stored)
	assert(false, "Unsupported ActionEffect kind")
	return null


func _relation_for_effect(effect, bindings):
	var subject = bindings.get_subject(effect.subject_role)
	var object = bindings.get_subject(effect.object_role)
	return WorldRelation.new(effect.semantic_id, subject, object, effect.value)


func _record_change(effect, bindings, change_set) -> void:
	var subject = bindings.get_subject(effect.subject_role)
	match effect.kind:
		ActionEffect.Kind.SET_PROPERTY:
			change_set.add(SemanticChange.property_change(subject, effect.semantic_id))
		ActionEffect.Kind.CREATE_RELATION, ActionEffect.Kind.REMOVE_RELATION:
			var object = bindings.get_subject(effect.object_role)
			change_set.add(SemanticChange.relation_change(subject, effect.semantic_id, object))
