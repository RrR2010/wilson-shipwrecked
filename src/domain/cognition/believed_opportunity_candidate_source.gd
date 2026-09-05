class_name BelievedOpportunityCandidateSource
extends RefCounted

const RoleBinding = preload("res://src/domain/actions/role_binding.gd")
const DecisionCandidate = preload("res://src/domain/cognition/decision_candidate.gd")
const EpistemicClaim = preload("res://src/domain/cognition/epistemic_claim.gd")

## Reifies target-bound decision candidates from Wilson's durable beliefs.
##
## Unlike PerceivedOpportunityService, this source does not require fresh evidence
## in the current semantic step. It reads only Wilson-owned BeliefStore state, so a
## later reconsideration trigger (for example a drive urgency crossing) can act on
## an opportunity Wilson already knows about without consulting hidden World truth.

var _belief_store
var _definitions: Array


func _init(belief_store, definitions: Array) -> void:
	assert(belief_store != null, "BelievedOpportunityCandidateSource requires BeliefStore")
	_belief_store = belief_store
	_definitions = definitions.duplicate()


func generate() -> Array:
	var result: Array = []
	for entry in _belief_store.entries():
		if entry == null or entry.proposition == null or entry.proposition.claim == null:
			continue
		var claim = entry.proposition.claim
		for definition in _definitions:
			if definition == null or not definition.matches(claim):
				continue
			var binding = RoleBinding.new()
			binding.bind(definition.target_role, _opportunity_target(claim))
			result.append(DecisionCandidate.new(
				definition.intention_id,
				binding,
				definition.scope,
				definition.base_score,
				0.0,
				entry.confidence,
				0.0,
				0.0,
				{
					"source": "belief",
					"claim_kind": claim.kind,
					"claim_key": claim.sort_key(),
					"evidence_count": entry.evidence_count,
				}
			))
	result.sort_custom(func(a, b): return a.stable_key() < b.stable_key())
	return result


func _opportunity_target(claim):
	if claim.kind == EpistemicClaim.Kind.RELATION:
		return claim.object
	return claim.subject
