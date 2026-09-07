class_name EventDefinition
extends RefCounted

const DomainId = preload("res://src/domain/core/domain_id.gd")

enum AccessScope { SPATIAL_ROLES, AMBIENT }

## Authored semantic/perceptual envelope for one event definition.
## Spatial-role events remain subject-access constrained. Ambient events represent
## locally pervasive environmental facts and need no synthetic subject binding.
## `context_transition` is domain semantics only; application policy decides whether
## a perceived transition should wake reconsideration.

var id
var perceptible_roles: Array[StringName] = []
var modalities: Array[StringName] = []
var base_confidence: float
var access_scope: int
var context_transition: bool


func _init(
	p_id,
	p_perceptible_roles: Array[StringName],
	p_modalities: Array[StringName],
	p_base_confidence: float = 1.0,
	p_access_scope: int = AccessScope.SPATIAL_ROLES,
	p_context_transition: bool = false
) -> void:
	assert(p_id != null, "EventDefinition requires EventDefinitionId")
	p_id.assert_kind(DomainId.Kind.EVENT_DEFINITION)
	assert(p_base_confidence >= 0.0 and p_base_confidence <= 1.0, "EventDefinition confidence must be within [0,1]")
	assert(p_access_scope >= AccessScope.SPATIAL_ROLES and p_access_scope <= AccessScope.AMBIENT, "Invalid EventDefinition access scope")
	if p_access_scope == AccessScope.AMBIENT:
		assert(p_perceptible_roles.is_empty(), "Ambient events must not require spatial subject roles")
	id = p_id
	base_confidence = p_base_confidence
	access_scope = p_access_scope
	context_transition = p_context_transition
	var seen_roles: Dictionary = {}
	for role_name in p_perceptible_roles:
		assert(role_name != &"", "EventDefinition role cannot be empty")
		assert(not seen_roles.has(role_name), "EventDefinition perceptible roles must be unique")
		seen_roles[role_name] = true
		perceptible_roles.append(role_name)
	perceptible_roles.sort_custom(func(a, b): return String(a) < String(b))
	var seen_modalities: Dictionary = {}
	for modality in p_modalities:
		assert(modality != &"", "EventDefinition modality cannot be empty")
		assert(not seen_modalities.has(modality), "EventDefinition modalities must be unique")
		seen_modalities[modality] = true
		modalities.append(modality)
	modalities.sort_custom(func(a, b): return String(a) < String(b))
