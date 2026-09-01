class_name ProtectionProjection
extends RefCounted

## Reconstructible physical projection. It describes current shielding from one
## exposure family; it is not authoritative shelter state.

var source
var target
var exposure_kind: StringName
var coverage: float
var protection_strength: float
var provenance: Dictionary


func _init(
	p_source,
	p_target,
	p_exposure_kind: StringName,
	p_coverage: float,
	p_protection_strength: float,
	p_provenance: Dictionary = {}
) -> void:
	assert(p_source != null and p_target != null, "ProtectionProjection requires source and target")
	assert(p_exposure_kind != &"", "ProtectionProjection requires exposure kind")
	assert(is_finite(p_coverage) and p_coverage >= 0.0 and p_coverage <= 1.0, "coverage must be within [0,1]")
	assert(is_finite(p_protection_strength) and p_protection_strength >= 0.0 and p_protection_strength <= 1.0, "protection strength must be within [0,1]")
	source = p_source
	target = p_target
	exposure_kind = p_exposure_kind
	coverage = p_coverage
	protection_strength = p_protection_strength
	provenance = p_provenance.duplicate(true)


func effective_reduction() -> float:
	return clampf(coverage * protection_strength, 0.0, 1.0)


func stable_key() -> String:
	return "%s|%s|%s" % [String(exposure_kind), source.sort_key(), target.sort_key()]
