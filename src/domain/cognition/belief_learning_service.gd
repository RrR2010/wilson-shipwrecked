class_name BeliefLearningService
extends RefCounted

const BeliefProposition = preload("res://src/domain/cognition/belief_proposition.gd")
const BeliefEvidence = preload("res://src/domain/cognition/belief_evidence.gd")

## Converts perceptual evidence into owner-local belief evidence.
## It does not read hidden World truth and does not mutate BeliefStore directly.

func derive(perceptual_evidence) -> Array:
	assert(perceptual_evidence != null, "derive requires PerceptualEvidence")
	var proposition = BeliefProposition.new(
		perceptual_evidence.predicate,
		[perceptual_evidence.subject, perceptual_evidence.value]
	)
	return [BeliefEvidence.new(
		proposition,
		true,
		perceptual_evidence.confidence,
		perceptual_evidence.source_execution_id,
		perceptual_evidence.modality
	)]
