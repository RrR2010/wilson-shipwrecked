class_name BeliefProposition
extends RefCounted

const EpistemicClaim = preload("res://src/domain/cognition/epistemic_claim.gd")

## Durable proposition identity owned by Wilson cognition.
## Identity is delegated to the closed EpistemicClaim algebra rather than a
## generic predicate + arguments tuple.

var claim


func _init(p_claim) -> void:
	assert(p_claim != null, "BeliefProposition requires EpistemicClaim")
	assert(p_claim.get_script() == EpistemicClaim, "BeliefProposition requires EpistemicClaim")
	claim = p_claim


func key() -> StringName:
	return claim.key()


func sort_key() -> String:
	return claim.sort_key()


func tag() -> StringName:
	return claim.tag()


func referenced_subjects() -> Array:
	return claim.referenced_subjects()
