class_name RequirementPredicate
extends RefCounted

## Bounded declarative predicate AST for fully-bound action validation.
## No arbitrary callbacks/scripts are permitted in authored requirements.

enum Kind {
	ALL_OF,
	ANY_OF,
	NOT,
	HAS_CAPABILITY,
	HAS_CATEGORY,
	PROPERTY_COMPARE,
	HAS_RELATION,
}

enum CompareOp {
	EQ,
	NE,
	LT,
	LTE,
	GT,
	GTE,
}

var kind: int
var children: Array = []
var role_name: StringName = &""
var other_role_name: StringName = &""
var semantic_id = null
var compare_op: int = CompareOp.EQ
var expected_value: Variant = null


func _init(p_kind: int) -> void:
	assert(p_kind >= 0 and p_kind < Kind.size(), "Invalid RequirementPredicate kind")
	kind = p_kind


static func all_of(p_children: Array):
	var node = new(Kind.ALL_OF)
	node.children = p_children.duplicate()
	return node


static func any_of(p_children: Array):
	var node = new(Kind.ANY_OF)
	node.children = p_children.duplicate()
	return node


static func negate(child):
	var node = new(Kind.NOT)
	node.children = [child]
	return node


static func has_capability(p_role_name: StringName, capability_id):
	var node = new(Kind.HAS_CAPABILITY)
	node.role_name = p_role_name
	node.semantic_id = capability_id
	return node


static func has_category(p_role_name: StringName, category_id):
	var node = new(Kind.HAS_CATEGORY)
	node.role_name = p_role_name
	node.semantic_id = category_id
	return node


static func property_compare(p_role_name: StringName, property_id, p_compare_op: int, p_expected_value: Variant):
	var node = new(Kind.PROPERTY_COMPARE)
	node.role_name = p_role_name
	node.semantic_id = property_id
	node.compare_op = p_compare_op
	node.expected_value = p_expected_value
	return node


static func has_relation(p_subject_role: StringName, relation_type_id, p_object_role: StringName):
	var node = new(Kind.HAS_RELATION)
	node.role_name = p_subject_role
	node.other_role_name = p_object_role
	node.semantic_id = relation_type_id
	return node
