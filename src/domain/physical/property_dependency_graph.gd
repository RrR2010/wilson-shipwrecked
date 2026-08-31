class_name PropertyDependencyGraph
extends RefCounted

const DomainId = preload("res://src/domain/core/domain_id.gd")
const MutationResult = preload("res://src/domain/core/mutation_result.gd")

## Reconstructible dependency DAG compiled from PropertyDerivationDefinition[]
## Graph structure is derived infrastructure, never gameplay authority.

var _rules_by_output: Dictionary = {}
var _dependents_by_input: Dictionary = {}
var _topological_outputs: Array = []


func compile(rules: Array) -> MutationResult:
	_rules_by_output.clear()
	_dependents_by_input.clear()
	_topological_outputs.clear()

	for rule in rules:
		assert(rule != null, "PropertyDependencyGraph rules cannot contain null")
		var output_key = rule.output_property.key()
		if _rules_by_output.has(output_key):
			return MutationResult.failure(&"duplicate_property_derivation", ["Multiple derivations produce %s" % String(output_key)])
		_rules_by_output[output_key] = rule
		for input_property in rule.input_properties:
			var input_key = input_property.key()
			if not _dependents_by_input.has(input_key):
				_dependents_by_input[input_key] = []
			_dependents_by_input[input_key].append(rule.output_property)

	var indegree: Dictionary = {}
	for output_key in _rules_by_output.keys():
		indegree[output_key] = 0
	for output_key in _rules_by_output.keys():
		var rule = _rules_by_output[output_key]
		for input_property in rule.input_properties:
			if _rules_by_output.has(input_property.key()):
				indegree[output_key] += 1

	var ready: Array = []
	for output_key in indegree.keys():
		if indegree[output_key] == 0:
			ready.append(output_key)
	ready.sort_custom(_less_key)

	while not ready.is_empty():
		var output_key = ready.pop_front()
		_topological_outputs.append(_rules_by_output[output_key].output_property)
		var dependents: Array = _dependents_by_input.get(output_key, [])
		for dependent_property in dependents:
			var dependent_key = dependent_property.key()
			if not indegree.has(dependent_key):
				continue
			indegree[dependent_key] -= 1
			if indegree[dependent_key] == 0:
				ready.append(dependent_key)
				ready.sort_custom(_less_key)

	if _topological_outputs.size() != _rules_by_output.size():
		_topological_outputs.clear()
		return MutationResult.failure(&"property_derivation_cycle", ["Property derivation definitions contain a cycle"])
	return MutationResult.success(&"property_dependency_graph_compiled")


func rule_for_output(property_id):
	assert(property_id != null, "rule_for_output requires PropertyId")
	property_id.assert_kind(DomainId.Kind.PROPERTY)
	return _rules_by_output.get(property_id.key())


func topological_outputs() -> Array:
	return _topological_outputs.duplicate()


func affected_outputs(changed_property) -> Array:
	assert(changed_property != null, "affected_outputs requires PropertyId")
	changed_property.assert_kind(DomainId.Kind.PROPERTY)
	var visited: Dictionary = {}
	var queue: Array = [changed_property]
	var result: Array = []
	while not queue.is_empty():
		var current = queue.pop_front()
		for dependent in _dependents_by_input.get(current.key(), []):
			if visited.has(dependent.key()):
				continue
			visited[dependent.key()] = true
			result.append(dependent)
			queue.append(dependent)
	result.sort_custom(func(a, b): return a.sort_key() < b.sort_key())
	return result


func _less_key(a, b) -> bool:
	return String(a) < String(b)
