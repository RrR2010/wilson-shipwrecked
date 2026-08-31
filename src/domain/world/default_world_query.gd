class_name DefaultWorldQuery
extends WorldQuery

## Default read-only composition over authoritative World stores + sealed content.
## This object owns no state and performs no mutation.

var _entities: EntityStore
var _relations: WorldRelationStore
var _content: ContentRegistry


func _init(
	entities: EntityStore,
	relations: WorldRelationStore,
	content: ContentRegistry
) -> void:
	assert(entities != null, "DefaultWorldQuery requires EntityStore")
	assert(relations != null, "DefaultWorldQuery requires WorldRelationStore")
	assert(content != null, "DefaultWorldQuery requires ContentRegistry")
	_entities = entities
	_relations = relations
	_content = content


func get_instance_property(subject: RuntimeWorldRef, property_id: DomainId) -> Variant:
	property_id.assert_kind(DomainId.Kind.PROPERTY)
	if subject == null or subject.kind != RuntimeWorldRef.Kind.ENTITY:
		return null
	var entity := _entities.get_entity(subject.id)
	if entity == null:
		return null
	if entity.has_property_override(property_id):
		return entity.get_property_override(property_id)
	var definition := _content.get_entity_definition(entity.type_id)
	if definition == null:
		return null
	return definition.get_base_property(property_id)


func has_authored_capability(subject: RuntimeWorldRef, capability_id: DomainId) -> bool:
	capability_id.assert_kind(DomainId.Kind.CAPABILITY)
	if subject == null or subject.kind != RuntimeWorldRef.Kind.ENTITY:
		return false
	var entity := _entities.get_entity(subject.id)
	if entity == null:
		return false
	var definition := _content.get_entity_definition(entity.type_id)
	return definition != null and definition.has_capability(capability_id)


func has_category(subject: RuntimeWorldRef, category_id: DomainId) -> bool:
	category_id.assert_kind(DomainId.Kind.CATEGORY)
	if subject == null or subject.kind != RuntimeWorldRef.Kind.ENTITY:
		return false
	var entity := _entities.get_entity(subject.id)
	if entity == null:
		return false
	var definition := _content.get_entity_definition(entity.type_id)
	return definition != null and definition.has_category(category_id)


func find_relations(
	relation_type: DomainId = null,
	subject: RuntimeWorldRef = null,
	object: RuntimeWorldRef = null
) -> Array:
	return _relations.find_relations(relation_type, subject, object)


func get_outgoing_relations(subject: RuntimeWorldRef, relation_type: DomainId = null) -> Array:
	return _relations.get_outgoing(subject, relation_type)


func get_incoming_relations(object: RuntimeWorldRef, relation_type: DomainId = null) -> Array:
	return _relations.get_incoming(object, relation_type)


func traverse_relations(
	start: RuntimeWorldRef,
	allowed_relation_types: Array,
	max_depth: int,
	result_limit: int,
	direction: int = WorldRelationStore.Direction.OUTGOING
) -> RelationTraversalResult:
	return _relations.traverse_relations(
		start,
		allowed_relation_types,
		max_depth,
		result_limit,
		direction
	)


func query_nearby(_subject_or_place: RuntimeWorldRef, _constraints: Dictionary) -> Array:
	# Spatial topology is intentionally unresolved. Fail loudly rather than expose
	# an accidental global scan as a temporary implementation.
	assert(false, "DefaultWorldQuery.query_nearby requires the future spatial query port")
	return []
