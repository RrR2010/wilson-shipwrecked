class_name ProjectInstance
extends RefCounted

const DomainId = preload("res://src/domain/core/domain_id.gd")

enum Lifecycle { ACTIVE, PAUSED, COMPLETED, ABANDONED }

var id
var definition_id
var lifecycle: int
var subject_bindings
var contribution_count: int


func _init(p_id, p_definition_id, p_subject_bindings, p_lifecycle: int = Lifecycle.ACTIVE, p_contribution_count: int = 0) -> void:
	assert(p_id != null, "ProjectInstance requires id")
	p_id.assert_kind(DomainId.Kind.PROJECT_INSTANCE)
	assert(p_definition_id != null, "ProjectInstance requires definition id")
	p_definition_id.assert_kind(DomainId.Kind.PROJECT_DEFINITION)
	assert(p_subject_bindings != null, "ProjectInstance requires subject bindings")
	assert(p_lifecycle >= Lifecycle.ACTIVE and p_lifecycle <= Lifecycle.ABANDONED, "Invalid project lifecycle")
	assert(p_contribution_count >= 0, "Project contribution count must be non-negative")
	id = p_id
	definition_id = p_definition_id
	subject_bindings = p_subject_bindings.duplicate_binding()
	lifecycle = p_lifecycle
	contribution_count = p_contribution_count


func is_active() -> bool:
	return lifecycle == Lifecycle.ACTIVE
