class_name SemanticPattern
extends RefCounted

## Bounded candidate-discovery pattern. Candidate sets are supplied explicitly by
## the caller; this object never authorizes global world scans.

var variables: Array[StringName] = []
var predicate


func _init(p_variables: Array[StringName], p_predicate) -> void:
	assert(p_predicate != null, "SemanticPattern requires predicate")
	var seen: Dictionary = {}
	for variable_name in p_variables:
		assert(variable_name != &"", "SemanticPattern variable cannot be empty")
		assert(not seen.has(variable_name), "SemanticPattern variables must be unique")
		seen[variable_name] = true
		variables.append(variable_name)
	variables.sort_custom(func(a, b): return String(a) < String(b))
	predicate = p_predicate
