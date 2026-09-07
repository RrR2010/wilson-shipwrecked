class_name DriveBackedBelievedOpportunityCandidateSource
extends RefCounted

const RoleBinding = preload("res://src/domain/actions/role_binding.gd")
const DecisionCandidate = preload("res://src/domain/cognition/decision_candidate.gd")
const EpistemicClaim = preload("res://src/domain/cognition/epistemic_claim.gd")

## Produces target-bound intentional candidates only while their backing drive is
## in an authored meaningful urgency band. This composes Wilson-owned need state
## with Wilson-owned beliefs without consulting hidden World truth.

var _drive_state
var _belief_store
var _drive_definitions: Array
var _opportunity_definitions: Array


func _init(
	p_drive_state,
	p_belief_store,
	p_drive_definitions: Array,
	p_opportunity_definitions: Array
) -> void:
	assert(p_drive_state != null, "Drive-backed opportunity source requires DriveState")
	assert(p_belief_store != null, "Drive-backed opportunity source requires BeliefStore")
	_drive_state = p_drive_state
	_belief_store = p_belief_store
	_drive_definitions = p_drive_definitions.duplicate()
	_opportunity_definitions = p_opportunity_definitions.duplicate()


func generate() -> Array:
	var result: Array = []
	for entry in _belief_store.entries():
		if entry == null or entry.proposition == null or entry.proposition.claim == null:
			continue
		var claim = entry.proposition.claim
		for opportunity in _opportunity_definitions:
			if opportunity == null or not opportunity.matches(claim):
				continue
			for drive_definition in _drive_definitions:
				if drive_definition == null or not drive_definition.intention_id.equals(opportunity.intention_id):
					continue
				var current_band: int = _drive_state.band(drive_definition.drive_id)
				if current_band < drive_definition.minimum_band:
					continue
				var binding = RoleBinding.new()
				binding.bind(opportunity.target_role, _opportunity_target(claim))
				result.append(DecisionCandidate.new(
					opportunity.intention_id,
					binding,
					opportunity.scope,
					clampf(opportunity.base_score + drive_definition.base_score, -1.0, 1.0),
					0.0,
					entry.confidence,
					_drive_state.urgency(drive_definition.drive_id),
					0.0,
					{
						"source": "drive_backed_belief",
						"drive_id": String(drive_definition.drive_id),
						"drive_value": _drive_state.value(drive_definition.drive_id),
						"urgency_band": current_band,
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
