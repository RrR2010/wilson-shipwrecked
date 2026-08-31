class_name PerceptionAccess
extends RefCounted

## Derived accessibility result for one WorldEvent.
## Future spatial/occlusion/hearing services may produce this value.

var observable: bool
var modalities: Array[StringName]
var accessible_roles: Array[StringName]
var confidence: float


func _init(
	p_observable: bool,
	p_modalities: Array[StringName] = [],
	p_accessible_roles: Array[StringName] = [],
	p_confidence: float = 1.0
) -> void:
	assert(p_confidence >= 0.0 and p_confidence <= 1.0, "confidence must be within [0,1]")
	observable = p_observable
	modalities = p_modalities.duplicate()
	accessible_roles = p_accessible_roles.duplicate()
	confidence = p_confidence
	modalities.sort_custom(func(a, b): return String(a) < String(b))
	accessible_roles.sort_custom(func(a, b): return String(a) < String(b))
