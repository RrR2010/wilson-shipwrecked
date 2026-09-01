class_name EpisodeCandidate
extends RefCounted

var claim
var importance: float
var source_execution_id: StringName
var modality: StringName


func _init(p_claim, p_importance: float, p_source_execution_id: StringName, p_modality: StringName) -> void:
	assert(p_claim != null and p_claim.has_method("key"), "EpisodeCandidate requires typed semantic claim")
	assert(is_finite(p_importance) and p_importance >= 0.0 and p_importance <= 1.0, "Episode importance must be within [0,1]")
	assert(p_source_execution_id != &"", "EpisodeCandidate requires source execution id")
	assert(p_modality != &"", "EpisodeCandidate requires modality")
	claim = p_claim
	importance = p_importance
	source_execution_id = p_source_execution_id
	modality = p_modality


func key() -> StringName:
	return StringName("%s|%s" % [String(source_execution_id), claim.sort_key()])
