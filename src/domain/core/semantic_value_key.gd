class_name SemanticValueKey
extends RefCounted

## Canonical stable identity for bounded semantic scalar values.
## Used wherever persistence/reconstruction must not distinguish representation
## details such as int(3) versus float(3.0).

static func supports(value: Variant) -> bool:
	if value == null or value is bool or value is StringName or value is String:
		return true
	if value is int or value is float:
		return is_finite(float(value))
	return (
		value is Object
		and value.has_method("assert_kind")
		and value.has_method("sort_key")
	)


static func canonical(value: Variant) -> String:
	assert(supports(value), "Unsupported stable semantic value")
	if value == null:
		return "none"
	if value is bool:
		return "bool:%s" % str(value)
	if value is int or value is float:
		var numeric := float(value)
		if is_zero_approx(numeric):
			numeric = 0.0
		return "number:%s" % str(numeric)
	if value is StringName or value is String:
		return "symbol:%s" % String(value)
	return "semantic:%s" % value.sort_key()
