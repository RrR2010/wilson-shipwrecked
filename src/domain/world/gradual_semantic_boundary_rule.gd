class_name GradualSemanticBoundaryRule
extends RefCounted

const DomainId = preload("res://src/domain/core/domain_id.gd")

enum Direction { RISING, FALLING }

var id: StringName
var target_property
var threshold: float
var direction: int
var event_type
var subject_role: StringName


func _init(
	p_id: StringName,
	p_target_property,
	p_threshold: float,
	p_direction: int,
	p_event_type,
	p_subject_role: StringName = &"subject"
) -> void:
	assert(p_id != &"", "Gradual semantic boundary rule requires id")
	assert(p_target_property != null, "Gradual semantic boundary rule requires property")
	p_target_property.assert_kind(DomainId.Kind.PROPERTY)
	assert(is_finite(p_threshold), "Gradual semantic threshold must be finite")
	assert(p_direction == Direction.RISING or p_direction == Direction.FALLING, "Invalid gradual semantic boundary direction")
	assert(p_event_type != null, "Gradual semantic boundary rule requires event type")
	p_event_type.assert_kind(DomainId.Kind.EVENT_DEFINITION)
	assert(p_subject_role != &"", "Gradual semantic boundary subject role cannot be empty")
	id = p_id
	target_property = p_target_property
	threshold = p_threshold
	direction = p_direction
	event_type = p_event_type
	subject_role = p_subject_role


func matches_transition(transition: Dictionary) -> bool:
	if not transition.has("property") or not transition.has("previous") or not transition.has("current"):
		return false
	var property = transition["property"]
	if property == null or not property.has_method("key") or property.key() != target_property.key():
		return false
	var previous: float = float(transition["previous"])
	var current: float = float(transition["current"])
	if direction == Direction.RISING:
		return previous < threshold and current >= threshold
	return previous > threshold and current <= threshold
