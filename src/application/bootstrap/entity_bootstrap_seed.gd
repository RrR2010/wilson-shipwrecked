class_name EntityBootstrapSeed
extends RefCounted

var id
var type_id
var place_id
var lifecycle: int
var state_overrides: Dictionary
var quantity: Variant


func _init(
	p_id,
	p_type_id,
	p_place_id,
	p_lifecycle: int = 0,
	p_state_overrides: Dictionary = {},
	p_quantity: Variant = null
) -> void:
	assert(p_id != null, "EntityBootstrapSeed requires entity id")
	assert(p_type_id != null, "EntityBootstrapSeed requires entity type id")
	assert(p_place_id != null, "EntityBootstrapSeed requires place id")
	id = p_id
	type_id = p_type_id
	place_id = p_place_id
	lifecycle = p_lifecycle
	state_overrides = p_state_overrides.duplicate(true)
	quantity = p_quantity
