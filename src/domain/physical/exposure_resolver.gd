class_name ExposureResolver
extends RefCounted

const ExposureResult = preload("res://src/domain/physical/exposure_result.gd")

var _protection_service
var _max_layers: int


func _init(protection_service, max_layers: int = 4) -> void:
	assert(protection_service != null, "ExposureResolver requires ProtectionProjectionService")
	assert(max_layers > 0 and max_layers <= 16, "ExposureResolver max_layers must be within [1,16]")
	_protection_service = protection_service
	_max_layers = max_layers


func resolve(target, exposure_kind: StringName, raw_exposure: float):
	assert(is_finite(raw_exposure) and raw_exposure >= 0.0 and raw_exposure <= 1.0, "raw exposure must be within [0,1]")
	var projections: Array = _protection_service.derive_for_target(target, exposure_kind)
	var residual: float = raw_exposure
	var applied: Array = []
	var count: int = mini(projections.size(), _max_layers)
	for index in range(count):
		var projection = projections[index]
		residual *= 1.0 - projection.effective_reduction()
		residual = clampf(residual, 0.0, 1.0)
		applied.append(projection)
	return ExposureResult.new(target, exposure_kind, raw_exposure, residual, applied)
