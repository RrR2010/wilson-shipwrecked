class_name EffectivePhysicalProfile
extends RefCounted

## Derived physical projection for one runtime subject.
## Contains no authority; may be discarded and recomputed.

var subject
var _properties: Dictionary = {}
var _provenance: Dictionary = {}


func _init(p_subject) -> void:
	assert(p_subject != null, "EffectivePhysicalProfile requires subject")
	subject = p_subject


func set_property(property_id, value: Variant, provenance: Dictionary) -> void:
	_properties[property_id.key()] = value
	_provenance[property_id.key()] = provenance.duplicate(true)


func has_property(property_id) -> bool:
	return _properties.has(property_id.key())


func get_property(property_id) -> Variant:
	return _properties.get(property_id.key())


func explain(property_id) -> Dictionary:
	return _provenance.get(property_id.key(), {}).duplicate(true)


func property_keys() -> Array[String]:
	var result: Array[String] = []
	for key in _properties.keys():
		result.append(String(key))
	result.sort()
	return result
