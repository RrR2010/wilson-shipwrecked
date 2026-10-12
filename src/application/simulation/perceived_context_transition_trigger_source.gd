class_name PerceivedContextTransitionTriggerSource
extends RefCounted

const ReconsiderationGate = preload("res://src/application/simulation/reconsideration_gate.gd")
const EpistemicClaim = preload("res://src/domain/cognition/epistemic_claim.gd")

## Derives CONTEXT_TRANSITION only from Wilson-observed events whose authored
## EventDefinition declares that semantic meaning. Hidden World state is never read.

var _content
var _observe_quantity: bool


func _init(content_registry, observe_quantity: bool = false) -> void:
	assert(content_registry != null, "PerceivedContextTransitionTriggerSource requires ContentRegistry")
	assert(content_registry.has_method("get_event_definition"), "Content registry must expose get_event_definition()")
	_content = content_registry
	_observe_quantity = observe_quantity


func derive(perception_result) -> Array[int]:
	assert(perception_result != null, "derive requires PerceptionResult")
	if _observe_quantity:
		for evidence in perception_result.evidence:
			if evidence.claim != null and evidence.claim.kind == EpistemicClaim.Kind.QUANTITY:
				return [ReconsiderationGate.Trigger.ACTION_INVALIDATION]
	for observed_event in perception_result.observed_events:
		if observed_event == null or observed_event.event_type == null:
			continue
		var definition = _content.get_event_definition(observed_event.event_type)
		if definition != null and bool(definition.context_transition):
			return [ReconsiderationGate.Trigger.CONTEXT_TRANSITION]
	return []
