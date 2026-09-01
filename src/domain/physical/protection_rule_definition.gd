class_name ProtectionRuleDefinition
extends RefCounted

const DomainId = preload("res://src/domain/core/domain_id.gd")

## Authored semantics for deriving shielding from ordinary World configuration.
## The relation makes protection configuration-relative; source properties supply
## bounded coverage and strength.

var id: StringName
var exposure_kind: StringName
var relation_type
var coverage_property
var strength_property


func _init(
	p_id: StringName,
	p_exposure_kind: StringName,
	p_relation_type,
	p_coverage_property,
	p_strength_property
) -> void:
	assert(p_id != &"" and p_exposure_kind != &"", "ProtectionRuleDefinition ids cannot be empty")
	assert(p_relation_type != null and p_coverage_property != null and p_strength_property != null, "ProtectionRuleDefinition requires semantic ids")
	p_relation_type.assert_kind(DomainId.Kind.RELATION_TYPE)
	p_coverage_property.assert_kind(DomainId.Kind.PROPERTY)
	p_strength_property.assert_kind(DomainId.Kind.PROPERTY)
	id = p_id
	exposure_kind = p_exposure_kind
	relation_type = p_relation_type
	coverage_property = p_coverage_property
	strength_property = p_strength_property
