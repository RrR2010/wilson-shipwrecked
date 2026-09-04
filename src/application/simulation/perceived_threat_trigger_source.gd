class_name PerceivedThreatTriggerSource
extends RefCounted

const ReconsiderationGate = preload("res://src/application/simulation/reconsideration_gate.gd")

## Derives reconsideration triggers only from Wilson-accessible threat evidence.
##
## This bridge deliberately does not inspect hidden World hazard truth. It delegates
## threat interpretation to PerceivedThreatService, then wakes the cognition gate only
## when authored threat rules admit at least one perceived threat.

var _threat_service


func _init(threat_service) -> void:
	assert(threat_service != null, "PerceivedThreatTriggerSource requires PerceivedThreatService")
	assert(threat_service.has_method("derive"), "Threat service must implement derive(perception_result)")
	_threat_service = threat_service


func derive(perception_result) -> Array[int]:
	assert(perception_result != null, "derive requires PerceptionResult")
	var threats: Array = _threat_service.derive(perception_result)
	if threats.is_empty():
		return []
	return [ReconsiderationGate.Trigger.THREAT]
