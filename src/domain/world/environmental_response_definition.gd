class_name EnvironmentalResponseDefinition
extends RefCounted

const DomainId = preload("res://src/domain/core/domain_id.gd")

## Declarative mapping from one environmental magnitude to bounded ordinary World
## property change. Eligibility is expressed through reusable capability/property
## semantics rather than entity types or weather-specific callbacks.

var id: StringName
var condition_id: StringName
var target_property
var rate_per_second_at_full_exposure: float
var lower_bound: float
var upper_bound: float
var exposure_kind: StringName
var required_capability
var susceptibility_property
var minimum_susceptibility: float


func _init(
	p_id: StringName,
	p_condition_id: StringName,
	p_target_property,
	p_rate_per_second_at_full_exposure: float,
	p_lower_bound: float,
	p_upper_bound: float,
	p_exposure_kind: StringName = &"",
	p_required_capability = null,
	p_susceptibility_property = null,
	p_minimum_susceptibility: float = 0.0
) -> void:
	assert(p_id != &"", "Environmental response requires id")
	assert(p_condition_id != &"", "Environmental response requires condition id")
	assert(p_target_property != null, "Environmental response requires target property")
	p_target_property.assert_kind(DomainId.Kind.PROPERTY)
	assert(is_finite(p_rate_per_second_at_full_exposure) and not is_zero_approx(p_rate_per_second_at_full_exposure), "Environmental response rate must be finite and non-zero")
	assert(is_finite(p_lower_bound) and is_finite(p_upper_bound) and p_lower_bound <= p_upper_bound, "Environmental response bounds invalid")
	assert(is_finite(p_minimum_susceptibility) and p_minimum_susceptibility >= 0.0 and p_minimum_susceptibility <= 1.0, "Minimum susceptibility must be within [0,1]")
	if p_required_capability != null:
		p_required_capability.assert_kind(DomainId.Kind.CAPABILITY)
	if p_susceptibility_property != null:
		p_susceptibility_property.assert_kind(DomainId.Kind.PROPERTY)
	id = p_id
	condition_id = p_condition_id
	target_property = p_target_property
	rate_per_second_at_full_exposure = p_rate_per_second_at_full_exposure
	lower_bound = p_lower_bound
	upper_bound = p_upper_bound
	exposure_kind = p_exposure_kind
	required_capability = p_required_capability
	susceptibility_property = p_susceptibility_property
	minimum_susceptibility = p_minimum_susceptibility
