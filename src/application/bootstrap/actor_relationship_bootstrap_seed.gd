class_name ActorRelationshipBootstrapSeed
extends RefCounted

const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")

var actor
var subject
var affinity: float
var evidence_count: int
var last_source_execution_id: StringName


func _init(
	p_actor,
	p_subject,
	p_affinity: float,
	p_evidence_count: int = 0,
	p_last_source_execution_id: StringName = &""
) -> void:
	assert(p_actor != null and p_actor.kind == RuntimeWorldRef.Kind.ENTITY, "ActorRelationshipBootstrapSeed requires entity actor")
	assert(p_subject != null and p_subject.has_method("sort_key"), "ActorRelationshipBootstrapSeed requires semantic subject")
	assert(is_finite(p_affinity) and p_affinity >= -1.0 and p_affinity <= 1.0, "Actor relationship affinity must be within [-1,1]")
	assert(p_evidence_count >= 0, "Actor relationship evidence count must be non-negative")
	actor = p_actor
	subject = p_subject
	affinity = p_affinity
	evidence_count = p_evidence_count
	last_source_execution_id = p_last_source_execution_id
