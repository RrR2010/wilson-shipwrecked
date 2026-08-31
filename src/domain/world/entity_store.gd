class_name EntityStore
extends RefCounted

const DomainId = preload("res://src/domain/core/domain_id.gd")
const EntityInstance = preload("res://src/domain/world/entity_instance.gd")
const MutationResult = preload("res://src/domain/core/mutation_result.gd")

## Authoritative runtime entity storage. Callers outside World should read through
## WorldQuery rather than receiving this store directly.

var _entities: Dictionary = {}


func add_entity(entity: EntityInstance) -> MutationResult:
	assert(entity != null, "add_entity requires EntityInstance")
	var entity_key := entity.id.key()
	if _entities.has(entity_key):
		return MutationResult.failure(
			&"duplicate_entity",
			["Entity already exists: %s" % entity.id.sort_key()]
		)
	_entities[entity_key] = entity
	return MutationResult.success(&"entity_added", entity)


func get_entity(entity_id: DomainId) -> EntityInstance:
	entity_id.assert_kind(DomainId.Kind.ENTITY)
	return _entities.get(entity_id.key())


func has_entity(entity_id: DomainId) -> bool:
	entity_id.assert_kind(DomainId.Kind.ENTITY)
	return _entities.has(entity_id.key())


func set_property_override(entity_id: DomainId, property_id: DomainId, value: Variant) -> MutationResult:
	var entity := get_entity(entity_id)
	if entity == null:
		return MutationResult.failure(&"entity_not_found", [entity_id.sort_key()])
	entity.set_property_override(property_id, value)
	return MutationResult.success(&"entity_property_override_set", entity)


func clear_property_override(entity_id: DomainId, property_id: DomainId) -> MutationResult:
	var entity := get_entity(entity_id)
	if entity == null:
		return MutationResult.failure(&"entity_not_found", [entity_id.sort_key()])
	entity.clear_property_override(property_id)
	return MutationResult.success(&"entity_property_override_cleared", entity)


func entity_ids() -> Array[String]:
	var result: Array[String] = []
	for entity in _entities.values():
		result.append(entity.id.sort_key())
	result.sort()
	return result
