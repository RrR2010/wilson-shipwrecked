class_name HabitEvidence
extends RefCounted

const DomainId = preload("res://src/domain/core/domain_id.gd")

var cue_id: StringName
var intention_id
var bindings
var strength_delta: float
var weight: float
var source_execution_id: StringName


func _init(
	p_cue_id: StringName,
	p_intention_id,
	p_bindings,
	p_strength_delta: float,
	p_weight: float,
	p_source_execution_id: StringName
) -> void:
	assert(p_cue_id != &"", "HabitEvidence requires cue id")
	assert(p_intention_id != null, "HabitEvidence requires intention id")
	p_intention_id.assert_kind(DomainId.Kind.SEMANTIC_INTENTION)
	assert(p_bindings != null and p_bindings.has_method("duplicate_binding"), "HabitEvidence requires RoleBinding")
	assert(is_finite(p_strength_delta) and p_strength_delta >= -1.0 and p_strength_delta <= 1.0, "Habit strength delta must be within [-1,1]")
	assert(is_finite(p_weight) and p_weight >= 0.0 and p_weight <= 1.0, "Habit evidence weight must be within [0,1]")
	assert(p_source_execution_id != &"", "HabitEvidence requires source execution id")
	cue_id = p_cue_id
	intention_id = p_intention_id
	bindings = p_bindings.duplicate_binding()
	strength_delta = p_strength_delta
	weight = p_weight
	source_execution_id = p_source_execution_id


func key() -> StringName:
	return StringName("%s|%s|%s" % [String(cue_id), intention_id.sort_key(), bindings.stable_key()])
