class_name PhysicalInterventionRequest
extends RefCounted

var definition_id: StringName
var payload: Dictionary

func _init(p_definition_id: StringName, p_payload: Dictionary = {}) -> void:
	assert(p_definition_id != &"", "Physical intervention request requires definition id")
	definition_id = p_definition_id
	payload = p_payload.duplicate(true)
