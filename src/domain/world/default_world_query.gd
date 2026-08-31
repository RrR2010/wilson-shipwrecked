class_name DefaultWorldQuery
extends RefCounted

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const EntityInstance = preload("res://src/domain/world/entity_instance.gd")
const WorldRelationStore = preload("res://src/domain/world/world_relation_store.gd")

## Default read-only composition over authoritative World stores + sealed content.
##
## Spatial reads are deliberately coarse and engine-agnostic: PlaceId is the
## authoritative location available in the current domain. A future navigation /
## physics adapter may add distance and occlusion without changing these ownership
## boundaries.

var _entities
var _relations
var _content
var _wilson_world_state


func _init(entities, relations, content, wilson_world_state = null) -> void:
	assert(entities != null, "DefaultWorldQuery requires EntityStore")
	assert(relations != null, "DefaultWorldQuery requires WorldRelationStore")
	assert(content != null, "DefaultWorldQuery requires ContentRegistry")
	_entities = entities
	_relations = relations
	_content = content
	_wilson_world_state = wilson_world_state


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


func get_property_definition(property_id):
	assert(property_id != null, "get_property_definition requires PropertyId")
	property_id.assert_kind(DomainId.Kind.PROPERTY)
	return _content.get_property_definition(property_id)


func validate_property_value(property_id, value: Variant) -> bool:
	return _content.validate_property_value(property_id, value)


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


func get_runtime_place(subject):
	assert(subject != null, "get_runtime_place requires RuntimeWorldRef")
	match subject.kind:
		RuntimeWorldRef.Kind.WILSON:
			return null if _wilson_world_state == null else _wilson_world_state.place_id
		RuntimeWorldRef.Kind.ENTITY:
			var entity = _entities.get_entity(subject.id)
			return null if entity == null else entity.place_id
		RuntimeWorldRef.Kind.PLACE:
			return subject.id
		_:
			return null


func are_co_located(a, b) -> bool:
	var place_a = get_runtime_place(a)
	var place_b = get_runtime_place(b)
	return place_a != null and place_b != null and place_a.equals(place_b)


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


func query_nearby(subject_or_place, constraints: Dictionary = {}) -> Array:
	assert(subject_or_place != null, "query_nearby requires RuntimeWorldRef")
	var place_id = get_runtime_place(subject_or_place)
	if place_id == null:
		return []
	var result: Array = []
	var limit := int(constraints.get("limit", 64))
	assert(limit > 0, "query_nearby limit must be > 0")
	var include_subject := bool(constraints.get("include_subject", false))
	var include_inactive := bool(constraints.get("include_inactive", false))
	var category_id = constraints.get("category_id")
	var capability_id = constraints.get("capability_id")
	if category_id != null:
		category_id.assert_kind(DomainId.Kind.CATEGORY)
	if capability_id != null:
		capability_id.assert_kind(DomainId.Kind.CAPABILITY)

	for entity in _entities.entities():
		if not include_inactive and entity.lifecycle != EntityInstance.Lifecycle.ACTIVE:
			continue
		if not entity.place_id.equals(place_id):
			continue
		var candidate = RuntimeWorldRef.entity(entity.id)
		if not include_subject and candidate.equals(subject_or_place):
			continue
		if category_id != null and not has_category(candidate, category_id):
			continue
		if capability_id != null and not has_authored_capability(candidate, capability_id):
			continue
		result.append(candidate)
		if result.size() >= limit:
			break
	result.sort_custom(func(a, b): return a.sort_key() < b.sort_key())
	return result
