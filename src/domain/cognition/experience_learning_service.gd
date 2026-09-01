class_name ExperienceLearningService
extends RefCounted

const EpistemicClaim = preload("res://src/domain/cognition/epistemic_claim.gd")
const AssociationImpact = preload("res://src/domain/cognition/association_impact.gd")
const HabitEvidence = preload("res://src/domain/cognition/habit_evidence.gd")
const EpisodeCandidate = preload("res://src/domain/cognition/episode_candidate.gd")
const RoleBinding = preload("res://src/domain/actions/role_binding.gd")

var _rules: Array


func _init(rules: Array) -> void:
	_rules = rules.duplicate()


func derive(perceptual_evidence) -> Dictionary:
	assert(perceptual_evidence != null, "ExperienceLearningService.derive requires PerceptualEvidence")
	var result: Dictionary = {
		"association_impacts": [],
		"habit_evidence": [],
		"episode_candidates": [],
	}
	var claim = perceptual_evidence.claim
	if claim.kind != EpistemicClaim.Kind.EVENT:
		return result
	for rule in _rules:
		if rule == null or not rule.matches(claim):
			continue
		if rule.has_association_impact():
			result["association_impacts"].append(AssociationImpact.new(
				claim.subject,
				rule.association_valence_delta,
				rule.association_attachment_delta,
				perceptual_evidence.confidence,
				perceptual_evidence.source_execution_id
			))
		if rule.episode_importance > 0.0:
			result["episode_candidates"].append(EpisodeCandidate.new(
				claim,
				rule.episode_importance * perceptual_evidence.confidence,
				perceptual_evidence.source_execution_id,
				perceptual_evidence.modality
			))
		if rule.has_habit_evidence():
			var bindings = RoleBinding.new()
			bindings.bind(rule.habit_binding_role, claim.subject)
			result["habit_evidence"].append(HabitEvidence.new(
				rule.habit_cue_id,
				rule.habit_intention_id,
				bindings,
				rule.habit_strength_delta,
				perceptual_evidence.confidence,
				perceptual_evidence.source_execution_id
			))
	return result
