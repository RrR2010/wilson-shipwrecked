class_name PerceivedThreatService
extends RefCounted

const EpistemicClaim = preload("res://src/domain/cognition/epistemic_claim.gd")
const PerceivedThreat = preload("res://src/domain/cognition/perceived_threat.gd")

var _rules: Array


func _init(rules: Array) -> void:
	_rules = rules.duplicate()


func derive(perception_result) -> Array:
	assert(perception_result != null, "PerceivedThreatService requires PerceptionResult")
	var result: Array = []
	for evidence in perception_result.evidence:
		if evidence == null or evidence.proposition == null:
			continue
		var claim = evidence.proposition.claim
		if claim.kind != EpistemicClaim.Kind.EVENT:
			continue
		for rule in _rules:
			if rule == null:
				continue
			if not claim.semantic_id.equals(rule.event_type) or claim.role_name != rule.perceived_role:
				continue
			if evidence.confidence < rule.minimum_confidence:
				continue
			result.append(PerceivedThreat.new(
				claim.subject,
				claim.semantic_id,
				rule.estimated_severity,
				rule.estimated_urgency,
				evidence.confidence,
				evidence.source_execution_id
			))
	result.sort_custom(func(a, b): return a.stable_key() < b.stable_key())
	return result
