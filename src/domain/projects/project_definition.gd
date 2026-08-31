class_name ProjectDefinition
extends RefCounted

const DomainId = preload("res://src/domain/core/domain_id.gd")

var id
var contribution_action_id
var contribution_event_type
var project_subject_role: StringName
var action_subject_role: StringName
var intention_id
var required_contributions: int
var candidate_base_score: float


func _init(
	p_id,
	p_contribution_action_id,
	p_contribution_event_type,
	p_project_subject_role: StringName,
	p_action_subject_role: StringName,
	p_intention_id,
	p_required_contributions: int,
	p_candidate_base_score: float = 0.25
) -> void:
	assert(p_id != null, "ProjectDefinition requires id")
	p_id.assert_kind(DomainId.Kind.PROJECT_DEFINITION)
	assert(p_contribution_action_id != null, "ProjectDefinition requires contribution action")
	p_contribution_action_id.assert_kind(DomainId.Kind.ACTION)
	assert(p_contribution_event_type != null, "ProjectDefinition requires contribution event")
	p_contribution_event_type.assert_kind(DomainId.Kind.EVENT_DEFINITION)
	assert(p_project_subject_role != &"" and p_action_subject_role != &"", "ProjectDefinition requires semantic roles")
	assert(p_intention_id != null, "ProjectDefinition requires candidate intention")
	p_intention_id.assert_kind(DomainId.Kind.SEMANTIC_INTENTION)
	assert(p_required_contributions > 0, "ProjectDefinition required contributions must be positive")
	assert(is_finite(p_candidate_base_score), "Project candidate score must be finite")
	assert(p_candidate_base_score >= 0.0 and p_candidate_base_score <= 1.0, "Project candidate score must be within [0,1]")
	id = p_id
	contribution_action_id = p_contribution_action_id
	contribution_event_type = p_contribution_event_type
	project_subject_role = p_project_subject_role
	action_subject_role = p_action_subject_role
	intention_id = p_intention_id
	required_contributions = p_required_contributions
	candidate_base_score = p_candidate_base_score
