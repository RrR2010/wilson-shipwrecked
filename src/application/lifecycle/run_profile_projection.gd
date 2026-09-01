class_name RunProfileProjection
extends RefCounted

const DomainId = preload("res://src/domain/core/domain_id.gd")

## Explicitly admitted cross-run projection. It intentionally has no fields for
## episodes, habits, Presence, associations, death memories or source history.

var legacy_knowledge: Array
var diary_entries: Array
var statistic_deltas: Dictionary
var unlocks: Array[StringName]


func _init(
	p_legacy_knowledge: Array = [],
	p_diary_entries: Array = [],
	p_statistic_deltas: Dictionary = {},
	p_unlocks: Array[StringName] = []
) -> void:
	for knowledge_id in p_legacy_knowledge:
		assert(knowledge_id != null, "Legacy projection knowledge cannot be null")
		knowledge_id.assert_kind(DomainId.Kind.KNOWLEDGE)
	for entry in p_diary_entries:
		assert(entry is Dictionary, "Diary projection entries must be dictionaries")
		assert(StringName(entry.get("entry_id", "")) != &"", "Diary projection entry requires entry_id")
		assert(not String(entry.get("text", "")).strip_edges().is_empty(), "Diary projection entry requires text")
	for stat_id in p_statistic_deltas.keys():
		assert(StringName(stat_id) != &"", "Statistic id cannot be empty")
		assert(int(p_statistic_deltas[stat_id]) >= 0, "Statistic delta cannot be negative")
	for unlock_id in p_unlocks:
		assert(unlock_id != &"", "Unlock id cannot be empty")
	legacy_knowledge = p_legacy_knowledge.duplicate()
	diary_entries = p_diary_entries.duplicate(true)
	statistic_deltas = p_statistic_deltas.duplicate()
	unlocks = p_unlocks.duplicate()
