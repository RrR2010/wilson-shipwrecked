class_name RelationBootstrapSeed
extends RefCounted

var relation_type
var subject
var object
var qualifier: Variant


func _init(p_relation_type, p_subject, p_object, p_qualifier: Variant = null) -> void:
	assert(p_relation_type != null, "RelationBootstrapSeed requires relation type")
	assert(p_subject != null, "RelationBootstrapSeed requires subject")
	assert(p_object != null, "RelationBootstrapSeed requires object")
	relation_type = p_relation_type
	subject = p_subject
	object = p_object
	qualifier = p_qualifier
