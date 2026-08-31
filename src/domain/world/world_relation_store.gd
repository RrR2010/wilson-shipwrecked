class_name WorldRelationStore
extends RefCounted

## Authoritative relation store plus reconstructible indexes.
##
## `_relations_by_key` is truth. `_outgoing`, `_incoming`, and `_by_type` are
## performance indexes only and may be discarded/rebuilt at any time.

enum Direction {
	OUTGOING,
	INCOMING,
}

var _relations_by_key: Dictionary = {}
var _outgoing: Dictionary = {}
var _incoming: Dictionary = {}
var _by_type: Dictionary = {}


func add_relation(relation: WorldRelation) -> MutationResult:
	assert(relation != null, "add_relation requires WorldRelation")
	var relation_key := relation.key()
	if _relations_by_key.has(relation_key):
		return MutationResult.failure(
			&"duplicate_relation",
			["Relation already exists: %s" % relation.sort_key()]
		)

	_relations_by_key[relation_key] = relation
	_index_relation(relation)
	return MutationResult.success(&"relation_added", relation)


func remove_relation(relation: WorldRelation) -> MutationResult:
	assert(relation != null, "remove_relation requires WorldRelation")
	var relation_key := relation.key()
	if not _relations_by_key.has(relation_key):
		return MutationResult.failure(
			&"relation_not_found",
			["Relation does not exist: %s" % relation.sort_key()]
		)

	var stored: WorldRelation = _relations_by_key[relation_key]
	_relations_by_key.erase(relation_key)
	_unindex_relation(stored)
	return MutationResult.success(&"relation_removed", stored)


func get_relation(relation_key: StringName) -> WorldRelation:
	return _relations_by_key.get(relation_key)


func relation_count() -> int:
	return _relations_by_key.size()


func find_relations(
	relation_type: DomainId = null,
	subject: RuntimeWorldRef = null,
	object: RuntimeWorldRef = null
) -> Array:
	if relation_type != null:
		relation_type.assert_kind(DomainId.Kind.RELATION_TYPE)

	var candidate_keys: Array = _select_candidate_keys(relation_type, subject, object)
	candidate_keys.sort_custom(_less_string_name)

	var result: Array = []
	for relation_key in candidate_keys:
		var relation: WorldRelation = _relations_by_key.get(relation_key)
		if relation != null and relation.matches(relation_type, subject, object):
			result.append(relation)
	return result


func get_outgoing(subject: RuntimeWorldRef, relation_type: DomainId = null) -> Array:
	assert(subject != null, "get_outgoing requires subject")
	return find_relations(relation_type, subject, null)


func get_incoming(object: RuntimeWorldRef, relation_type: DomainId = null) -> Array:
	assert(object != null, "get_incoming requires object")
	return find_relations(relation_type, null, object)


func traverse_relations(
	start: RuntimeWorldRef,
	allowed_relation_types: Array,
	max_depth: int,
	result_limit: int,
	direction: int = Direction.OUTGOING
) -> RelationTraversalResult:
	assert(start != null, "traverse_relations requires start")
	assert(max_depth >= 0, "max_depth must be >= 0")
	assert(result_limit > 0, "result_limit must be > 0")
	assert(direction == Direction.OUTGOING or direction == Direction.INCOMING, "Invalid traversal direction")

	var allowed: Dictionary = {}
	for relation_type in allowed_relation_types:
		assert(relation_type is DomainId, "allowed_relation_types must contain DomainId")
		relation_type.assert_kind(DomainId.Kind.RELATION_TYPE)
		allowed[relation_type.key()] = true

	var visited: Dictionary = {start.key(): true}
	var queued: Array = [[start, 0]]
	var subjects: Array = []
	var relations: Array = []
	var seen_relations: Dictionary = {}

	while not queued.is_empty():
		var item: Array = queued.pop_front()
		var current: RuntimeWorldRef = item[0]
		var depth: int = item[1]
		if depth >= max_depth:
			continue

		# get_outgoing/get_incoming are already stably ordered by relation key, so
		# breadth-first discovery order is deterministic and preserves graph depth.
		var edges: Array
		if direction == Direction.OUTGOING:
			edges = get_outgoing(current)
		else:
			edges = get_incoming(current)

		for relation in edges:
			if not allowed.is_empty() and not allowed.has(relation.relation_type.key()):
				continue

			var relation_key := relation.key()
			if not seen_relations.has(relation_key):
				seen_relations[relation_key] = true
				relations.append(relation)

			var neighbor: RuntimeWorldRef
			if direction == Direction.OUTGOING:
				neighbor = relation.object
			else:
				neighbor = relation.subject

			if visited.has(neighbor.key()):
				continue
			visited[neighbor.key()] = true
			subjects.append(neighbor)

			if subjects.size() >= result_limit:
				return RelationTraversalResult.new(subjects, relations, true)

			queued.append([neighbor, depth + 1])

	return RelationTraversalResult.new(subjects, relations, false)


func rebuild_indexes() -> void:
	_outgoing.clear()
	_incoming.clear()
	_by_type.clear()

	var keys: Array = _relations_by_key.keys()
	keys.sort_custom(_less_string_name)
	for relation_key in keys:
		_index_relation(_relations_by_key[relation_key])


func validate_indexes() -> MutationResult:
	var expected_outgoing: Dictionary = {}
	var expected_incoming: Dictionary = {}
	var expected_by_type: Dictionary = {}

	for relation in _relations_by_key.values():
		_index_key(expected_outgoing, relation.subject.key(), relation.key())
		_index_key(expected_incoming, relation.object.key(), relation.key())
		_index_key(expected_by_type, relation.relation_type.key(), relation.key())

	var expected := {
		"outgoing": _normalized_index(expected_outgoing),
		"incoming": _normalized_index(expected_incoming),
		"by_type": _normalized_index(expected_by_type),
	}
	var actual := {
		"outgoing": _normalized_index(_outgoing),
		"incoming": _normalized_index(_incoming),
		"by_type": _normalized_index(_by_type),
	}

	if expected != actual:
		return MutationResult.failure(
			&"relation_index_drift",
			["Reconstructible relation indexes do not match authoritative relations"]
		)
	return MutationResult.success(&"relation_indexes_valid")


func index_stats() -> Dictionary:
	return {
		"relations": _relations_by_key.size(),
		"outgoing_subjects": _outgoing.size(),
		"incoming_objects": _incoming.size(),
		"relation_types": _by_type.size(),
	}


func _select_candidate_keys(
	relation_type: DomainId,
	subject: RuntimeWorldRef,
	object: RuntimeWorldRef
) -> Array:
	# Pick a bounded index when possible, then filter all requested constraints.
	if subject != null:
		return _outgoing.get(subject.key(), []).duplicate()
	if object != null:
		return _incoming.get(object.key(), []).duplicate()
	if relation_type != null:
		return _by_type.get(relation_type.key(), []).duplicate()
	return _relations_by_key.keys()


func _index_relation(relation: WorldRelation) -> void:
	_index_key(_outgoing, relation.subject.key(), relation.key())
	_index_key(_incoming, relation.object.key(), relation.key())
	_index_key(_by_type, relation.relation_type.key(), relation.key())


func _unindex_relation(relation: WorldRelation) -> void:
	_unindex_key(_outgoing, relation.subject.key(), relation.key())
	_unindex_key(_incoming, relation.object.key(), relation.key())
	_unindex_key(_by_type, relation.relation_type.key(), relation.key())


func _index_key(index: Dictionary, index_key: StringName, relation_key: StringName) -> void:
	if not index.has(index_key):
		index[index_key] = []
	var keys: Array = index[index_key]
	if not keys.has(relation_key):
		keys.append(relation_key)


func _unindex_key(index: Dictionary, index_key: StringName, relation_key: StringName) -> void:
	if not index.has(index_key):
		return
	var keys: Array = index[index_key]
	keys.erase(relation_key)
	if keys.is_empty():
		index.erase(index_key)


func _normalized_index(index: Dictionary) -> Dictionary:
	var normalized: Dictionary = {}
	for index_key in index.keys():
		var values: Array = index[index_key].duplicate()
		values.sort_custom(_less_string_name)
		normalized[String(index_key)] = values.map(func(value): return String(value))
	return normalized


func _less_string_name(a, b) -> bool:
	return String(a) < String(b)
