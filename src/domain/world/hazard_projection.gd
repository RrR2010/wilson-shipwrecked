class_name HazardProjection
extends RefCounted

## Derived authoritative future-risk envelope. This is not Wilson knowledge and
## does not commit a future victim/result.

var source_process_id: StringName
var source_subject
var affected_place
var severity: float
var urgency: float
var horizon: float
var provenance: Dictionary


func _init(
	p_source_process_id: StringName,
	p_source_subject,
	p_affected_place,
	p_severity: float,
	p_urgency: float,
	p_horizon: float,
	p_provenance: Dictionary = {}
) -> void:
	assert(p_source_process_id != &"", "HazardProjection requires source process id")
	assert(p_source_subject != null and p_affected_place != null, "HazardProjection requires source subject and affected place")
	assert(is_finite(p_severity) and p_severity >= 0.0 and p_severity <= 1.0, "severity must be within [0,1]")
	assert(is_finite(p_urgency) and p_urgency >= 0.0 and p_urgency <= 1.0, "urgency must be within [0,1]")
	assert(is_finite(p_horizon) and p_horizon >= 0.0, "horizon must be finite and non-negative")
	source_process_id = p_source_process_id
	source_subject = p_source_subject
	affected_place = p_affected_place
	severity = p_severity
	urgency = p_urgency
	horizon = p_horizon
	provenance = p_provenance.duplicate(true)


func stable_key() -> String:
	return "%s|%s" % [String(source_process_id), source_subject.sort_key()]
