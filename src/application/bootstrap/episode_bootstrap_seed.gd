class_name EpisodeBootstrapSeed
extends RefCounted

var claim
var importance: float
var source_execution_id: StringName
var modality: StringName
var sequence: int


func _init(
	p_claim,
	p_importance: float,
	p_source_execution_id: StringName,
	p_modality: StringName,
	p_sequence: int
) -> void:
	assert(p_claim != null and p_claim.has_method("sort_key"), "EpisodeBootstrapSeed requires claim")
	assert(is_finite(p_importance) and p_importance >= 0.0 and p_importance <= 1.0, "Episode seed importance must be within [0,1]")
	assert(p_sequence > 0, "Episode seed sequence must be positive")
	claim = p_claim
	importance = p_importance
	source_execution_id = p_source_execution_id
	modality = p_modality
	sequence = p_sequence
