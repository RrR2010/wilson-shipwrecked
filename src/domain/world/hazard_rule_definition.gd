class_name HazardRuleDefinition
extends RefCounted

## Authored mapping from a dynamic process family to a coarse physical hazard
## projection. It commits no collision victim or consequence.

var id: StringName
var process_definition_id: StringName
var severity: float
var urgency: float
var horizon: float


func _init(
	p_id: StringName,
	p_process_definition_id: StringName,
	p_severity: float,
	p_urgency: float,
	p_horizon: float
) -> void:
	assert(p_id != &"" and p_process_definition_id != &"", "HazardRuleDefinition ids cannot be empty")
	assert(is_finite(p_severity) and p_severity >= 0.0 and p_severity <= 1.0, "hazard severity must be within [0,1]")
	assert(is_finite(p_urgency) and p_urgency >= 0.0 and p_urgency <= 1.0, "hazard urgency must be within [0,1]")
	assert(is_finite(p_horizon) and p_horizon >= 0.0, "hazard horizon must be finite and non-negative")
	id = p_id
	process_definition_id = p_process_definition_id
	severity = p_severity
	urgency = p_urgency
	horizon = p_horizon
