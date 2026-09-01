class_name PlayerSuggestionCandidateSource
extends RefCounted

const DecisionCandidate = preload("res://src/domain/cognition/decision_candidate.gd")

var _player_state

func _init(player_state) -> void:
	assert(player_state != null, "PlayerSuggestionCandidateSource requires PlayerRunState")
	_player_state = player_state

func generate() -> Array:
	var suggestion = _player_state.active_suggestion
	if suggestion == null:
		return []
	return [DecisionCandidate.new(
		suggestion.intention_id,
		suggestion.bindings.duplicate_binding(),
		DecisionCandidate.Scope.INTENTIONAL,
		0.0,
		0.0,
		0.0,
		0.0,
		suggestion.bias,
		{"source": "player_suggestion", "remaining_insistence": suggestion.remaining_insistence}
	)]
