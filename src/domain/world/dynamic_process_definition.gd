class_name DynamicProcessDefinition
extends RefCounted

const DomainId = preload("res://src/domain/core/domain_id.gd")

var id: StringName
var target_property
var rate_per_second: float
var lower_bound: float
var upper_bound: float


func _init(
	p_id: StringName,
	p_target_property,
	p_rate_per_second: float,
	p_lower_bound: float,
	p_upper_bound: float
) -> void:
	assert(p_id != &"", "DynamicProcessDefinition requires id")
	assert(p_target_property != null, "DynamicProcessDefinition requires target property")
	p_target_property.assert_kind(DomainId.Kind.PROPERTY)
	assert(is_finite(p_rate_per_second) and not is_zero_approx(p_rate_per_second), "Dynamic process rate must be finite and non-zero")
	assert(is_finite(p_lower_bound) and is_finite(p_upper_bound) and p_lower_bound <= p_upper_bound, "Dynamic process bounds invalid")
	id = p_id
	target_property = p_target_property
	rate_per_second = p_rate_per_second
	lower_bound = p_lower_bound
	upper_bound = p_upper_bound


func terminal_value() -> float:
	return upper_bound if rate_per_second > 0.0 else lower_bound
