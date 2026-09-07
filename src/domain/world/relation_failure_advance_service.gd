class_name RelationFailureAdvanceService
extends RefCounted

const SemanticChange = preload("res://src/domain/world/semantic_change.gd")
const SemanticChangeSet = preload("res://src/domain/world/semantic_change_set.gd")

## Evaluates authored relation-failure thresholds against authoritative subject
## properties and removes failed relations through the relation owner.
##
## This intentionally reads authoritative World properties only. Derived-property
## failure criteria would require an explicit mid-step invalidation boundary before
## consuming freshly-mutated derived state.

var _world_query
var _relations
var _definitions: Array = []


func _init(world_query, relation_store, definitions: Array) -> void:
	assert(world_query != null, "RelationFailureAdvanceService requires WorldQuery")
	assert(relation_store != null, "RelationFailureAdvanceService requires WorldRelationStore")
	_world_query = world_query
	_relations = relation_store
	var seen: Dictionary = {}
	for definition in definitions:
		assert(definition != null, "Relation failure definitions cannot contain null")
		assert(not seen.has(definition.id), "Duplicate relation failure definition: %s" % String(definition.id))
		seen[definition.id] = true
		_definitions.append(definition)
	_definitions.sort_custom(func(a, b): return String(a.id) < String(b.id))


func advance() -> Dictionary:
	var change_set = SemanticChangeSet.new()
	var transitions: Array = []
	var diagnostics: Array[String] = []
	for definition in _definitions:
		var candidates: Array = _world_query.find_relations(definition.relation_type, null, null)
		for relation in candidates:
			if definition.qualifier != null and relation.qualifier != definition.qualifier:
				continue
			var value = _world_query.get_instance_property(relation.subject, definition.monitored_property)
			if not _finite_numeric(value):
				continue
			if not definition.is_failed(float(value)):
				continue
			var mutation = _relations.remove_relation(relation)
			if not mutation.ok:
				diagnostics.append("Relation failure mutation failed: %s" % String(mutation.code))
				continue
			change_set.add(SemanticChange.relation_change(relation.subject, relation.relation_type, relation.object))
			transitions.append({
				"definition_id": definition.id,
				"relation": relation,
				"property": definition.monitored_property,
				"value": float(value),
				"threshold": definition.threshold,
			})
	return {
		"change_set": change_set,
		"transitions": transitions,
		"diagnostics": diagnostics,
	}


func _finite_numeric(value: Variant) -> bool:
	return (value is int or value is float) and is_finite(float(value))
