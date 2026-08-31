class_name EntityInstance
extends RefCounted

const DomainId = preload("res://src/domain/core/domain_id.gd")

## Mutable runtime occurrence of an authored EntityDefinition.

enum Lifecycle {
	ACTIVE,
	DESTROYED,
	TRANSFORMED,
	REMOVED,
}

var id: DomainId
var type_id: DomainId
var place_id: DomainId
var lifecycle: int = Lifecycle.ACTIVE
var quantity: Variant = null
var _state_overrides: Dictionary = {}


func _init(
	p_id: DomainId,
	p_type_id: DomainId,
	p_place_id: DomainId,
	p_state_overrides: Dictionary = {},
	p_quantity: Variant = null
) -> void:
	p_id.assert_kind(DomainId.Kind.ENTITY)
	p_type_id.assert_kind(DomainId.Kind.ENTITY_TYPE)
	p_place_id.assert_kind(DomainId.Kind.PLACE)
	id = p_id
	type_id = p_type_id
	place_id = p_place_id
	quantity = p_quantity
	_state_overrides = p_state_overrides.duplicate(true)


func has_property_override(property_id: DomainId) -> bool:
	property_id.assert_kind(DomainId.Kind.PROPERTY)
	return _state_overrides.has(property_id.key())


func get_property_override(property_id: DomainId) -> Variant:
	property_id.assert_kind(DomainId.Kind.PROPERTY)
	return _state_overrides.get(property_id.key())


func set_property_override(property_id: DomainId, value: Variant) -> void:
	property_id.assert_kind(DomainId.Kind.PROPERTY)
	_state_overrides[property_id.key()] = value


func clear_property_override(property_id: DomainId) -> void:
	property_id.assert_kind(DomainId.Kind.PROPERTY)
	_state_overrides.erase(property_id.key())


func state_overrides() -> Dictionary:
	return _state_overrides.duplicate(true)


func describe() -> Dictionary:
	var property_keys: Array[String] = []
	for key in _state_overrides.keys():
		property_keys.append(String(key))
	property_keys.sort()
	return {
		"id": id.sort_key(),
		"type_id": type_id.sort_key(),
		"place_id": place_id.sort_key(),
		"lifecycle": lifecycle,
		"override_properties": property_keys,
	}
