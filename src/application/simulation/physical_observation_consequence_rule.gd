class_name PhysicalObservationConsequenceRule
extends RefCounted

const DomainId = preload("res://src/domain/core/domain_id.gd")
const PhysicalObservation = preload("res://src/application/simulation/physical_observation.gd")

## Authored admission rule from a non-authoritative engine observation to a
## semantic World event. This rule does not imply injury or arbitrary mutation.

var observation_kind: int
var event_type
var minimum_magnitude: float
var subject_role: StringName
var other_role: StringName
var require_other: bool


func _init(
	p_observation_kind: int,
	p_event_type,
	p_minimum_magnitude: float = 0.0,
	p_subject_role: StringName = &"subject",
	p_other_role: StringName = &"other",
	p_require_other: bool = false
) -> void:
	assert(p_observation_kind >= PhysicalObservation.Kind.CONTACT and p_observation_kind <= PhysicalObservation.Kind.FALL)
	assert(p_event_type != null)
	p_event_type.assert_kind(DomainId.Kind.EVENT_DEFINITION)
	assert(is_finite(p_minimum_magnitude) and p_minimum_magnitude >= 0.0)
	assert(p_subject_role != &"")
	assert(p_other_role != &"")
	observation_kind = p_observation_kind
	event_type = p_event_type
	minimum_magnitude = p_minimum_magnitude
	subject_role = p_subject_role
	other_role = p_other_role
	require_other = p_require_other


func admits(observation) -> bool:
	if observation == null or observation.kind != observation_kind:
		return false
	if observation.magnitude < minimum_magnitude:
		return false
	return not require_other or observation.other != null
