class_name RelationFailureDefinition
extends RefCounted

const DomainId = preload("res://src/domain/core/domain_id.gd")

enum Compare { LTE, GTE }

## Authored structural boundary: an authoritative property on a relation subject
## can invalidate that relation when it crosses a bounded threshold. This remains
## relation/property semantics; no shelter, roof, weather, or entity type is encoded.

var id: StringName
var relation_type
var monitored_property
var threshold: float
var compare: int
var qualifier: Variant


func _init(
	p_id: StringName,
	p_relation_type,
	p_monitored_property,
	p_threshold: float,
	p_compare: int = Compare.LTE,
	p_qualifier: Variant = null
) -> void:
	assert(p_id != &"", "Relation failure definition requires id")
	assert(p_relation_type != null, "Relation failure definition requires relation type")
	assert(p_monitored_property != null, "Relation failure definition requires monitored property")
	p_relation_type.assert_kind(DomainId.Kind.RELATION_TYPE)
	p_monitored_property.assert_kind(DomainId.Kind.PROPERTY)
	assert(is_finite(p_threshold), "Relation failure threshold must be finite")
	assert(p_compare >= Compare.LTE and p_compare <= Compare.GTE, "Invalid relation failure comparison")
	id = p_id
	relation_type = p_relation_type
	monitored_property = p_monitored_property
	threshold = p_threshold
	compare = p_compare
	qualifier = p_qualifier


func is_failed(value: float) -> bool:
	match compare:
		Compare.LTE:
			return value <= threshold
		Compare.GTE:
			return value >= threshold
	return false
