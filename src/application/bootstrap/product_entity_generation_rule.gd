class_name ProductEntityGenerationRule
extends RefCounted

## Authored bounded rule for generating durable entity bootstrap causes.

var id_prefix: StringName
var type_id
var candidate_places: Array
var min_count: int
var max_count: int
var lifecycle: int
var state_overrides: Dictionary
var quantity: Variant


func _init(
	p_id_prefix: StringName,
	p_type_id,
	p_candidate_places: Array,
	p_min_count: int,
	p_max_count: int,
	p_lifecycle: int = 0,
	p_state_overrides: Dictionary = {},
	p_quantity: Variant = null
) -> void:
	assert(p_id_prefix != &"", "ProductEntityGenerationRule requires id_prefix")
	assert(p_type_id != null, "ProductEntityGenerationRule requires entity type id")
	assert(not p_candidate_places.is_empty(), "ProductEntityGenerationRule requires at least one candidate place")
	assert(p_min_count >= 0, "ProductEntityGenerationRule min_count must be non-negative")
	assert(p_max_count >= p_min_count, "ProductEntityGenerationRule max_count must be >= min_count")
	for place_id in p_candidate_places:
		assert(place_id != null, "ProductEntityGenerationRule candidate place cannot be null")
	id_prefix = p_id_prefix
	type_id = p_type_id
	candidate_places = p_candidate_places.duplicate()
	min_count = p_min_count
	max_count = p_max_count
	lifecycle = p_lifecycle
	state_overrides = p_state_overrides.duplicate(true)
	quantity = p_quantity
