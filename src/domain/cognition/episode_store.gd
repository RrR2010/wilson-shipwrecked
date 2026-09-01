class_name EpisodeStore
extends RefCounted

var _max_entries: int
var _minimum_importance: float
var _entries: Dictionary = {}
var _sequence: int = 0


func _init(max_entries: int = 64, minimum_importance: float = 0.35) -> void:
	assert(max_entries > 0, "EpisodeStore max entries must be positive")
	assert(is_finite(minimum_importance) and minimum_importance >= 0.0 and minimum_importance <= 1.0, "Episode minimum importance must be within [0,1]")
	_max_entries = max_entries
	_minimum_importance = minimum_importance


func consider(candidate) -> bool:
	assert(candidate != null, "EpisodeStore.consider requires candidate")
	if candidate.importance < _minimum_importance:
		return false
	var key: StringName = candidate.key()
	if _entries.has(key):
		return false
	_sequence += 1
	_entries[key] = {
		"claim": candidate.claim,
		"importance": candidate.importance,
		"source_execution_id": candidate.source_execution_id,
		"modality": candidate.modality,
		"sequence": _sequence,
	}
	_prune_if_needed()
	return true


func entries() -> Array:
	var result: Array = _entries.values()
	result.sort_custom(func(a, b): return int(a["sequence"]) < int(b["sequence"]))
	var copies: Array = []
	for entry in result:
		copies.append(entry.duplicate(true))
	return copies


func restore_entry(claim, importance: float, source_execution_id: StringName, modality: StringName, sequence: int) -> void:
	assert(claim != null and claim.has_method("sort_key"), "Episode restore requires claim")
	assert(is_finite(importance) and importance >= 0.0 and importance <= 1.0, "Episode importance must be within [0,1]")
	assert(sequence > 0, "Episode sequence must be positive")
	var key: StringName = StringName("%s|%s" % [String(source_execution_id), claim.sort_key()])
	_entries[key] = {
		"claim": claim,
		"importance": importance,
		"source_execution_id": source_execution_id,
		"modality": modality,
		"sequence": sequence,
	}
	_sequence = maxi(_sequence, sequence)
	_prune_if_needed()


func _prune_if_needed() -> void:
	while _entries.size() > _max_entries:
		var weakest_key = null
		var weakest_importance: float = 2.0
		var oldest_sequence: int = 2147483647
		for key in _entries.keys():
			var entry: Dictionary = _entries[key]
			var importance: float = float(entry["importance"])
			var sequence: int = int(entry["sequence"])
			if importance < weakest_importance or (is_equal_approx(importance, weakest_importance) and sequence < oldest_sequence):
				weakest_key = key
				weakest_importance = importance
				oldest_sequence = sequence
		_entries.erase(weakest_key)
