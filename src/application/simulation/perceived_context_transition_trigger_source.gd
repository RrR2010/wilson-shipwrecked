class_name PerceivedContextTransitionTriggerSource
extends RefCounted

const ReconsiderationGate = preload("res://src/application/simulation/reconsideration_gate.gd")

## Derives CONTEXT_TRANSITION only from Wilson-observed events whose authored
## EventDefinition declares that semantic meaning. Hidden World state is never read.

var _content


func _init(content_registry) -> void:
	assert(content_registry != null, "PerceivedContextTransitionTriggerSource requires ContentRegistry")
	assert(content_registry.has_method("get_event_definition"), "Content registry must expose get_event_definition()")
	_content = content_registry


func derive(perception_result) -> Array[int]:
	assert(perception_result != null, "derive requires PerceptionResult")
	for observed_event in perception_result.observed_events:
		if observed_event == null or observed_event.event_type == null:
			continue
		var definition = _content.get_event_definition(observed_event.event_type)
		if definition != null and bool(definition.context_transition):
			return [ReconsiderationGate.Trigger.CONTEXT_TRANSITION]
	return []
