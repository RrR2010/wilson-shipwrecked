class_name PresenceLearningService
extends RefCounted

const PresenceEvidence = preload("res://src/domain/cognition/presence_evidence.gd")


func derive(attribution_evidence):
	assert(attribution_evidence != null, "PresenceLearningService requires attribution evidence")
	return PresenceEvidence.new(
		attribution_evidence.agency_delta,
		attribution_evidence.outcome_valence,
		attribution_evidence.dependency_delta,
		attribution_evidence.confidence,
		attribution_evidence.source_execution_id
	)
