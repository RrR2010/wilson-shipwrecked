class_name BeliefProposition
extends RefCounted

## Stable proposition identity owned by Wilson cognition.
## Arguments are semantic subjects/values; key() is deterministic and independent
## from object identity.

var predicate: StringName
var arguments: Array


func _init(p_predicate: StringName, p_arguments: Array) -> void:
	assert(p_predicate != &"", "BeliefProposition requires predicate")
	predicate = p_predicate
	arguments = p_arguments.duplicate()


func key() -> StringName:
	var parts: Array[String] = [String(predicate)]
	for argument in arguments:
		if argument is Object and argument.has_method("sort_key"):
			parts.append(argument.sort_key())
		else:
			parts.append(var_to_str(argument))
	return StringName("|".join(parts))


func sort_key() -> String:
	return String(key())
