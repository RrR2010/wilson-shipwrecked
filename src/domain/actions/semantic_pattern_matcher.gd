class_name SemanticPatternMatcher
extends RefCounted

const RoleBinding = preload("res://src/domain/actions/role_binding.gd")

var _predicate_evaluator


func _init(predicate_evaluator) -> void:
	assert(predicate_evaluator != null, "SemanticPatternMatcher requires predicate evaluator")
	_predicate_evaluator = predicate_evaluator


func match(pattern, candidate_sets: Dictionary, result_limit: int = 64) -> Array:
	assert(pattern != null, "match requires SemanticPattern")
	assert(result_limit > 0, "result_limit must be > 0")
	for variable_name in pattern.variables:
		assert(candidate_sets.has(variable_name), "Missing candidate set for %s" % String(variable_name))
		assert(candidate_sets[variable_name] is Array, "Candidate set must be Array")

	var results: Array = []
	_expand(pattern, candidate_sets, 0, RoleBinding.new(), results, result_limit)
	results.sort_custom(func(a, b): return a.stable_key() < b.stable_key())
	return results


func _expand(pattern, candidate_sets: Dictionary, index: int, bindings, results: Array, result_limit: int) -> void:
	if results.size() >= result_limit:
		return
	if index >= pattern.variables.size():
		var evaluation = _predicate_evaluator.evaluate(pattern.predicate, bindings)
		if evaluation.passed:
			results.append(bindings.duplicate_binding())
		return

	var variable_name: StringName = pattern.variables[index]
	var candidates: Array = candidate_sets[variable_name].duplicate()
	candidates.sort_custom(func(a, b): return a.sort_key() < b.sort_key())
	for candidate in candidates:
		if results.size() >= result_limit:
			return
		var next_bindings = bindings.duplicate_binding()
		next_bindings.bind(variable_name, candidate)
		_expand(pattern, candidate_sets, index + 1, next_bindings, results, result_limit)
