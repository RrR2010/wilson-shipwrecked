class_name AssemblyBinding
extends RefCounted

const DomainId = preload("res://src/domain/core/domain_id.gd")

var host
var slot_id
var component


func _init(p_host, p_slot_id, p_component) -> void:
	assert(p_host != null, "AssemblyBinding requires host")
	assert(p_slot_id != null, "AssemblyBinding requires AssemblySlotId")
	p_slot_id.assert_kind(DomainId.Kind.ASSEMBLY_SLOT)
	assert(p_component != null, "AssemblyBinding requires component")
	host = p_host
	slot_id = p_slot_id
	component = p_component


func stable_key() -> String:
	return "%s|%s|%s" % [host.sort_key(), slot_id.sort_key(), component.sort_key()]
