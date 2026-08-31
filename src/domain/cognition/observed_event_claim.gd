class_name ObservedEventClaim
extends RefCounted

const DomainId = preload("res://src/domain/core/domain_id.gd")

## Stable epistemic claim derived from an observed event role.
## It carries only Wilson-accessible semantics and is safe for durable proposition identity.

var event_type
var role_name: StringName


func _init(p_event_type, p_role_name: StringName) -> void:
	assert(p_event_type != null, "ObservedEventClaim requires event type")
	assert(p_role_name != &"", "ObservedEventClaim requires role")
	p_event_type.assert_kind(DomainId.Kind.EVENT_DEFINITION)
	event_type = p_event_type
	role_name = p_role_name


func key() -> StringName:
	return StringName("observed_event|%s|role:%s" % [event_type.sort_key(), String(role_name)])


func sort_key() -> String:
	return String(key())
