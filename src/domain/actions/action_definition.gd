class_name ActionDefinition
extends RefCounted

const DomainId = preload("res://src/domain/core/domain_id.gd")

## Immutable authored semantics for a reusable action verb.

var id
var roles: Array[StringName] = []
var requirements


func _init(p_id, p_roles: Array[StringName], p_requirements) -> void:
	assert(p_id != null, "ActionDefinition requires ActionId")
	p_id.assert_kind(DomainId.Kind.ACTION)
	assert(p_requirements != null, "ActionDefinition requires RequirementPredicate")
	var seen: Dictionary = {}
	for role_name in p_roles:
		assert(role_name != &"", "ActionDefinition role cannot be empty")
		assert(not seen.has(role_name), "ActionDefinition roles must be unique")
		seen[role_name] = true
		roles.append(role_name)
	roles.sort_custom(func(a, b): return String(a) < String(b))
	id = p_id
	requirements = p_requirements
