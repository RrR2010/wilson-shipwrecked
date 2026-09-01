class_name DynamicProcessInstance
extends RefCounted

const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")

enum Lifecycle {
	ACTIVE,
	PAUSED,
	COMPLETED,
}

var id: StringName
var definition_id: StringName
var subject
var lifecycle: int
var elapsed: float


func _init(
	p_id: StringName,
	p_definition_id: StringName,
	p_subject,
	p_lifecycle: int = Lifecycle.ACTIVE,
	p_elapsed: float = 0.0
) -> void:
	assert(p_id != &"" and p_definition_id != &"", "Dynamic process ids cannot be empty")
	assert(p_subject != null and p_subject.kind == RuntimeWorldRef.Kind.ENTITY, "Dynamic process subject must be entity")
	assert(p_lifecycle >= 0 and p_lifecycle < Lifecycle.size(), "Invalid dynamic process lifecycle")
	assert(is_finite(p_elapsed) and p_elapsed >= 0.0, "Dynamic process elapsed must be finite and non-negative")
	id = p_id
	definition_id = p_definition_id
	subject = p_subject
	lifecycle = p_lifecycle
	elapsed = p_elapsed


func is_active() -> bool:
	return lifecycle == Lifecycle.ACTIVE
