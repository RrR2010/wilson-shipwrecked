class_name PropertyInputSelector
extends RefCounted

const DomainId = preload("res://src/domain/core/domain_id.gd")

enum Kind { SUBJECT_PROPERTY, ASSEMBLY_SLOT_PROPERTY }

var kind: int
var property_id
var slot_id

func _init(p_kind: int, p_property_id, p_slot_id = null) -> void:
	assert(p_kind >= 0 and p_kind < Kind.size(), "Invalid PropertyInputSelector kind")
	assert(p_property_id != null, "PropertyInputSelector requires PropertyId")
	p_property_id.assert_kind(DomainId.Kind.PROPERTY)
	kind = p_kind
	property_id = p_property_id
	slot_id = p_slot_id
	if kind == Kind.ASSEMBLY_SLOT_PROPERTY:
		assert(slot_id != null, "Assembly slot property selector requires AssemblySlotId")
		slot_id.assert_kind(DomainId.Kind.ASSEMBLY_SLOT)
	else:
		assert(slot_id == null, "Subject property selector cannot carry AssemblySlotId")

static func subject_property(property_id):
	return new(Kind.SUBJECT_PROPERTY, property_id)

static func assembly_slot_property(slot_id, property_id):
	return new(Kind.ASSEMBLY_SLOT_PROPERTY, property_id, slot_id)

func stable_key() -> String:
	if kind == Kind.SUBJECT_PROPERTY:
		return "self.%s" % property_id.sort_key()
	return "slot[%s].%s" % [slot_id.sort_key(), property_id.sort_key()]
