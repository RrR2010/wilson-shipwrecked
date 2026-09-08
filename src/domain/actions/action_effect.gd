class_name ActionEffect
extends RefCounted

const DomainId = preload("res://src/domain/core/domain_id.gd")
const SemanticValueKey = preload("res://src/domain/core/semantic_value_key.gd")

## Declarative authoritative mutation requested by an ActionOutcome.
## Action execution emits effects; only the owning World command port applies them.

enum Kind {
	SET_PROPERTY,
	CREATE_RELATION,
	REMOVE_RELATION,
	CHANGE_QUANTITY,
}

var kind: int
var subject_role: StringName
var object_role: StringName
var semantic_id
var value: Variant


func _init(
	p_kind: int,
	p_subject_role: StringName,
	p_semantic_id = null,
	p_value: Variant = null,
	p_object_role: StringName = &""
) -> void:
	assert(p_kind >= 0 and p_kind < Kind.size(), "Invalid ActionEffect kind")
	assert(p_subject_role != &"", "ActionEffect requires subject role")
	kind = p_kind
	subject_role = p_subject_role
	object_role = p_object_role
	semantic_id = p_semantic_id
	value = p_value
	match kind:
		Kind.SET_PROPERTY:
			assert(semantic_id != null, "SET_PROPERTY requires semantic id")
			semantic_id.assert_kind(DomainId.Kind.PROPERTY)
		Kind.CREATE_RELATION, Kind.REMOVE_RELATION:
			assert(semantic_id != null, "Relation effect requires semantic id")
			semantic_id.assert_kind(DomainId.Kind.RELATION_TYPE)
			assert(object_role != &"", "Relation effect requires object role")
			assert(SemanticValueKey.supports(value), "Relation effect qualifier must be a bounded semantic value")
		Kind.CHANGE_QUANTITY:
			assert(semantic_id == null, "CHANGE_QUANTITY does not use semantic id")
			assert(object_role == &"", "CHANGE_QUANTITY does not use object role")
			assert(value is int or value is float, "CHANGE_QUANTITY requires numeric delta")
			assert(is_finite(float(value)), "CHANGE_QUANTITY requires finite delta")


static func change_quantity(p_subject_role: StringName, delta: Variant):
	return new(Kind.CHANGE_QUANTITY, p_subject_role, null, delta)
