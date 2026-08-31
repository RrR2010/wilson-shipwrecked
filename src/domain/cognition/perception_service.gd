class_name PerceptionService
extends RefCounted

const ObservedEvent = preload("res://src/domain/cognition/observed_event.gd")
const EpistemicClaim = preload("res://src/domain/cognition/epistemic_claim.gd")
const PerceptualEvidence = preload("res://src/domain/cognition/perceptual_evidence.gd")
const PerceptionResult = preload("res://src/domain/cognition/perception_result.gd")

## Pure projection from authoritative WorldEvent[] + derived accessibility.
## Produces observations/evidence only; never writes cognition state.

func perceive(world_events: Array, access_by_execution: Dictionary):
	var observed_events: Array = []
	var evidence: Array = []
	var diagnostics: Array[String] = []

	for world_event in world_events:
		assert(world_event != null, "PerceptionService world_events cannot contain null")
		var access = access_by_execution.get(world_event.execution_id)
		if access == null:
			diagnostics.append("No perception access for execution %s" % String(world_event.execution_id))
			continue
		if not access.observable:
			diagnostics.append("Execution %s not observable" % String(world_event.execution_id))
			continue

		var perceived_bindings: Dictionary = {}
		for role_name in access.accessible_roles:
			if not world_event.bindings.has(role_name):
				continue
			var subject = world_event.bindings.get_subject(role_name)
			perceived_bindings[role_name] = subject
			var modality: StringName = &"unspecified"
			if not access.modalities.is_empty():
				modality = access.modalities[0]
			evidence.append(PerceptualEvidence.new(
				EpistemicClaim.event_claim(subject, world_event.event_type, role_name),
				access.confidence,
				world_event.execution_id,
				modality
			))

		observed_events.append(ObservedEvent.new(
			world_event.event_type,
			world_event.action_id,
			world_event.execution_id,
			perceived_bindings,
			access.modalities
		))

	return PerceptionResult.new(observed_events, evidence, diagnostics)
