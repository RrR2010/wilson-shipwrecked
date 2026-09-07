class_name PerceivedHabitCandidateSource
extends RefCounted

const HabitCandidateSource = preload("res://src/domain/cognition/habit_candidate_source.gd")

## Composes current Wilson-relative perception with durable HabitStore state.
## The cue service interprets only this step's perception; the habit store remains
## the sole owner of learned routine strength and bindings.

var _cue_service
var _habit_store
var _max_contribution: float
var _minimum_strength: float


func _init(
	cue_service,
	habit_store,
	max_contribution: float = 0.35,
	minimum_strength: float = 0.2
) -> void:
	assert(cue_service != null and cue_service.has_method("derive"), "PerceivedHabitCandidateSource requires cue service")
	assert(habit_store != null and habit_store.has_method("entries"), "PerceivedHabitCandidateSource requires HabitStore")
	assert(is_finite(max_contribution) and max_contribution >= 0.0 and max_contribution <= 1.0, "Habit max contribution must be within [0,1]")
	assert(is_finite(minimum_strength) and minimum_strength >= 0.0 and minimum_strength <= 1.0, "Habit minimum strength must be within [0,1]")
	_cue_service = cue_service
	_habit_store = habit_store
	_max_contribution = max_contribution
	_minimum_strength = minimum_strength


func generate(perception_result) -> Array:
	assert(perception_result != null, "PerceivedHabitCandidateSource requires PerceptionResult")
	var active_cues: Array[StringName] = _cue_service.derive(perception_result)
	return HabitCandidateSource.new(
		_habit_store,
		active_cues,
		_max_contribution,
		_minimum_strength
	).generate()
