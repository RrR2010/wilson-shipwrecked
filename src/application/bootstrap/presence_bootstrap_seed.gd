class_name PresenceBootstrapSeed
extends RefCounted

var presence_belief: float
var trust: float
var dependency: float
var evidence_count: int
var last_source_execution_id: StringName


func _init(
	p_presence_belief: float = 0.0,
	p_trust: float = 0.0,
	p_dependency: float = 0.0,
	p_evidence_count: int = 0,
	p_last_source_execution_id: StringName = &""
) -> void:
	assert(is_finite(p_presence_belief) and p_presence_belief >= 0.0 and p_presence_belief <= 1.0, "Presence seed belief must be within [0,1]")
	assert(is_finite(p_trust) and p_trust >= -1.0 and p_trust <= 1.0, "Presence seed trust must be within [-1,1]")
	assert(is_finite(p_dependency) and p_dependency >= 0.0 and p_dependency <= 1.0, "Presence seed dependency must be within [0,1]")
	assert(p_evidence_count >= 0, "Presence seed evidence count must be non-negative")
	presence_belief = p_presence_belief
	trust = p_trust
	dependency = p_dependency
	evidence_count = p_evidence_count
	last_source_execution_id = p_last_source_execution_id
