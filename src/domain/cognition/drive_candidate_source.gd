class_name DriveCandidateSource
extends RefCounted

const RoleBinding = preload("res://src/domain/actions/role_binding.gd")
const DecisionCandidate = preload("res://src/domain/cognition/decision_candidate.gd")

var _drive_state
var _definitions: Array


func _init(drive_state, definitions: Array) -> void:
	assert(drive_state != null, "DriveCandidateSource requires DriveState")
	_drive_state = drive_state
	_definitions = definitions.duplicate()


func generate() -> Array:
	var result: Array = []
	for definition in _definitions:
		if definition == null:
			continue
		var current_band: int = _drive_state.band(definition.drive_id)
		if current_band < definition.minimum_band:
			continue
		var urgency_score: float = _drive_state.urgency(definition.drive_id)
		result.append(DecisionCandidate.new(
			definition.intention_id,
			RoleBinding.new(),
			DecisionCandidate.Scope.INTENTIONAL,
			definition.base_score,
			0.0,
			0.0,
			urgency_score,
			0.0,
			{
				"source": "drive",
				"drive_id": String(definition.drive_id),
				"drive_value": _drive_state.value(definition.drive_id),
				"urgency_band": current_band,
			}
		))
	result.sort_custom(func(a, b): return a.stable_key() < b.stable_key())
	return result
