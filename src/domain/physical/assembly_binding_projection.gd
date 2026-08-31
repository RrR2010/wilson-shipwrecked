class_name AssemblyBindingProjection
extends RefCounted

const DomainId = preload("res://src/domain/core/domain_id.gd")
const AssemblyBinding = preload("res://src/domain/physical/assembly_binding.gd")

var _world_query
var _binding_relation_type


func _init(world_query, binding_relation_type) -> void:
	assert(world_query != null, "AssemblyBindingProjection requires WorldQuery")
	assert(binding_relation_type != null, "AssemblyBindingProjection requires relation type")
	binding_relation_type.assert_kind(DomainId.Kind.RELATION_TYPE)
	_world_query = world_query
	_binding_relation_type = binding_relation_type


func bindings_for_host(host) -> Array:
	assert(host != null, "bindings_for_host requires host")
	var result: Array = []
	for relation in _world_query.get_incoming_relations(host, _binding_relation_type):
		var slot_id = _slot_id_from_qualifier(relation.qualifier)
		if slot_id == null:
			continue
		result.append(AssemblyBinding.new(host, slot_id, relation.subject))
	result.sort_custom(func(a, b): return a.stable_key() < b.stable_key())
	return result


func _slot_id_from_qualifier(qualifier):
	if not (qualifier is Object) or not qualifier.has_method("assert_kind"):
		return null
	if qualifier.get("kind") != DomainId.Kind.ASSEMBLY_SLOT:
		return null
	return qualifier
