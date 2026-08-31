class_name ActionDefinition
extends RefCounted

const DomainId = preload("res://src/domain/core/domain_id.gd")

## Immutable authored semantics for a reusable action verb.

enum InterruptionClass {
	PRE_COMMIT_ONLY,
	NEVER,
	ANYTIME,
}

var id
var roles: Array[StringName] = []
var requirements
var interruption_class: int


func _init(
	p_id,
	p_roles: Array[StringName],
	p_requirements,
	p_interruption_class: int = InterruptionClass.PRE_COMMIT_ONLY
) -> void:
	assert(p_id != null, "ActionDefinition requires ActionId")
	p_id.assert_kind(DomainId.Kind.ACTION)
	assert(p_requirements != null, "ActionDefinition requires RequirementPredicate")
	assert(p_interruption_class >= 0 and p_interruption_class < InterruptionClass.size(), "Invalid action interruption class")
	var seen: Dictionary = {}
	for role_name in p_roles:
		assert(role_name != &"", "ActionDefinition role cannot be empty")
		assert(not seen.has(role_name), "ActionDefinition roles must be unique")
		seen[role_name] = true
		roles.append(role_name)
	roles.sort_custom(func(a, b): return String(a) < String(b))
	id = p_id
	requirements = p_requirements
	interruption_class = p_interruption_class
