class_name AssociationStore
extends RefCounted

var _entries: Dictionary = {}


func apply_impact(impact) -> bool:
	assert(impact != null, "AssociationStore requires AssociationImpact")
	var key: String = impact.subject.sort_key()
	var entry: Dictionary = _entries.get(key, {
		"subject": impact.subject,
		"valence": 0.0,
		"attachment": 0.0,
		"evidence_count": 0,
		"last_source_execution_id": &"",
	})
	var valence: float = float(entry["valence"])
	var valence_room: float = 1.0 - abs(valence)
	var valence_step: float = impact.valence_delta * impact.weight * maxf(0.25, valence_room)
	entry["valence"] = clampf(valence + valence_step, -1.0, 1.0)
	var attachment: float = float(entry["attachment"])
	entry["attachment"] = clampf(
		attachment + impact.attachment_delta * impact.weight * (1.0 - attachment),
		0.0,
		1.0
	)
	entry["evidence_count"] = int(entry["evidence_count"]) + 1
	entry["last_source_execution_id"] = impact.source_execution_id
	_entries[key] = entry
	return true


func get(subject):
	assert(subject != null and subject.has_method("sort_key"), "AssociationStore.get requires semantic subject")
	var entry = _entries.get(subject.sort_key())
	return null if entry == null else entry.duplicate(true)


func entries() -> Array:
	var result: Array = []
	var keys: Array = _entries.keys()
	keys.sort()
	for key in keys:
		result.append(_entries[key].duplicate(true))
	return result


func restore_entry(subject, valence: float, attachment: float, evidence_count: int, last_source_execution_id: StringName) -> void:
	assert(subject != null and subject.has_method("sort_key"), "Association restore requires semantic subject")
	assert(is_finite(valence) and valence >= -1.0 and valence <= 1.0, "Association valence must be within [-1,1]")
	assert(is_finite(attachment) and attachment >= 0.0 and attachment <= 1.0, "Association attachment must be within [0,1]")
	assert(evidence_count >= 0, "Association evidence count must be non-negative")
	_entries[subject.sort_key()] = {
		"subject": subject,
		"valence": valence,
		"attachment": attachment,
		"evidence_count": evidence_count,
		"last_source_execution_id": last_source_execution_id,
	}
