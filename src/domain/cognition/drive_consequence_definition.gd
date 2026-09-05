class_name DriveConsequenceDefinition
extends RefCounted

const DomainId = preload("res://src/domain/core/domain_id.gd")
const DriveState = preload("res://src/domain/cognition/drive_state.gd")

## Immutable authored policy mapping a grounded action outcome to a DriveState delta.
##
## This is cognition policy, not a World ActionEffect. The application layer may apply
## it only after the owning World command boundary has accepted the ActionOutcome.

var action_id
var drive_id: StringName
var delta: float
var event_type


func _init(
	p_action_id,
	p_drive_id: StringName,
	p_delta: float,
	p_event_type = null
) -> void:
	assert(p_action_id != null, "DriveConsequenceDefinition requires ActionId")
	p_action_id.assert_kind(DomainId.Kind.ACTION)
	assert(DriveState.DRIVE_IDS.has(p_drive_id), "DriveConsequenceDefinition requires known drive")
	assert(is_finite(p_delta) and p_delta != 0.0, "Drive consequence delta must be finite and non-zero")
	assert(p_delta >= -1.0 and p_delta <= 1.0, "Drive consequence delta must be within [-1,1]")
	if p_event_type != null:
		p_event_type.assert_kind(DomainId.Kind.EVENT_DEFINITION)
	action_id = p_action_id
	drive_id = p_drive_id
	delta = p_delta
	event_type = p_event_type


func matches(outcome) -> bool:
	if outcome == null or outcome.action_id == null or not action_id.equals(outcome.action_id):
		return false
	return event_type == null or event_type.equals(outcome.event_type)


func stable_key() -> String:
	var event_key: String = "*" if event_type == null else String(event_type.sort_key())
	return "%s|%s|%s" % [action_id.sort_key(), event_key, String(drive_id)]
