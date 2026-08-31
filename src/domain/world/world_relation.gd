class_name WorldRelation
extends RefCounted

## Authoritative typed edge between runtime world subjects.
## RelationDefinition/cardinality validation will be added at the World command
## boundary; this value object only guarantees typed identity and stable ordering.

var relation_type: DomainId
var subject: RuntimeWorldRef
var object: RuntimeWorldRef
var qualifier: Variant


func _init(
	p_relation_type: DomainId,
	p_subject: RuntimeWorldRef,
	p_object: RuntimeWorldRef,
	p_qualifier: Variant = null
) -> void:
	assert(p_relation_type != null, "WorldRelation requires RelationTypeId")
	p_relation_type.assert_kind(DomainId.Kind.RELATION_TYPE)
	assert(p_subject != null and p_object != null, "WorldRelation endpoints cannot be null")
	relation_type = p_relation_type
	subject = p_subject
	object = p_object
	qualifier = p_qualifier


func key() -> StringName:
	# One authoritative relation payload per typed subject/object triple initially.
	# RelationDefinition may later admit a stronger identity discriminator if a
	# representative case requires parallel qualified edges of the same type.
	return StringName("%s|%s|%s" % [
		String(relation_type.key()),
		String(subject.key()),
		String(object.key()),
	])


func sort_key() -> String:
	return String(key())


func matches(
	p_relation_type: DomainId = null,
	p_subject: RuntimeWorldRef = null,
	p_object: RuntimeWorldRef = null
) -> bool:
	if p_relation_type != null and not relation_type.equals(p_relation_type):
		return false
	if p_subject != null and not subject.equals(p_subject):
		return false
	if p_object != null and not object.equals(p_object):
		return false
	return true


func _to_string() -> String:
	return "%s(%s -> %s)" % [String(relation_type.value), subject, object]
