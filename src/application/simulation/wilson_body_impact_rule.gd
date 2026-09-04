class_name WilsonBodyImpactRule
extends RefCounted

const DomainId = preload("res://src/domain/core/domain_id.gd")
const PhysicalObservation = preload("res://src/application/simulation/physical_observation.gd")

## Authored body-effect policy for a physical observation already at the
## engine/domain boundary. Damage is semantic policy, never inferred by Godot.

var observation_kind: int
var minimum_magnitude: float
var damage_fraction: float
var injury_event_type
var death_event_type
var require_other: bool


func _init(
	p_observation_kind: int,
	p_minimum_magnitude: float,
	p_damage_fraction: float,
	p_injury_event_type,
	p_death_event_type,
	p_require_other: bool = false
) -> void:
	assert(p_observation_kind >= PhysicalObservation.Kind.CONTACT and p_observation_kind <= PhysicalObservation.Kind.FALL)
	assert(is_finite(p_minimum_magnitude) and p_minimum_magnitude >= 0.0)
	assert(is_finite(p_damage_fraction) and p_damage_fraction > 0.0)
	assert(p_injury_event_type != null and p_death_event_type != null)
	p_injury_event_type.assert_kind(DomainId.Kind.EVENT_DEFINITION)
	p_death_event_type.assert_kind(DomainId.Kind.EVENT_DEFINITION)
	observation_kind = p_observation_kind
	minimum_magnitude = p_minimum_magnitude
	damage_fraction = p_damage_fraction
	injury_event_type = p_injury_event_type
	death_event_type = p_death_event_type
	require_other = p_require_other


func admits(observation) -> bool:
	if observation == null or observation.kind != observation_kind:
		return false
	if observation.magnitude < minimum_magnitude:
		return false
	return not require_other or observation.other != null
