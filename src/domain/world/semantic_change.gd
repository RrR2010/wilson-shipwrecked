class_name SemanticChange
extends RefCounted

const DomainId = preload("res://src/domain/core/domain_id.gd")

enum Kind { PROPERTY, RELATION }

var kind: int
var subject
var semantic_id
var object

func _init(p_kind: int, p_subject, p_semantic_id, p_object = null) -> void:
	assert(p_kind >= 0 and p_kind < Kind.size(), "Invalid SemanticChange kind")
	assert(p_subject != null, "SemanticChange requires subject")
	assert(p_semantic_id != null, "SemanticChange requires semantic id")
	kind = p_kind
	subject = p_subject
	semantic_id = p_semantic_id
	object = p_object
	match kind:
		Kind.PROPERTY:
			semantic_id.assert_kind(DomainId.Kind.PROPERTY)
			assert(object == null, "Property change must not carry object")
		Kind.RELATION:
			semantic_id.assert_kind(DomainId.Kind.RELATION_TYPE)
			assert(object != null, "Relation change requires object")

static func property_change(p_subject, property_id):
	return new(Kind.PROPERTY, p_subject, property_id)

static func relation_change(p_subject, relation_type, p_object):
	return new(Kind.RELATION, p_subject, relation_type, p_object)
