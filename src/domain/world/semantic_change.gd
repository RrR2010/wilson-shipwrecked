class_name SemanticChange
extends RefCounted

const DomainId = preload("res://src/domain/core/domain_id.gd")

enum Kind { PROPERTY, RELATION, QUANTITY }

var kind: int
var subject
var semantic_id
var object

func _init(p_kind: int, p_subject, p_semantic_id = null, p_object = null) -> void:
	assert(p_kind >= 0 and p_kind < Kind.size(), "Invalid SemanticChange kind")
	assert(p_subject != null, "SemanticChange requires subject")
	kind = p_kind
	subject = p_subject
	semantic_id = p_semantic_id
	object = p_object
	match kind:
		Kind.PROPERTY:
			assert(semantic_id != null, "Property change requires semantic id")
			semantic_id.assert_kind(DomainId.Kind.PROPERTY)
			assert(object == null, "Property change must not carry object")
		Kind.RELATION:
			assert(semantic_id != null, "Relation change requires semantic id")
			semantic_id.assert_kind(DomainId.Kind.RELATION_TYPE)
			assert(object != null, "Relation change requires object")
		Kind.QUANTITY:
			assert(semantic_id == null and object == null, "Quantity change carries only subject")

static func property_change(p_subject, property_id):
	return new(Kind.PROPERTY, p_subject, property_id)

static func relation_change(p_subject, relation_type, p_object):
	return new(Kind.RELATION, p_subject, relation_type, p_object)

static func quantity_change(p_subject):
	return new(Kind.QUANTITY, p_subject)
