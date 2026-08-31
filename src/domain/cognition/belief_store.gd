class_name BeliefStore
extends RefCounted

const BeliefEntry = preload("res://src/domain/cognition/belief_entry.gd")
const MutationResult = preload("res://src/domain/core/mutation_result.gd")

## Wilson cognition authority for proposition confidence.
## Secondary indexes/projections must be reconstructible from this store.

var _entries: Dictionary = {}

func apply_evidence(evidence):
	assert(evidence != null, "apply_evidence requires BeliefEvidence")
	var key = evidence.proposition.key()
	var entry = _entries.get(key)
	if entry == null:
		entry = BeliefEntry.new(evidence.proposition)
		_entries[key] = entry
	entry.apply_evidence(evidence)
	return MutationResult.success(&"belief_evidence_applied", entry)

func get_entry(proposition):
	assert(proposition != null, "get_entry requires proposition")
	return _entries.get(proposition.key())

func entries() -> Array:
	var result: Array = _entries.values()
	result.sort_custom(func(a, b): return a.proposition.sort_key() < b.proposition.sort_key())
	return result

func entry_count() -> int:
	return _entries.size()
