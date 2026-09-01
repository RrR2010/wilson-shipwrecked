class_name PlayerSuggestionService
extends RefCounted

const PlayerSuggestion = preload("res://src/domain/player/player_suggestion.gd")

var _player_state
var _max_insistence: int

func _init(player_state, max_insistence: int = 2) -> void:
	assert(player_state != null, "PlayerSuggestionService requires PlayerRunState")
	assert(max_insistence >= 0, "max insistence must be non-negative")
	_player_state = player_state
	_max_insistence = max_insistence

func suggest(intention_id, bindings, bias: float = 0.2) -> bool:
	_player_state.set_suggestion(PlayerSuggestion.new(intention_id, bindings, bias, _max_insistence))
	return true

func insist() -> bool:
	var suggestion = _player_state.active_suggestion
	if suggestion == null or suggestion.remaining_insistence <= 0:
		return false
	suggestion.remaining_insistence -= 1
	return true

func clear() -> void:
	_player_state.clear_suggestion()
