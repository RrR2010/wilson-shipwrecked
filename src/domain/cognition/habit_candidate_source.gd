class_name HabitCandidateSource
extends RefCounted

const DecisionCandidate = preload("res://src/domain/cognition/decision_candidate.gd")

var _store
var _active_cues: Array[StringName]
var _max_contribution: float
var _minimum_strength: float


func _init(store, active_cues: Array[StringName], max_contribution: float = 0.35, minimum_strength: float = 0.2) -> void:
	assert(store != null, "HabitCandidateSource requires HabitStore")
	assert(is_finite(max_contribution) and max_contribution >= 0.0 and max_contribution <= 1.0, "Habit max contribution must be within [0,1]")
	assert(is_finite(minimum_strength) and minimum_strength >= 0.0 and minimum_strength <= 1.0, "Habit minimum strength must be within [0,1]")
	_store = store
	_active_cues = active_cues.duplicate()
	_active_cues.sort_custom(func(a, b): return String(a) < String(b))
	_max_contribution = max_contribution
	_minimum_strength = minimum_strength


func generate() -> Array:
	var result: Array = []
	for entry in _store.entries():
		if not _active_cues.has(entry["cue_id"]):
			continue
		var strength: float = float(entry["strength"])
		if strength < _minimum_strength:
			continue
		result.append(DecisionCandidate.new(
			entry["intention_id"],
			entry["bindings"].duplicate_binding(),
			DecisionCandidate.Scope.INTENTIONAL,
			strength * _max_contribution,
			0.0,
			0.0,
			0.0,
			0.0,
			{
				"source": "habit",
				"cue_id": String(entry["cue_id"]),
				"strength": strength,
			}
		))
	result.sort_custom(func(a, b): return a.stable_key() < b.stable_key())
	return result
