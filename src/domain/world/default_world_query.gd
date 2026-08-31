class_name DefaultWorldQuery
extends RefCounted

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const EntityInstance = preload("res://src/domain/world/entity_instance.gd")
const WorldRelationStore = preload("res://src/domain/world/world_relation_store.gd")

## Default read-only composition over authoritative World stores + sealed content.
##
## This concrete implementation intentionally does not inherit from WorldQuery.
## GDScript ports are structural/duck-typed at runtime so a clean headless checkout
## does not depend on external script inheritance or the editor class cache.

var _entities
var _relations
var _content


func _init(entities, relations, content) -> void:
	assert(entities != null, "DefaultWorldQuery requires EntityStore")
	assert(relations != null, "DefaultWorldQuery requires WorldRelationStore")
	assert(content != null, "DefaultWorldQuery requires ContentRegistry")
	_entities = entities
	_relations = relations
	_content = content


func get_instance_property(subject, property_id) -> Variant:
	assert(subject != null, "get_instance_property requires subject")
	assert(property_id != null, "get_instance_property requires PropertyId")
	property_id.assert_kind(DomainId.Kind.PROPERTY)
	if subject.kind != RuntimeWorldRef.Kind.ENTITY:
		return null
	var entity = _entities.get_entity(subject.id)
	if entity == null:
		return null
	if entity.has_property_override(property_id):
		return entity.get_property_override(property_id)
	var definition = _content.get_entity_definition(entity.type_id)
	return null if definition == null else definition.get_base_property(property_id)


func has_authored_capability(subject, capability_id) -> bool:
	assert(subject != null, "has_authored_capability requires subject")
	assert(capability_id != null, "has_authored_capability requires CapabilityId")
	capability_id.assert_kind(DomainId.Kind.CAPABILITY)
	if subject.kind != RuntimeWorldRef.Kind.ENTITY:
		return false
	var entity = _entities.get_entity(subject.id)
	if entity == null:
		return false
	var definition = _content.get_entity_definition(entity.type_id)
	return definition != null and definition.has_capability(capability_id)


func has_category(subject, category_id) -> bool:
	assert(subject != null, "has_category requires subject")
	assert(category_id != null, "has_category requires CategoryId")
	category_id.assert_kind(DomainId.Kind.CATEGORY)
	if subject.kind != RuntimeWorldRef.Kind.ENTITY:
		return false
	var entity = _entities.get_entity(subject.id)
	if entity == null:
		return false
	var definition = _content.get_entity_definition(entity.type_id)
	return definition != null and definition.has_category(category_id)


func is_live_subject(subject) -> bool:
	assert(subject != null, "is_live_subject requires subject")
	if subject.kind == RuntimeWorldRef.Kind.WILSON:
		return true
	if subject.kind != RuntimeWorldRef.Kind.ENTITY:
		return true
	var entity = _entities.get_entity(subject.id)
	return entity != null and entity.lifecycle == EntityInstance.Lifecycle.ACTIVE


func find_relations(relation_type = null, subject = null, object = null) -> Array:
	return _relations.find_relations(relation_type, subject, object)


func get_outgoing_relations(subject, relation_type = null) -> Array:
	return _relations.get_outgoing(subject, relation_type)


func get_incoming_relations(object, relation_type = null) -> Array:
	return _relations.get_incoming(object, relation_type)


func traverse_relations(
	start,
	allowed_relation_types: Array,
	max_depth: int,
	result_limit: int,
	direction: int = WorldRelationStore.Direction.OUTGOING
):
	return _relations.traverse_relations(
		start,
		allowed_relation_types,
		max_depth,
		result_limit,
		direction
	)


func query_nearby(_subject_or_place, _constraints: Dictionary) -> Array:
	assert(false, "DefaultWorldQuery.query_nearby requires the future spatial query port")
	return []
