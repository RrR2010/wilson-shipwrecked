class_name EnvironmentalResponseTargetSelector
extends RefCounted

const DomainId = preload("res://src/domain/core/domain_id.gd")

enum Kind { SELF, ASSEMBLY_SLOT }

var kind: int
var slot_id


func _init(p_kind: int, p_slot_id = null) -> void:
	assert(p_kind >= Kind.SELF and p_kind <= Kind.ASSEMBLY_SLOT, "Invalid environmental response target selector kind")
	if p_kind == Kind.ASSEMBLY_SLOT:
		assert(p_slot_id != null, "Assembly-slot environmental target requires slot id")
		p_slot_id.assert_kind(DomainId.Kind.ASSEMBLY_SLOT)
	kind = p_kind
	slot_id = p_slot_id


static func self_target():
	return new(Kind.SELF)


static func assembly_slot(slot_id):
	return new(Kind.ASSEMBLY_SLOT, slot_id)


func stable_key() -> String:
	match kind:
		Kind.SELF:
			return "self"
		Kind.ASSEMBLY_SLOT:
			return "assembly_slot:%s" % slot_id.sort_key()
	return "unknown"
