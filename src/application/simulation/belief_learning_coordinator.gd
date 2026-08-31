class_name BeliefLearningCoordinator
extends RefCounted

## Application-layer bridge from perceptual evidence proposals to Wilson's
## authoritative BeliefStore. The domain learner derives evidence; this
## coordinator is the named owner boundary that applies it.

var _learner
var _belief_store


func _init(learner, belief_store) -> void:
	assert(learner != null, "BeliefLearningCoordinator requires learner")
	assert(belief_store != null, "BeliefLearningCoordinator requires BeliefStore")
	_learner = learner
	_belief_store = belief_store


func process(perception_result) -> Dictionary:
	assert(perception_result != null, "process requires PerceptionResult")
	var derived_evidence: Array = []
	var mutation_results: Array = []
	for perceptual_evidence in perception_result.evidence:
		var derived: Array = _learner.derive(perceptual_evidence)
		for belief_evidence in derived:
			derived_evidence.append(belief_evidence)
			mutation_results.append(_belief_store.apply_evidence(belief_evidence))
	return {
		"derived_evidence": derived_evidence,
		"mutation_results": mutation_results,
	}
