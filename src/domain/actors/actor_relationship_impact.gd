class_name ActorRelationshipImpact
extends RefCounted

var actor
var subject
var affinity_delta: float
var weight: float
var source_execution_id: StringName


func _init(
	p_actor,
	p_subject,
	p_affinity_delta: float,
	p_weight: float = 1.0,
	p_source_execution_id: StringName = &""
) -> void:
	assert(p_actor != null and p_actor.has_method("sort_key"), "ActorRelationshipImpact requires actor ref")
	assert(p_subject != null and p_subject.has_method("sort_key"), "ActorRelationshipImpact requires relationship subject")
	assert(is_finite(p_affinity_delta) and p_affinity_delta >= -1.0 and p_affinity_delta <= 1.0, "Actor relationship affinity delta must be within [-1,1]")
	assert(is_finite(p_weight) and p_weight >= 0.0 and p_weight <= 1.0, "Actor relationship impact weight must be within [0,1]")
	actor = p_actor
	subject = p_subject
	affinity_delta = p_affinity_delta
	weight = p_weight
	source_execution_id = p_source_execution_id
