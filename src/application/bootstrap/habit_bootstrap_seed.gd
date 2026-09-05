class_name HabitBootstrapSeed
extends RefCounted

var cue_id: StringName
var intention_id
var bindings
var strength: float
var evidence_count: int
var last_source_execution_id: StringName


func _init(
	p_cue_id: StringName,
	p_intention_id,
	p_bindings,
	p_strength: float,
	p_evidence_count: int,
	p_last_source_execution_id: StringName = &""
) -> void:
	assert(p_cue_id != &"", "HabitBootstrapSeed requires cue id")
	assert(p_intention_id != null, "HabitBootstrapSeed requires intention id")
	assert(p_bindings != null, "HabitBootstrapSeed requires bindings")
	assert(is_finite(p_strength) and p_strength >= 0.0 and p_strength <= 1.0, "Habit seed strength must be within [0,1]")
	assert(p_evidence_count >= 0, "Habit seed evidence count must be non-negative")
	cue_id = p_cue_id
	intention_id = p_intention_id
	bindings = p_bindings.duplicate_binding()
	strength = p_strength
	evidence_count = p_evidence_count
	last_source_execution_id = p_last_source_execution_id
