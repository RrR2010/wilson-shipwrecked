class_name PerceivedThreat
extends RefCounted

## Wilson-relative emergency interpretation. It is derived only from accessible
## evidence and intentionally does not carry authoritative HazardProjection data.

var source_subject
var event_type
var estimated_severity: float
var estimated_urgency: float
var confidence: float
var source_execution_id: StringName


func _init(
	p_source_subject,
	p_event_type,
	p_estimated_severity: float,
	p_estimated_urgency: float,
	p_confidence: float,
	p_source_execution_id: StringName
) -> void:
	assert(p_source_subject != null and p_event_type != null, "PerceivedThreat requires source subject and event type")
	assert(is_finite(p_estimated_severity) and p_estimated_severity >= 0.0 and p_estimated_severity <= 1.0, "severity must be within [0,1]")
	assert(is_finite(p_estimated_urgency) and p_estimated_urgency >= 0.0 and p_estimated_urgency <= 1.0, "urgency must be within [0,1]")
	assert(is_finite(p_confidence) and p_confidence >= 0.0 and p_confidence <= 1.0, "confidence must be within [0,1]")
	assert(p_source_execution_id != &"", "PerceivedThreat requires evidence source execution id")
	source_subject = p_source_subject
	event_type = p_event_type
	estimated_severity = p_estimated_severity
	estimated_urgency = p_estimated_urgency
	confidence = p_confidence
	source_execution_id = p_source_execution_id


func stable_key() -> String:
	return "%s|%s|%s" % [event_type.sort_key(), source_subject.sort_key(), String(source_execution_id)]
