class_name PresenceRelationship
extends RefCounted

var presence_belief: float
var trust: float
var dependency: float
var evidence_count: int = 0
var last_source_execution_id: StringName = &""


func _init(p_presence_belief: float = 0.0, p_trust: float = 0.0, p_dependency: float = 0.0) -> void:
	assert(is_finite(p_presence_belief) and p_presence_belief >= 0.0 and p_presence_belief <= 1.0, "Presence belief must be within [0,1]")
	assert(is_finite(p_trust) and p_trust >= -1.0 and p_trust <= 1.0, "Presence trust must be within [-1,1]")
	assert(is_finite(p_dependency) and p_dependency >= 0.0 and p_dependency <= 1.0, "Presence dependency must be within [0,1]")
	presence_belief = p_presence_belief
	trust = p_trust
	dependency = p_dependency


func apply_evidence(evidence) -> void:
	assert(evidence != null, "PresenceRelationship requires PresenceEvidence")
	presence_belief = _apply_unit_interval(presence_belief, evidence.belief_delta, evidence.weight)
	trust = _apply_signed_unit(trust, evidence.trust_delta, evidence.weight)
	dependency = _apply_unit_interval(dependency, evidence.dependency_delta, evidence.weight)
	evidence_count += 1
	last_source_execution_id = evidence.source_execution_id


func restore(p_presence_belief: float, p_trust: float, p_dependency: float, p_evidence_count: int, p_last_source_execution_id: StringName) -> void:
	assert(is_finite(p_presence_belief) and p_presence_belief >= 0.0 and p_presence_belief <= 1.0, "Presence belief must be within [0,1]")
	assert(is_finite(p_trust) and p_trust >= -1.0 and p_trust <= 1.0, "Presence trust must be within [-1,1]")
	assert(is_finite(p_dependency) and p_dependency >= 0.0 and p_dependency <= 1.0, "Presence dependency must be within [0,1]")
	assert(p_evidence_count >= 0, "Presence evidence count must be non-negative")
	presence_belief = p_presence_belief
	trust = p_trust
	dependency = p_dependency
	evidence_count = p_evidence_count
	last_source_execution_id = p_last_source_execution_id


func _apply_unit_interval(current: float, delta: float, weight: float) -> float:
	var room: float = (1.0 - current) if delta >= 0.0 else current
	return clampf(current + delta * weight * room, 0.0, 1.0)


func _apply_signed_unit(current: float, delta: float, weight: float) -> float:
	var room: float = (1.0 - current) if delta >= 0.0 else (1.0 + current)
	return clampf(current + delta * weight * room, -1.0, 1.0)
