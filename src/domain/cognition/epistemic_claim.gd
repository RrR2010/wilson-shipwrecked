class_name EpistemicClaim
extends RefCounted

const DomainId = preload("res://src/domain/core/domain_id.gd")

## Closed tagged algebra for durable Wilson-relative claims.
## Claim identity is explicit and deterministic; no generic predicate/argument
## serialization participates in durable belief identity.

enum Kind {
	PROPERTY,
	RELATION,
	EVENT,
}

var kind: int
var subject
var semantic_id
var value: Variant = null
var object = null
var role_name: StringName = &""


func _init(
	p_kind: int,
	p_subject,
	p_semantic_id,
	p_value: Variant = null,
	p_object = null,
	p_role_name: StringName = &""
) -> void:
	assert(p_kind >= 0 and p_kind < Kind.size(), "Invalid EpistemicClaim kind")
	assert(p_subject != null, "EpistemicClaim requires subject")
	assert(p_subject is Object and p_subject.has_method("sort_key"), "EpistemicClaim subject requires stable semantic identity")
	assert(p_semantic_id != null, "EpistemicClaim requires semantic id")
	kind = p_kind
	subject = p_subject
	semantic_id = p_semantic_id
	value = p_value
	object = p_object
	role_name = p_role_name
	match kind:
		Kind.PROPERTY:
			semantic_id.assert_kind(DomainId.Kind.PROPERTY)
			assert(value != null, "Property claim requires value")
			assert(object == null and role_name == &"", "Property claim carries only subject/property/value")
		Kind.RELATION:
			semantic_id.assert_kind(DomainId.Kind.RELATION_TYPE)
			assert(object != null, "Relation claim requires object")
			assert(object is Object and object.has_method("sort_key"), "Relation claim object requires stable semantic identity")
			assert(value == null and role_name == &"", "Relation claim carries only subject/relation/object")
		Kind.EVENT:
			semantic_id.assert_kind(DomainId.Kind.EVENT_DEFINITION)
			assert(role_name != &"", "Event claim requires perceived role")
			assert(value == null and object == null, "Event claim carries only subject/event/role")


static func property_claim(p_subject, property_id, p_value: Variant):
	return new(Kind.PROPERTY, p_subject, property_id, p_value)


static func relation_claim(p_subject, relation_type, p_object):
	return new(Kind.RELATION, p_subject, relation_type, null, p_object)


static func event_claim(p_subject, event_type, p_role_name: StringName):
	return new(Kind.EVENT, p_subject, event_type, null, null, p_role_name)


func tag() -> StringName:
	match kind:
		Kind.PROPERTY: return &"property_claim"
		Kind.RELATION: return &"relation_claim"
		Kind.EVENT: return &"event_claim"
	return &"unknown_claim"


func referenced_subjects() -> Array:
	var result: Array = [subject]
	if kind == Kind.RELATION:
		result.append(object)
	return result


func key() -> StringName:
	match kind:
		Kind.PROPERTY:
			return StringName("property|%s|%s|%s" % [subject.sort_key(), semantic_id.sort_key(), _stable_value_key(value)])
		Kind.RELATION:
			return StringName("relation|%s|%s|%s" % [subject.sort_key(), semantic_id.sort_key(), object.sort_key()])
		Kind.EVENT:
			return StringName("event|%s|%s|role:%s" % [subject.sort_key(), semantic_id.sort_key(), String(role_name)])
	assert(false, "Unsupported EpistemicClaim kind")
	return &""


func sort_key() -> String:
	return String(key())


func _stable_value_key(p_value: Variant) -> String:
	if p_value is bool:
		return "bool:%s" % str(p_value)
	if p_value is int:
		return "int:%s" % str(p_value)
	if p_value is float:
		return "float:%s" % str(p_value)
	if p_value is StringName:
		return "symbol:%s" % String(p_value)
	if p_value is String:
		return "string:%s" % p_value
	if p_value is Object and p_value.has_method("sort_key"):
		return "semantic:%s" % p_value.sort_key()
	assert(false, "Unsupported durable property-claim value type")
	return "unsupported"
