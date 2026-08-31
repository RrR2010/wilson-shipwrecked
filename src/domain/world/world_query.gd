class_name WorldQuery
extends RefCounted

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const WorldRelationStore = preload("res://src/domain/world/world_relation_store.gd")
const RelationTraversalResult = preload("res://src/domain/world/relation_traversal_result.gd")

## Narrow read-only port into authoritative World truth.

func get_instance_property(_subject: RuntimeWorldRef, _property_id: DomainId) -> Variant:
	assert(false, "WorldQuery.get_instance_property must be implemented")
	return null

func has_authored_capability(_subject: RuntimeWorldRef, _capability_id: DomainId) -> bool:
	assert(false, "WorldQuery.has_authored_capability must be implemented")
	return false

func has_category(_subject: RuntimeWorldRef, _category_id: DomainId) -> bool:
	assert(false, "WorldQuery.has_category must be implemented")
	return false

func find_relations(_relation_type: DomainId = null, _subject: RuntimeWorldRef = null, _object: RuntimeWorldRef = null) -> Array:
	assert(false, "WorldQuery.find_relations must be implemented")
	return []

func get_outgoing_relations(_subject: RuntimeWorldRef, _relation_type: DomainId = null) -> Array:
	assert(false, "WorldQuery.get_outgoing_relations must be implemented")
	return []

func get_incoming_relations(_object: RuntimeWorldRef, _relation_type: DomainId = null) -> Array:
	assert(false, "WorldQuery.get_incoming_relations must be implemented")
	return []

func traverse_relations(_start: RuntimeWorldRef, _allowed_relation_types: Array, _max_depth: int, _result_limit: int, _direction: int = WorldRelationStore.Direction.OUTGOING) -> RelationTraversalResult:
	assert(false, "WorldQuery.traverse_relations must be implemented")
	return null

func query_nearby(_subject_or_place: RuntimeWorldRef, _constraints: Dictionary) -> Array:
	assert(false, "WorldQuery.query_nearby must be implemented")
	return []
