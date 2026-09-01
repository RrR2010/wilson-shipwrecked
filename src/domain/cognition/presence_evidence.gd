class_name PresenceEvidence
extends RefCounted

var belief_delta: float
var trust_delta: float
var dependency_delta: float
var weight: float
var source_execution_id: StringName


func _init(
	p_belief_delta: float,
	p_trust_delta: float,
	p_dependency_delta: float,
	p_weight: float,
	p_source_execution_id: StringName
) -> void:
	assert(is_finite(p_belief_delta) and p_belief_delta >= -1.0 and p_belief_delta <= 1.0, "Presence belief delta must be within [-1,1]")
	assert(is_finite(p_trust_delta) and p_trust_delta >= -1.0 and p_trust_delta <= 1.0, "Presence trust delta must be within [-1,1]")
	assert(is_finite(p_dependency_delta) and p_dependency_delta >= -1.0 and p_dependency_delta <= 1.0, "Presence dependency delta must be within [-1,1]")
	assert(is_finite(p_weight) and p_weight >= 0.0 and p_weight <= 1.0, "Presence evidence weight must be within [0,1]")
	assert(p_source_execution_id != &"", "PresenceEvidence requires source execution id")
	belief_delta = p_belief_delta
	trust_delta = p_trust_delta
	dependency_delta = p_dependency_delta
	weight = p_weight
	source_execution_id = p_source_execution_id
