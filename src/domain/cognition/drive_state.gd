class_name DriveState
extends RefCounted

const DriveAdvanceResult = preload("res://src/domain/cognition/drive_advance_result.gd")

enum UrgencyBand { CALM, PRESSING, URGENT }

const HUNGER: StringName = &"hunger"
const ENERGY: StringName = &"energy"
const COMFORT: StringName = &"comfort"
const STIMULATION: StringName = &"stimulation"
const DRIVE_IDS: Array[StringName] = [HUNGER, ENERGY, COMFORT, STIMULATION]

const PRESSING_ENTER := 0.55
const PRESSING_EXIT := 0.45
const URGENT_ENTER := 0.80
const URGENT_EXIT := 0.70

var _values: Dictionary = {}
var _bands: Dictionary = {}


func _init(initial_values: Dictionary = {}) -> void:
	for drive_id in DRIVE_IDS:
		var value := float(initial_values.get(drive_id, 0.0))
		assert(is_finite(value), "Drive values must be finite")
		assert(value >= 0.0 and value <= 1.0, "Drive values must be within [0,1]")
		_values[drive_id] = value
		_bands[drive_id] = _band_from_value(value)


func value(drive_id: StringName) -> float:
	_assert_drive(drive_id)
	return float(_values[drive_id])


func band(drive_id: StringName) -> int:
	_assert_drive(drive_id)
	return int(_bands[drive_id])


func urgency(drive_id: StringName) -> float:
	_assert_drive(drive_id)
	var drive_value := value(drive_id)
	if drive_value <= PRESSING_EXIT:
		return 0.0
	return clampf((drive_value - PRESSING_EXIT) / (1.0 - PRESSING_EXIT), 0.0, 1.0)


func set_value(drive_id: StringName, new_value: float) -> void:
	_assert_drive(drive_id)
	assert(is_finite(new_value), "Drive values must be finite")
	assert(new_value >= 0.0 and new_value <= 1.0, "Drive values must be within [0,1]")
	_values[drive_id] = new_value
	_bands[drive_id] = _band_from_value(new_value)


func advance(elapsed: float, rates_per_second: Dictionary) -> DriveAdvanceResult:
	assert(is_finite(elapsed) and elapsed >= 0.0, "Drive advance elapsed must be finite and non-negative")
	var previous := snapshot_values()
	var crossings: Array[StringName] = []
	for drive_id in DRIVE_IDS:
		var rate := float(rates_per_second.get(drive_id, 0.0))
		assert(is_finite(rate), "Drive progression rates must be finite")
		var previous_band := int(_bands[drive_id])
		var next_value := clampf(float(_values[drive_id]) + rate * elapsed, 0.0, 1.0)
		var next_band := _band_with_hysteresis(previous_band, next_value)
		_values[drive_id] = next_value
		_bands[drive_id] = next_band
		if next_band > previous_band:
			crossings.append(drive_id)
	return DriveAdvanceResult.new(previous, snapshot_values(), crossings)


func snapshot_values() -> Dictionary:
	return _values.duplicate(true)


func restore_values(values: Dictionary) -> void:
	for drive_id in DRIVE_IDS:
		assert(values.has(drive_id), "Drive snapshot missing %s" % String(drive_id))
		set_value(drive_id, float(values[drive_id]))


func _band_from_value(drive_value: float) -> int:
	if drive_value >= URGENT_ENTER:
		return UrgencyBand.URGENT
	if drive_value >= PRESSING_ENTER:
		return UrgencyBand.PRESSING
	return UrgencyBand.CALM


func _band_with_hysteresis(previous_band: int, drive_value: float) -> int:
	match previous_band:
		UrgencyBand.CALM:
			if drive_value >= URGENT_ENTER:
				return UrgencyBand.URGENT
			if drive_value >= PRESSING_ENTER:
				return UrgencyBand.PRESSING
		UrgencyBand.PRESSING:
			if drive_value >= URGENT_ENTER:
				return UrgencyBand.URGENT
			if drive_value < PRESSING_EXIT:
				return UrgencyBand.CALM
		UrgencyBand.URGENT:
			if drive_value < PRESSING_EXIT:
				return UrgencyBand.CALM
			if drive_value < URGENT_EXIT:
				return UrgencyBand.PRESSING
	return previous_band


func _assert_drive(drive_id: StringName) -> void:
	assert(DRIVE_IDS.has(drive_id), "Unknown drive: %s" % String(drive_id))
