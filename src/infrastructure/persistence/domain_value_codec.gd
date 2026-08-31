class_name DomainValueCodec
extends RefCounted

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")

## JSON-friendly recursive codec for semantic values used by persistence.
## Persistence never relies on Object identity or var_to_str() reconstruction.

func encode(value: Variant) -> Variant:
	if value == null or value is bool or value is int or value is float or value is String:
		return value
	if value is StringName:
		return {"$type": "string_name", "value": String(value)}
	if value is Object:
		if value.get_script() == DomainId:
			return {
				"$type": "domain_id",
				"kind": value.kind,
				"value": String(value.value),
			}
		if value.get_script() == RuntimeWorldRef:
			return {
				"$type": "runtime_world_ref",
				"kind": value.kind,
				"id": null if value.id == null else encode(value.id),
			}
		assert(false, "Unsupported Object persistence value: %s" % value)
		return null
	if value is Array:
		var encoded_array: Array = []
		for item in value:
			encoded_array.append(encode(item))
		return {"$type": "array", "items": encoded_array}
	if value is Dictionary:
		var entries: Array = []
		var keys: Array = value.keys()
		keys.sort_custom(func(a, b): return _stable_key(a) < _stable_key(b))
		for key in keys:
			entries.append({"key": encode(key), "value": encode(value[key])})
		return {"$type": "dictionary", "entries": entries}
	assert(false, "Unsupported persistence Variant type: %s" % typeof(value))
	return null


func decode(encoded: Variant) -> Variant:
	if encoded == null or encoded is bool or encoded is int or encoded is float or encoded is String:
		return encoded
	assert(encoded is Dictionary, "Encoded semantic value must be primitive or Dictionary")
	var type_name: String = encoded.get("$type", "")
	match type_name:
		"string_name":
			return StringName(encoded["value"])
		"domain_id":
			return DomainId.new(int(encoded["kind"]), StringName(encoded["value"]))
		"runtime_world_ref":
			var decoded_id = null if encoded.get("id") == null else decode(encoded["id"])
			return RuntimeWorldRef.new(int(encoded["kind"]), decoded_id)
		"array":
			var decoded_array: Array = []
			for item in encoded.get("items", []):
				decoded_array.append(decode(item))
			return decoded_array
		"dictionary":
			var decoded_dictionary: Dictionary = {}
			for entry in encoded.get("entries", []):
				decoded_dictionary[decode(entry["key"])] = decode(entry["value"])
			return decoded_dictionary
		_:
			assert(false, "Unsupported encoded semantic value type: %s" % type_name)
	return null


func _stable_key(value: Variant) -> String:
	if value is StringName or value is String:
		return String(value)
	if value is int or value is float or value is bool:
		return str(value)
	if value is Object and value.has_method("sort_key"):
		return value.sort_key()
	return var_to_str(value)
