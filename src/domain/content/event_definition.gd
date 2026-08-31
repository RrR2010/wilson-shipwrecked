class_name EventDefinition
extends RefCounted

const DomainId = preload("res://src/domain/core/domain_id.gd")

## Authored semantic/perceptual envelope for one event definition.
## It describes which semantic roles may be perceived and through which modalities;
## runtime spatial access still decides whether Wilson actually perceives them.

var id
var perceptible_roles: Array[StringName] = []
var modalities: Array[StringName] = []
var base_confidence: float


func _init(
	p_id,
	p_perceptible_roles: Array[StringName],
	p_modalities: Array[StringName],
	p_base_confidence: float = 1.0
) -> void:
	assert(p_id != null, "EventDefinition requires EventDefinitionId")
	p_id.assert_kind(DomainId.Kind.EVENT_DEFINITION)
	assert(p_base_confidence >= 0.0 and p_base_confidence <= 1.0, "EventDefinition confidence must be within [0,1]")
	id = p_id
	base_confidence = p_base_confidence
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
