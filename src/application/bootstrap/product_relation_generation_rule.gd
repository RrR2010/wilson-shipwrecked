class_name ProductRelationGenerationRule
extends RefCounted

const DomainId = preload("res://src/domain/core/domain_id.gd")

## Authored bounded rule for generating durable relation bootstrap causes between
## entity families produced by ProductEntityGenerationRule.

var id: StringName
var relation_type
var subject_prefix: StringName
var object_prefix: StringName
var min_count: int
var max_count: int
var qualifier: Variant


func _init(
	p_id: StringName,
	p_relation_type,
	p_subject_prefix: StringName,
	p_object_prefix: StringName,
	p_min_count: int,
	p_max_count: int,
	p_qualifier: Variant = null
) -> void:
	assert(p_id != &"", "ProductRelationGenerationRule requires id")
	assert(p_relation_type != null, "ProductRelationGenerationRule requires relation type")
	p_relation_type.assert_kind(DomainId.Kind.RELATION_TYPE)
	assert(p_subject_prefix != &"", "ProductRelationGenerationRule requires subject prefix")
	assert(p_object_prefix != &"", "ProductRelationGenerationRule requires object prefix")
	assert(p_min_count >= 0, "ProductRelationGenerationRule min_count must be non-negative")
	assert(p_max_count >= p_min_count, "ProductRelationGenerationRule max_count must be >= min_count")
	id = p_id
	relation_type = p_relation_type
	subject_prefix = p_subject_prefix
	object_prefix = p_object_prefix
	min_count = p_min_count
	max_count = p_max_count
	qualifier = p_qualifier


func sort_key() -> String:
	return String(id)
