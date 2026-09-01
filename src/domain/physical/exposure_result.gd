class_name ExposureResult
extends RefCounted

var target
var exposure_kind: StringName
var raw_exposure: float
var exposure_level: float
var protection_refs: Array


func _init(
	p_target,
	p_exposure_kind: StringName,
	p_raw_exposure: float,
	p_exposure_level: float,
	p_protection_refs: Array = []
) -> void:
	assert(p_target != null and p_exposure_kind != &"", "ExposureResult requires target and exposure kind")
	assert(is_finite(p_raw_exposure) and p_raw_exposure >= 0.0 and p_raw_exposure <= 1.0, "raw exposure must be within [0,1]")
	assert(is_finite(p_exposure_level) and p_exposure_level >= 0.0 and p_exposure_level <= 1.0, "exposure level must be within [0,1]")
	target = p_target
	exposure_kind = p_exposure_kind
	raw_exposure = p_raw_exposure
	exposure_level = p_exposure_level
	protection_refs = p_protection_refs.duplicate()
