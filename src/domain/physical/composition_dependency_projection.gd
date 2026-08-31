class_name CompositionDependencyProjection
extends RefCounted

const DomainId = preload("res://src/domain/core/domain_id.gd")

## Reconstructible composition dependency view over authoritative World relations.
## Relation direction is component/content -> host/container. The projection owns no
## mutation and may be rebuilt implicitly from WorldQuery at any time.

var _world_query
var _dependency_relation_types: Array = []
var _max_depth: int
var _result_limit: int


func _init(
	world_query,
	dependency_relation_types: Array,
	max_depth: int = 16,
	result_limit: int = 128
) -> void:
	assert(world_query != null, "CompositionDependencyProjection requires WorldQuery")
	assert(max_depth > 0, "composition dependency max_depth must be > 0")
	assert(result_limit > 0, "composition dependency result_limit must be > 0")
	_world_query = world_query
	_max_depth = max_depth
	_result_limit = result_limit
	var seen: Dictionary = {}
	for relation_type in dependency_relation_types:
		assert(relation_type != null, "composition dependency relation type cannot be null")
		relation_type.assert_kind(DomainId.Kind.RELATION_TYPE)
		if seen.has(relation_type.key()):
			continue
		seen[relation_type.key()] = true
		_dependency_relation_types.append(relation_type)
	_dependency_relation_types.sort_custom(func(a, b): return a.sort_key() < b.sort_key())


func direct_dependents_of(subject) -> Array:
	assert(subject != null, "direct_dependents_of requires subject")
	var by_key: Dictionary = {}
	for relation_type in _dependency_relation_types:
		for relation in _world_query.get_outgoing_relations(subject, relation_type):
			by_key[relation.object.key()] = relation.object
	return _sorted_values(by_key)


func dependents_of(subject) -> Array:
	assert(subject != null, "dependents_of requires subject")
	var visited: Dictionary = {subject.key(): true}
	var queued: Array = [[subject, 0]]
	var result: Array = []
	while not queued.is_empty():
		var item: Array = queued.pop_front()
		var current = item[0]
		var depth: int = item[1]
		if depth >= _max_depth:
			continue
		for dependent in direct_dependents_of(current):
			if visited.has(dependent.key()):
				continue
			visited[dependent.key()] = true
			result.append(dependent)
			if result.size() >= _result_limit:
				return _sorted_refs(result)
			queued.append([dependent, depth + 1])
	return _sorted_refs(result)


func _sorted_values(source: Dictionary) -> Array:
	return _sorted_refs(source.values())


func _sorted_refs(values: Array) -> Array:
	values.sort_custom(func(a, b): return a.sort_key() < b.sort_key())
	return values
