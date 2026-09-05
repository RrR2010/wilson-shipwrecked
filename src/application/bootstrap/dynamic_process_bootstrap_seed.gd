class_name DynamicProcessBootstrapSeed
extends RefCounted

var id: StringName
var definition_id: StringName
var subject
var lifecycle: int
var elapsed: float


func _init(
	p_id: StringName,
	p_definition_id: StringName,
	p_subject,
	p_lifecycle: int,
	p_elapsed: float
) -> void:
	assert(p_id != &"", "DynamicProcessBootstrapSeed requires id")
	assert(p_definition_id != &"", "DynamicProcessBootstrapSeed requires definition id")
	assert(p_subject != null and p_subject.has_method("sort_key"), "DynamicProcessBootstrapSeed requires semantic subject")
	assert(p_lifecycle >= 0, "DynamicProcessBootstrapSeed lifecycle must be non-negative")
	assert(is_finite(p_elapsed) and p_elapsed >= 0.0, "DynamicProcessBootstrapSeed elapsed must be finite and non-negative")
	id = p_id
	definition_id = p_definition_id
	subject = p_subject
	lifecycle = p_lifecycle
	elapsed = p_elapsed
