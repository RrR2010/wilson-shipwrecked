class_name EpistemicGraphProjection
extends RefCounted

## Reconstructible read index over BeliefStore. Never authoritative.

var _by_predicate: Dictionary = {}
var _by_subject_key: Dictionary = {}

func rebuild(belief_store) -> void:
	assert(belief_store != null, "rebuild requires BeliefStore")
	_by_predicate.clear()
	_by_subject_key.clear()
	for entry in belief_store.entries():
		var proposition = entry.proposition
		_index(_by_predicate, proposition.predicate, entry)
		for argument in proposition.arguments:
			if argument != null and argument.has_method("key"):
				_index(_by_subject_key, argument.key(), entry)

func query_by_predicate(predicate: StringName) -> Array:
	return _sorted_entries(_by_predicate.get(predicate, []).duplicate())

func query_by_subject(subject) -> Array:
	assert(subject != null and subject.has_method("key"), "query_by_subject requires semantic subject")
	return _sorted_entries(_by_subject_key.get(subject.key(), []).duplicate())

func _index(index: Dictionary, key, entry) -> void:
	if not index.has(key):
		index[key] = []
	index[key].append(entry)

func _sorted_entries(entries: Array) -> Array:
	entries.sort_custom(func(a, b): return a.proposition.sort_key() < b.proposition.sort_key())
	return entries
