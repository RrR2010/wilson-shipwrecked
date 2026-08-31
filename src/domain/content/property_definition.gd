class_name PropertyDefinition
extends RefCounted

const DomainId = preload("res://src/domain/core/domain_id.gd")

enum ValueFamily {
	NUMBER,
	BOOLEAN,
	SYMBOL,
}

var id
var value_family: int
var min_value: Variant = null
var max_value: Variant = null


func _init(p_id, p_value_family: int, p_min_value: Variant = null, p_max_value: Variant = null) -> void:
	assert(p_id != null, "PropertyDefinition requires PropertyId")
	p_id.assert_kind(DomainId.Kind.PROPERTY)
	assert(p_value_family >= 0 and p_value_family < ValueFamily.size(), "Invalid PropertyDefinition value family")
	id = p_id
	value_family = p_value_family
	min_value = p_min_value
	max_value = p_max_value
	if value_family == ValueFamily.NUMBER:
		if min_value != null:
			assert(min_value is int or min_value is float, "numeric property min must be numeric")
		if max_value != null:
			assert(max_value is int or max_value is float, "numeric property max must be numeric")
		if min_value != null and max_value != null:
			assert(float(min_value) <= float(max_value), "numeric property bounds are reversed")
	else:
		assert(min_value == null and max_value == null, "only numeric properties support bounds")


func validate_value(value: Variant) -> bool:
	match value_family:
		ValueFamily.NUMBER:
			if not (value is int or value is float):
				return false
			var numeric = float(value)
			if min_value != null and numeric < float(min_value):
				return false
			if max_value != null and numeric > float(max_value):
				return false
			return true
		ValueFamily.BOOLEAN:
			return value is bool
		ValueFamily.SYMBOL:
			return value is StringName or value is String
	return false


func supports_ordering() -> bool:
	return value_family == ValueFamily.NUMBER
