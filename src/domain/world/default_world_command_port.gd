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
## Validates the entire effect batch before applying it so one outcome cannot
## intentionally leave a partially applied World mutation set.

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
	for effect in outcome.effects:
		_validate_effect(effect, outcome.bindings, validation_errors)
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
				["World mutation failed after successful prevalidation: %s" % String(result.code)],
				change_set
			)

	var event = WorldEvent.new(
		outcome.event_type,
		outcome.action_id,
		outcome.bindings,
		outcome.execution_id
	)
	return WorldCommitResult.new(true, mutation_results, [event], [], change_set)


func _validate_effect(effect, bindings, errors: Array[String]) -> void:
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
			var object = bindings.get_subject(effect.object_role)
			var existing: Array = _relations.find_relations(effect.semantic_id, subject, object)
			if effect.kind == ActionEffect.Kind.CREATE_RELATION and not existing.is_empty():
				errors.append("Relation already exists: %s" % String(effect.semantic_id.value))
			if effect.kind == ActionEffect.Kind.REMOVE_RELATION and existing.is_empty():
				errors.append("Relation does not exist: %s" % String(effect.semantic_id.value))


func _apply_effect(effect, bindings):
	var subject = bindings.get_subject(effect.subject_role)
	match effect.kind:
		ActionEffect.Kind.SET_PROPERTY:
			return _entities.set_property_override(subject.id, effect.semantic_id, effect.value)
		ActionEffect.Kind.CREATE_RELATION:
			var object = bindings.get_subject(effect.object_role)
			return _relations.add_relation(WorldRelation.new(effect.semantic_id, subject, object, effect.value))
		ActionEffect.Kind.REMOVE_RELATION:
			var object = bindings.get_subject(effect.object_role)
			var existing: Array = _relations.find_relations(effect.semantic_id, subject, object)
			return _relations.remove_relation(existing[0])
	assert(false, "Unsupported ActionEffect kind")
	return null


func _record_change(effect, bindings, change_set) -> void:
	var subject = bindings.get_subject(effect.subject_role)
	match effect.kind:
		ActionEffect.Kind.SET_PROPERTY:
			change_set.add(SemanticChange.property_change(subject, effect.semantic_id))
		ActionEffect.Kind.CREATE_RELATION, ActionEffect.Kind.REMOVE_RELATION:
			var object = bindings.get_subject(effect.object_role)
			change_set.add(SemanticChange.relation_change(subject, effect.semantic_id, object))
