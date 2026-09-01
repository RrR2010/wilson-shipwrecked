class_name HabitStore
extends RefCounted

var _entries: Dictionary = {}


func apply_evidence(evidence) -> bool:
	assert(evidence != null, "HabitStore requires HabitEvidence")
	var key: StringName = evidence.key()
	var entry: Dictionary = _entries.get(key, {
		"cue_id": evidence.cue_id,
		"intention_id": evidence.intention_id,
		"bindings": evidence.bindings.duplicate_binding(),
		"strength": 0.0,
		"evidence_count": 0,
		"last_source_execution_id": &"",
	})
	var strength: float = float(entry["strength"])
	var room: float = (1.0 - strength) if evidence.strength_delta >= 0.0 else strength
	entry["strength"] = clampf(strength + evidence.strength_delta * evidence.weight * room, 0.0, 1.0)
	entry["evidence_count"] = int(entry["evidence_count"]) + 1
	entry["last_source_execution_id"] = evidence.source_execution_id
	_entries[key] = entry
	return true


func get_habit(cue_id: StringName, intention_id, bindings):
	var key: StringName = StringName("%s|%s|%s" % [String(cue_id), intention_id.sort_key(), bindings.stable_key()])
	var entry = _entries.get(key)
	return null if entry == null else _copy_entry(entry)


func entries() -> Array:
	var result: Array = []
	var keys: Array = _entries.keys()
	keys.sort_custom(func(a, b): return String(a) < String(b))
	for key in keys:
		result.append(_copy_entry(_entries[key]))
	return result


func restore_entry(
	cue_id: StringName,
	intention_id,
	bindings,
	strength: float,
	evidence_count: int,
	last_source_execution_id: StringName
) -> void:
	assert(cue_id != &"", "Habit restore requires cue id")
	assert(is_finite(strength) and strength >= 0.0 and strength <= 1.0, "Habit strength must be within [0,1]")
	assert(evidence_count >= 0, "Habit evidence count must be non-negative")
	var key: StringName = StringName("%s|%s|%s" % [String(cue_id), intention_id.sort_key(), bindings.stable_key()])
	_entries[key] = {
		"cue_id": cue_id,
		"intention_id": intention_id,
		"bindings": bindings.duplicate_binding(),
		"strength": strength,
		"evidence_count": evidence_count,
		"last_source_execution_id": last_source_execution_id,
	}


func _copy_entry(entry: Dictionary) -> Dictionary:
	var copy: Dictionary = entry.duplicate(true)
	copy["bindings"] = entry["bindings"].duplicate_binding()
	return copy
