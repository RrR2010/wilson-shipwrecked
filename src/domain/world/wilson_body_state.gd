class_name WilsonBodyState
extends RefCounted

const MutationResult = preload("res://src/domain/core/mutation_result.gd")

## Minimal World-owned physical truth for Wilson.
## Detailed injury/pain/healing semantics are deliberately outside this slice.

var vitality: float
var alive: bool


func _init(p_vitality: float = 1.0) -> void:
	assert(is_finite(p_vitality) and p_vitality >= 0.0 and p_vitality <= 1.0, "Wilson vitality must be within [0,1]")
	vitality = p_vitality
	alive = vitality > 0.0


func apply_damage(amount: float):
	assert(is_finite(amount) and amount > 0.0, "Wilson body damage must be finite and positive")
	if not alive:
		return MutationResult.failure(&"wilson_already_dead", ["Dead Wilson body cannot receive another death-producing damage transition"])
	var previous_vitality := vitality
	vitality = clampf(vitality - amount, 0.0, 1.0)
	var died := previous_vitality > 0.0 and vitality <= 0.0
	alive = vitality > 0.0
	return MutationResult.success(&"wilson_body_damaged", {
		"previous_vitality": previous_vitality,
		"vitality": vitality,
		"died": died,
	})


func resurrect_wilson(_run_id: StringName):
	if alive:
		return MutationResult.failure(&"wilson_body_not_dead", ["Physical resurrection requires dead Wilson body truth"])
	vitality = 1.0
	alive = true
	return MutationResult.success(&"wilson_body_resurrected", self)
