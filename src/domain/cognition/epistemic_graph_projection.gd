class_name EpistemicGraphProjection
extends RefCounted

## Reconstructible read indexes over BeliefStore. Never authoritative.
## Indexes are typed by claim kind / semantic id / referenced subject rather than
## generic predicate and argument positions.

var _by_kind: Dictionary = {}
var _by_semantic_id: Dictionary = {}
var _by_subject_key: Dictionary = {}


func rebuild(belief_store) -> void:
	assert(belief_store != null, "rebuild requires BeliefStore")
	_by_kind.clear()
	_by_semantic_id.clear()
	_by_subject_key.clear()
	for entry in belief_store.entries():
		var claim = entry.proposition.claim
		_index(_by_kind, claim.kind, entry)
		_index(_by_semantic_id, claim.semantic_id.key(), entry)
		for subject in claim.referenced_subjects():
			_index(_by_subject_key, subject.key(), entry)


func query_by_kind(kind: int) -> Array:
	return _sorted_entries(_by_kind.get(kind, []).duplicate())


func query_by_semantic_id(semantic_id) -> Array:
	assert(semantic_id != null and semantic_id.has_method("key"), "query_by_semantic_id requires nominal semantic id")
	return _sorted_entries(_by_semantic_id.get(semantic_id.key(), []).duplicate())


func query_by_subject(subject) -> Array:
	assert(subject is Object and subject.has_method("key"), "query_by_subject requires semantic subject")
	return _sorted_entries(_by_subject_key.get(subject.key(), []).duplicate())


func _index(index: Dictionary, key, entry) -> void:
	if not index.has(key):
		index[key] = []
	index[key].append(entry)


func _sorted_entries(entries: Array) -> Array:
	entries.sort_custom(func(a, b): return a.proposition.sort_key() < b.proposition.sort_key())
	return entries
