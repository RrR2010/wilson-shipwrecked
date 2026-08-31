class_name WilsonWorldState
extends RefCounted

const DomainId = preload("res://src/domain/core/domain_id.gd")
const MutationResult = preload("res://src/domain/core/mutation_result.gd")

## World-owned physical state for Wilson that is not cognition.
## This slice intentionally owns only coarse PlaceId location; body/environment
## state may extend the same World-owned family later without entering Cognition.

var place_id


func _init(p_place_id) -> void:
	assert(p_place_id != null, "WilsonWorldState requires PlaceId")
	p_place_id.assert_kind(DomainId.Kind.PLACE)
	place_id = p_place_id


func move_to(p_place_id) -> MutationResult:
	assert(p_place_id != null, "move_to requires PlaceId")
	p_place_id.assert_kind(DomainId.Kind.PLACE)
	place_id = p_place_id
	return MutationResult.success(&"wilson_place_changed", self)
