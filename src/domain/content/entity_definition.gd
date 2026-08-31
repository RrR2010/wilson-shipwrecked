class_name EntityDefinition
extends RefCounted

const DomainId = preload("res://src/domain/core/domain_id.gd")

## Immutable-after-construction authored semantics for an entity family.
## Runtime mutable state belongs to EntityInstance/World, never here.

var id: DomainId
var _categories: Dictionary = {}
var _base_properties: Dictionary = {}
var _capabilities: Dictionary = {}


func _init(
	p_id: DomainId,
	p_categories: Array = [],
	p_base_properties: Dictionary = {},
	p_capabilities: Array = []
) -> void:
	assert(p_id != null, "EntityDefinition requires EntityTypeId")
	p_id.assert_kind(DomainId.Kind.ENTITY_TYPE)
	id = p_id

	for category_id in p_categories:
		assert(category_id is DomainId, "categories must contain DomainId")
		category_id.assert_kind(DomainId.Kind.CATEGORY)
		_categories[category_id.key()] = true

	for property_key in p_base_properties.keys():
		_base_properties[property_key] = p_base_properties[property_key]

	for capability_id in p_capabilities:
		assert(capability_id is DomainId, "capabilities must contain DomainId")
		capability_id.assert_kind(DomainId.Kind.CAPABILITY)
		_capabilities[capability_id.key()] = true


func has_category(category_id: DomainId) -> bool:
	category_id.assert_kind(DomainId.Kind.CATEGORY)
	return _categories.has(category_id.key())


func has_capability(capability_id: DomainId) -> bool:
	capability_id.assert_kind(DomainId.Kind.CAPABILITY)
	return _capabilities.has(capability_id.key())


func get_base_property(property_id: DomainId) -> Variant:
	property_id.assert_kind(DomainId.Kind.PROPERTY)
	return _base_properties.get(property_id.key())


func has_base_property(property_id: DomainId) -> bool:
	property_id.assert_kind(DomainId.Kind.PROPERTY)
	return _base_properties.has(property_id.key())


func base_property_keys() -> Array:
	var result: Array = _base_properties.keys()
	result.sort_custom(func(a, b): return String(a) < String(b))
	return result


func describe() -> Dictionary:
	return {
		"id": id.sort_key(),
		"categories": _sorted_string_keys(_categories),
		"properties": _sorted_string_keys(_base_properties),
		"capabilities": _sorted_string_keys(_capabilities),
	}


func _sorted_string_keys(source: Dictionary) -> Array[String]:
	var result: Array[String] = []
	for key in source.keys():
		result.append(String(key))
	result.sort()
	return result
