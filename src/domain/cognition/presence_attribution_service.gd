class_name PresenceAttributionService
extends RefCounted

const EpistemicClaim = preload("res://src/domain/cognition/epistemic_claim.gd")
const PresenceAttributionEvidence = preload("res://src/domain/cognition/presence_attribution_evidence.gd")

## Derives Wilson-relative unseen-agency evidence strictly from PerceptionResult.
## Player-private intent is intentionally outside this boundary.

var _rules: Array


func _init(rules: Array) -> void:
	_rules = rules.duplicate()


func derive(perception_result) -> Array:
	assert(perception_result != null, "PresenceAttributionService requires PerceptionResult")
	var result: Array = []
	for evidence in perception_result.evidence:
		if evidence == null or evidence.claim == null:
			continue
		if evidence.claim.kind != EpistemicClaim.Kind.EVENT:
			continue
		for rule in _rules:
			if rule == null or not rule.matches(evidence):
				continue
			result.append(PresenceAttributionEvidence.new(
				rule.agency_delta,
				rule.outcome_valence,
				rule.dependency_delta,
				evidence.confidence,
				evidence.source_execution_id
			))
	return result
