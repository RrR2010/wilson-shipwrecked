class_name ActorRelationshipStore
extends RefCounted

var _entries: Dictionary = {}


func apply_impact(impact) -> bool:
	assert(impact != null, "ActorRelationshipStore requires ActorRelationshipImpact")
	var key := _key(impact.actor, impact.subject)
	var entry: Dictionary = _entries.get(key, {
		"actor": impact.actor,
		"subject": impact.subject,
		"affinity": 0.0,
		"evidence_count": 0,
		"last_source_execution_id": &"",
	})
	var affinity: float = float(entry["affinity"])
	var room: float = 1.0 - abs(affinity)
	var step: float = impact.affinity_delta * impact.weight * maxf(0.25, room)
	entry["affinity"] = clampf(affinity + step, -1.0, 1.0)
	entry["evidence_count"] = int(entry["evidence_count"]) + 1
	entry["last_source_execution_id"] = impact.source_execution_id
	_entries[key] = entry
	return true


func get_relationship(actor, subject):
	assert(actor != null and actor.has_method("sort_key"), "ActorRelationshipStore.get_relationship requires actor ref")
	assert(subject != null and subject.has_method("sort_key"), "ActorRelationshipStore.get_relationship requires subject")
	var entry = _entries.get(_key(actor, subject))
	return null if entry == null else entry.duplicate(true)


func affinity(actor, subject) -> float:
	var entry = get_relationship(actor, subject)
	return 0.0 if entry == null else float(entry["affinity"])


func entries() -> Array:
	var result: Array = []
	var keys: Array = _entries.keys()
	keys.sort()
	for key in keys:
		result.append(_entries[key].duplicate(true))
	return result


func restore_entry(actor, subject, p_affinity: float, evidence_count: int, last_source_execution_id: StringName) -> void:
	assert(actor != null and actor.has_method("sort_key"), "Actor relationship restore requires actor ref")
	assert(subject != null and subject.has_method("sort_key"), "Actor relationship restore requires subject")
	assert(is_finite(p_affinity) and p_affinity >= -1.0 and p_affinity <= 1.0, "Actor relationship affinity must be within [-1,1]")
	assert(evidence_count >= 0, "Actor relationship evidence count must be non-negative")
	_entries[_key(actor, subject)] = {
		"actor": actor,
		"subject": subject,
		"affinity": p_affinity,
		"evidence_count": evidence_count,
		"last_source_execution_id": last_source_execution_id,
	}


func _key(actor, subject) -> String:
	return "%s|%s" % [actor.sort_key(), subject.sort_key()]
