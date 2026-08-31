class_name AssemblySlotDefinition
extends RefCounted

const DomainId = preload("res://src/domain/core/domain_id.gd")

var id
var semantic_role
var accepted_component_predicate
var min_count: int
var max_count: int
var optional: bool


func _init(
	p_id,
	p_semantic_role,
	p_accepted_component_predicate,
	p_min_count: int = 1,
	p_max_count: int = 1,
	p_optional: bool = false
) -> void:
	assert(p_id != null, "AssemblySlotDefinition requires AssemblySlotId")
	p_id.assert_kind(DomainId.Kind.ASSEMBLY_SLOT)
	assert(p_semantic_role != null, "AssemblySlotDefinition requires AssemblyRoleId")
	p_semantic_role.assert_kind(DomainId.Kind.ASSEMBLY_ROLE)
	assert(p_accepted_component_predicate != null, "AssemblySlotDefinition requires accepted component predicate")
	assert(p_min_count >= 0, "AssemblySlotDefinition min_count must be >= 0")
	assert(p_max_count >= 1 and p_max_count >= p_min_count, "AssemblySlotDefinition cardinality invalid")
	if p_optional:
		assert(p_min_count == 0, "Optional assembly slot must have min_count=0")
	id = p_id
	semantic_role = p_semantic_role
	accepted_component_predicate = p_accepted_component_predicate
	min_count = p_min_count
	max_count = p_max_count
	optional = p_optional
