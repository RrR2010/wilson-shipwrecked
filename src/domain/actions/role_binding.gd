class_name RoleBinding
extends RefCounted

## Local action/pattern role bindings. These bindings are transient and never
## become persistent world identity.

var _values: Dictionary = {}


func bind(role_name: StringName, subject) -> void:
	assert(role_name != &"", "RoleBinding role cannot be empty")
	assert(subject != null, "RoleBinding subject cannot be null")
	_values[role_name] = subject


func has(role_name: StringName) -> bool:
	return _values.has(role_name)


func get_subject(role_name: StringName):
	return _values.get(role_name)


func duplicate_binding():
	var copy = new()
	for role_name in _values.keys():
		copy.bind(role_name, _values[role_name])
	return copy


func role_names() -> Array[StringName]:
	var result: Array[StringName] = []
	for role_name in _values.keys():
		result.append(role_name)
	result.sort_custom(func(a, b): return String(a) < String(b))
	return result


func stable_key() -> String:
	var parts: Array[String] = []
	for role_name in role_names():
		var subject = _values[role_name]
		parts.append("%s=%s" % [String(role_name), subject.sort_key()])
	return "|".join(parts)
