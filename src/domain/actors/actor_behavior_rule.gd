class_name ActorBehaviorRule
extends RefCounted

const DomainId = preload("res://src/domain/core/domain_id.gd")

var id: StringName
var profile_id: StringName
var required_mode: StringName
var stimulus_tag: StringName
var next_mode: StringName
var destination_place
var priority: float
var relationship_subject
var min_relationship_affinity: float
var max_relationship_affinity: float


func _init(
	p_id: StringName,
	p_profile_id: StringName,
	p_required_mode: StringName,
	p_stimulus_tag: StringName,
	p_next_mode: StringName,
	p_destination_place = null,
	p_priority: float = 0.5,
	p_relationship_subject = null,
	p_min_relationship_affinity: float = -1.0,
	p_max_relationship_affinity: float = 1.0
) -> void:
	assert(p_id != &"" and p_profile_id != &"" and p_required_mode != &"" and p_next_mode != &"", "ActorBehaviorRule ids cannot be empty")
	assert(p_priority >= 0.0 and p_priority <= 1.0, "Actor behavior priority must be within [0,1]")
	assert(is_finite(p_min_relationship_affinity) and is_finite(p_max_relationship_affinity), "Actor relationship affinity bounds must be finite")
	assert(p_min_relationship_affinity >= -1.0 and p_max_relationship_affinity <= 1.0 and p_min_relationship_affinity <= p_max_relationship_affinity, "Actor relationship affinity bounds must fit [-1,1]")
	if p_destination_place != null:
		p_destination_place.assert_kind(DomainId.Kind.PLACE)
	if p_relationship_subject != null:
		assert(p_relationship_subject.has_method("sort_key"), "Actor behavior relationship subject must be semantic")
	id = p_id
	profile_id = p_profile_id
	required_mode = p_required_mode
	stimulus_tag = p_stimulus_tag
	next_mode = p_next_mode
	destination_place = p_destination_place
	priority = p_priority
	relationship_subject = p_relationship_subject
	min_relationship_affinity = p_min_relationship_affinity
	max_relationship_affinity = p_max_relationship_affinity


func matches(state, stimuli: Array[StringName]) -> bool:
	if state.profile_id != profile_id or state.mode != required_mode:
		return false
	return stimulus_tag == &"" or stimuli.has(stimulus_tag)


func relationship_matches(relationship_store, actor) -> bool:
	if relationship_subject == null:
		return true
	if relationship_store == null:
		return false
	var value: float = relationship_store.affinity(actor, relationship_subject)
	return value >= min_relationship_affinity and value <= max_relationship_affinity
