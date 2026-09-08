class_name BeliefReconciliationService
extends RefCounted

const EpistemicClaim = preload("res://src/domain/cognition/epistemic_claim.gd")
const BeliefEvidence = preload("res://src/domain/cognition/belief_evidence.gd")

## Reconciles newly perceived mutable facts against Wilson's existing beliefs.
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
	if claim == null or not _is_mutually_exclusive_observation(claim):
		return result

	for entry in existing_entries:
		if entry == null or entry.proposition == null or entry.proposition.claim == null:
			continue
		var existing_claim = entry.proposition.claim
		if not _same_mutable_fact(existing_claim, claim):
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


func _is_mutually_exclusive_observation(claim) -> bool:
	return claim.kind == EpistemicClaim.Kind.PROPERTY or claim.kind == EpistemicClaim.Kind.QUANTITY


func _same_mutable_fact(existing_claim, claim) -> bool:
	if existing_claim.kind != claim.kind:
		return false
	if existing_claim.subject.sort_key() != claim.subject.sort_key():
		return false
	if claim.kind == EpistemicClaim.Kind.QUANTITY:
		return true
	return existing_claim.semantic_id.equals(claim.semantic_id)
