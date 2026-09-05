class_name ProjectBootstrapSeed
extends RefCounted

var id
var definition_id
var subject_bindings
var lifecycle: int
var contribution_count: int


func _init(
	p_id,
	p_definition_id,
	p_subject_bindings,
	p_lifecycle: int,
	p_contribution_count: int
) -> void:
	assert(p_id != null, "ProjectBootstrapSeed requires project instance id")
	assert(p_definition_id != null, "ProjectBootstrapSeed requires project definition id")
	assert(p_subject_bindings != null, "ProjectBootstrapSeed requires subject bindings")
	assert(p_contribution_count >= 0, "ProjectBootstrapSeed contribution count must be non-negative")
	id = p_id
	definition_id = p_definition_id
	subject_bindings = p_subject_bindings.duplicate_binding()
	lifecycle = p_lifecycle
	contribution_count = p_contribution_count
