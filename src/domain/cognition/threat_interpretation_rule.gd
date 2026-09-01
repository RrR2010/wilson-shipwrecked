class_name ThreatInterpretationRule
extends RefCounted

const DomainId = preload("res://src/domain/core/domain_id.gd")

var event_type
var perceived_role: StringName
var estimated_severity: float
var estimated_urgency: float
var minimum_confidence: float


func _init(
	p_event_type,
	p_perceived_role: StringName,
	p_estimated_severity: float,
	p_estimated_urgency: float,
	p_minimum_confidence: float = 0.25
) -> void:
	assert(p_event_type != null, "ThreatInterpretationRule requires event type")
	p_event_type.assert_kind(DomainId.Kind.EVENT_DEFINITION)
	assert(p_perceived_role != &"", "ThreatInterpretationRule requires perceived role")
	assert(is_finite(p_estimated_severity) and p_estimated_severity >= 0.0 and p_estimated_severity <= 1.0, "severity must be within [0,1]")
	assert(is_finite(p_estimated_urgency) and p_estimated_urgency >= 0.0 and p_estimated_urgency <= 1.0, "urgency must be within [0,1]")
	assert(is_finite(p_minimum_confidence) and p_minimum_confidence >= 0.0 and p_minimum_confidence <= 1.0, "minimum confidence must be within [0,1]")
	event_type = p_event_type
	perceived_role = p_perceived_role
	estimated_severity = p_estimated_severity
	estimated_urgency = p_estimated_urgency
	minimum_confidence = p_minimum_confidence
