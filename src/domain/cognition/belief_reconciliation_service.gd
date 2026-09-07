class_name BeliefReconciliationService
extends RefCounted

const EpistemicClaim = preload("res://src/domain/cognition/epistemic_claim.gd")
const BeliefEvidence = preload("res://src/domain/cognition/belief_evidence.gd")

## Reconciles a newly perceived property value against Wilson's existing beliefs.
## This service reads only Wilson cognition plus perceptual evidence. Hidden World
## truth is intentionally outside this boundary.

var _learner


func _init(learner) -> void:
	assert(learner != null, "BeliefReconciliationService requires belief learner")
	_learner = learner


func derive(perceptual_evidence, existing_entries: Array) -> Array:
	assert(perceptual_evidence != null, "derive requires PerceptualEvidence")
	var result: Array = _learner.derive(perceptual_evidence)
	var claim = perceptual_evidence.claim
	if claim == null or claim.kind != EpistemicClaim.Kind.PROPERTY:
		return result

	for entry in existing_entries:
		if entry == null or entry.proposition == null or entry.proposition.claim == null:
			continue
		var existing_claim = entry.proposition.claim
		if existing_claim.kind != EpistemicClaim.Kind.PROPERTY:
			continue
		if existing_claim.subject.sort_key() != claim.subject.sort_key():
			continue
		if not existing_claim.semantic_id.equals(claim.semantic_id):
			continue
		if existing_claim.key() == claim.key():
			continue
		result.append(BeliefEvidence.new(
			entry.proposition,
			false,
			perceptual_evidence.confidence,
			perceptual_evidence.source_execution_id,
			perceptual_evidence.modality
		))
	return result
