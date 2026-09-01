class_name PlayerProfile
extends RefCounted

const DomainId = preload("res://src/domain/core/domain_id.gd")

## Cross-run player state only. Never store Wilson autobiographical cognition here.

var _legacy_knowledge: Dictionary = {}
var _diary_archive: Array = []
var _lifetime_statistics: Dictionary = {}
var _global_unlocks: Dictionary = {}


func add_legacy_knowledge(knowledge_id) -> bool:
	if knowledge_id == null:
		return false
	knowledge_id.assert_kind(DomainId.Kind.KNOWLEDGE)
	_legacy_knowledge[knowledge_id.key()] = knowledge_id
	return true


func has_legacy_knowledge(knowledge_id) -> bool:
	return knowledge_id != null and _legacy_knowledge.has(knowledge_id.key())


func legacy_knowledge() -> Array:
	var result: Array = _legacy_knowledge.values()
	result.sort_custom(func(a, b): return a.sort_key() < b.sort_key())
	return result


func archive_diary_entry(run_id: StringName, entry_id: StringName, text: String, wilson_accessible: bool) -> bool:
	if run_id == &"" or entry_id == &"" or text.strip_edges().is_empty():
		return false
	for entry in _diary_archive:
		if entry["run_id"] == run_id and entry["entry_id"] == entry_id:
			return false
	_diary_archive.append({
		"run_id": run_id,
		"entry_id": entry_id,
		"text": text,
		"wilson_accessible": wilson_accessible,
	})
	_diary_archive.sort_custom(func(a, b): return "%s|%s" % [String(a["run_id"]), String(a["entry_id"])] < "%s|%s" % [String(b["run_id"]), String(b["entry_id"])])
	return true


func diary_archive() -> Array:
	return _diary_archive.duplicate(true)


func increment_stat(stat_id: StringName, amount: int = 1) -> bool:
	if stat_id == &"" or amount < 0:
		return false
	_lifetime_statistics[stat_id] = int(_lifetime_statistics.get(stat_id, 0)) + amount
	return true


func stat(stat_id: StringName) -> int:
	return int(_lifetime_statistics.get(stat_id, 0))


func statistics() -> Dictionary:
	return _lifetime_statistics.duplicate()


func unlock(unlock_id: StringName) -> bool:
	if unlock_id == &"":
		return false
	_global_unlocks[unlock_id] = true
	return true


func is_unlocked(unlock_id: StringName) -> bool:
	return bool(_global_unlocks.get(unlock_id, false))


func unlocks() -> Array[StringName]:
	var result: Array[StringName] = []
	for key in _global_unlocks.keys():
		result.append(StringName(key))
	result.sort_custom(func(a, b): return String(a) < String(b))
	return result
