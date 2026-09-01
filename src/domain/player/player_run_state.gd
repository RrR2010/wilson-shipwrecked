class_name PlayerRunState
extends RefCounted

const PlayerSuggestion = preload("res://src/domain/player/player_suggestion.gd")

var god_power: float
var permissions: Dictionary = {}
var non_intervention_seconds: float = 0.0
var active_suggestion = null

func _init(p_god_power: float = 0.0, p_permissions: Array = []) -> void:
	assert(p_god_power >= 0.0 and is_finite(p_god_power), "God Power must be finite and non-negative")
	god_power = p_god_power
	for permission in p_permissions:
		var key := StringName(permission)
		assert(key != &"", "Permission cannot be empty")
		permissions[key] = true

func has_permission(permission: StringName) -> bool:
	return permission == &"" or permissions.has(permission)

func grant_permission(permission: StringName) -> void:
	assert(permission != &"", "Permission cannot be empty")
	permissions[permission] = true

func set_suggestion(suggestion: PlayerSuggestion) -> void:
	active_suggestion = suggestion

func clear_suggestion() -> void:
	active_suggestion = null

func record_non_intervention(elapsed: float) -> void:
	assert(elapsed >= 0.0 and is_finite(elapsed), "elapsed must be finite and non-negative")
	non_intervention_seconds += elapsed

func spend(cost: float) -> bool:
	assert(cost >= 0.0 and is_finite(cost), "cost must be finite and non-negative")
	if god_power < cost:
		return false
	god_power -= cost
	non_intervention_seconds = 0.0
	return true
