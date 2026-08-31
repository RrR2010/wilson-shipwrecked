class_name PerceivedOpportunityService
extends RefCounted

const RoleBinding = preload("res://src/domain/actions/role_binding.gd")
const BeliefProposition = preload("res://src/domain/cognition/belief_proposition.gd")
const DecisionCandidate = preload("res://src/domain/cognition/decision_candidate.gd")

## Converts accessible perceptual evidence into Wilson-relative decision candidates.
## It never reads hidden World state. Belief confidence is optional support, not truth.

func generate(perception_result, belief_store, definitions: Array) -> Array:
	assert(perception_result != null, "generate requires PerceptionResult")
	assert(belief_store != null, "generate requires BeliefStore")
	var result: Array = []
	for evidence in perception_result.evidence:
		for definition in definitions:
			if evidence.predicate != definition.evidence_predicate:
				continue
			var binding = RoleBinding.new()
			binding.bind(definition.target_role, evidence.subject)
			var proposition = BeliefProposition.new(evidence.predicate, [evidence.subject, evidence.value])
			var entry = belief_store.get_entry(proposition)
			var belief_support := 0.0
			if entry != null:
				belief_support = entry.confidence
			result.append(DecisionCandidate.new(
				definition.intention_id,
				binding,
				definition.scope,
				definition.base_score,
				evidence.confidence,
				belief_support,
				0.0,
				0.0,
				{
					"source": "perceptual_evidence",
					"predicate": String(evidence.predicate),
					"modality": String(evidence.modality),
					"source_execution_id": String(evidence.source_execution_id),
				}
			))
	result.sort_custom(func(a, b): return a.stable_key() < b.stable_key())
	return result
