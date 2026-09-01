class_name ExperienceLearningRule
extends RefCounted

const DomainId = preload("res://src/domain/core/domain_id.gd")

var event_type
var perceived_role: StringName
var association_valence_delta: float
var association_attachment_delta: float
var episode_importance: float
var habit_cue_id: StringName
var habit_intention_id
var habit_binding_role: StringName
var habit_strength_delta: float


func _init(
	p_event_type,
	p_perceived_role: StringName,
	p_association_valence_delta: float = 0.0,
	p_association_attachment_delta: float = 0.0,
	p_episode_importance: float = 0.0,
	p_habit_cue_id: StringName = &"",
	p_habit_intention_id = null,
	p_habit_binding_role: StringName = &"",
	p_habit_strength_delta: float = 0.0
) -> void:
	assert(p_event_type != null, "ExperienceLearningRule requires event type")
	p_event_type.assert_kind(DomainId.Kind.EVENT_DEFINITION)
	assert(p_perceived_role != &"", "ExperienceLearningRule requires perceived role")
	assert(is_finite(p_association_valence_delta) and p_association_valence_delta >= -1.0 and p_association_valence_delta <= 1.0, "Association valence delta must be within [-1,1]")
	assert(is_finite(p_association_attachment_delta) and p_association_attachment_delta >= 0.0 and p_association_attachment_delta <= 1.0, "Association attachment delta must be within [0,1]")
	assert(is_finite(p_episode_importance) and p_episode_importance >= 0.0 and p_episode_importance <= 1.0, "Episode importance must be within [0,1]")
	assert(is_finite(p_habit_strength_delta) and p_habit_strength_delta >= -1.0 and p_habit_strength_delta <= 1.0, "Habit strength delta must be within [-1,1]")
	var has_habit: bool = p_habit_cue_id != &"" or p_habit_intention_id != null or p_habit_binding_role != &"" or not is_zero_approx(p_habit_strength_delta)
	if has_habit:
		assert(p_habit_cue_id != &"" and p_habit_intention_id != null and p_habit_binding_role != &"", "Habit learning rule requires cue, intention and binding role together")
		p_habit_intention_id.assert_kind(DomainId.Kind.SEMANTIC_INTENTION)
	event_type = p_event_type
	perceived_role = p_perceived_role
	association_valence_delta = p_association_valence_delta
	association_attachment_delta = p_association_attachment_delta
	episode_importance = p_episode_importance
	habit_cue_id = p_habit_cue_id
	habit_intention_id = p_habit_intention_id
	habit_binding_role = p_habit_binding_role
	habit_strength_delta = p_habit_strength_delta


func matches(claim) -> bool:
	return claim != null and claim.semantic_id.equals(event_type) and claim.role_name == perceived_role


func has_association_impact() -> bool:
	return not is_zero_approx(association_valence_delta) or association_attachment_delta > 0.0


func has_habit_evidence() -> bool:
	return habit_cue_id != &""
