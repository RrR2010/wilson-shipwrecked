class_name ObservedEventCueRule
extends RefCounted

const DomainId = preload("res://src/domain/core/domain_id.gd")

## Authored mapping from a Wilson-observed event to a semantic context cue.
## Unlike PerceivedCueRule this rule requires no subject role/evidence, so ambient
## events can activate routines without manufacturing subject-scoped claims.

var event_type
var cue_id: StringName
var required_modality: StringName


func _init(
	p_event_type,
	p_cue_id: StringName,
	p_required_modality: StringName = &""
) -> void:
	assert(p_event_type != null, "ObservedEventCueRule requires event type")
	p_event_type.assert_kind(DomainId.Kind.EVENT_DEFINITION)
	assert(p_cue_id != &"", "ObservedEventCueRule requires cue id")
	event_type = p_event_type
	cue_id = p_cue_id
	required_modality = p_required_modality


func matches_observed_event(observed_event) -> bool:
	if observed_event == null or observed_event.event_type == null:
		return false
	if not observed_event.event_type.equals(event_type):
		return false
	if required_modality != &"" and not observed_event.modalities.has(required_modality):
		return false
	return true
