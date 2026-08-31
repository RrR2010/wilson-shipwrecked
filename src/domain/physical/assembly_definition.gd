class_name AssemblyDefinition
extends RefCounted

const DomainId = preload("res://src/domain/core/domain_id.gd")

var id
var slots: Array
var _slots_by_key: Dictionary = {}


func _init(p_id, p_slots: Array) -> void:
	assert(p_id != null, "AssemblyDefinition requires AssemblyDefinitionId")
	p_id.assert_kind(DomainId.Kind.ASSEMBLY_DEFINITION)
	id = p_id
	slots = p_slots.duplicate()
	for slot in slots:
		assert(slot != null, "AssemblyDefinition slots cannot contain null")
		var slot_key = slot.id.key()
		assert(not _slots_by_key.has(slot_key), "Duplicate assembly slot: %s" % slot.id.sort_key())
		_slots_by_key[slot_key] = slot


func get_slot(slot_id):
	assert(slot_id != null, "get_slot requires AssemblySlotId")
	slot_id.assert_kind(DomainId.Kind.ASSEMBLY_SLOT)
	return _slots_by_key.get(slot_id.key())
