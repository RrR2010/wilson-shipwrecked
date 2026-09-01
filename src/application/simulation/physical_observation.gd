class_name PhysicalObservation
extends RefCounted

const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")

## Engine-observed physical fact awaiting authoritative consequence resolution.
##
## This value does not itself mutate World or imply injury/damage/success.

enum Kind {
	CONTACT,
	OVERLAP_ENTERED,
	OVERLAP_EXITED,
	GROUNDING_CHANGED,
	FALL,
}

var kind: int
var subject: RuntimeWorldRef
var other: RuntimeWorldRef
var magnitude: float
var point: Vector3
var normal: Vector3

func _init(
	p_kind: int,
	p_subject: RuntimeWorldRef,
	p_other: RuntimeWorldRef = null,
	p_magnitude: float = 0.0,
	p_point: Vector3 = Vector3.ZERO,
	p_normal: Vector3 = Vector3.ZERO
) -> void:
	assert(p_kind >= Kind.CONTACT and p_kind <= Kind.FALL)
	assert(p_subject != null)
	assert(is_finite(p_magnitude) and p_magnitude >= 0.0)
	assert(p_point.is_finite())
	assert(p_normal.is_finite())
	kind = p_kind
	subject = p_subject
	other = p_other
	magnitude = p_magnitude
	point = p_point
	normal = p_normal
