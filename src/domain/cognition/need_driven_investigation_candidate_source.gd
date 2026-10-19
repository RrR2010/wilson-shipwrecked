class_name NeedDrivenInvestigationCandidateSource
extends RefCounted

const DecisionCandidate = preload("res://src/domain/cognition/decision_candidate.gd")
const DriveState = preload("res://src/domain/cognition/drive_state.gd")
const EpistemicClaim = preload("res://src/domain/cognition/epistemic_claim.gd")
const RoleBinding = preload("res://src/domain/actions/role_binding.gd")

## Reuses a known investigation affordance when a critical need has no
## actionable known resource. Never invents a target or queries World truth.
var _drives
var _beliefs
var _resource_property
var _investigation_property
var _investigation_intention


func _init(drives, beliefs, resource_property, investigation_property, investigation_intention) -> void:
	_drives = drives
	_beliefs = beliefs
	_resource_property = resource_property
	_investigation_property = investigation_property
	_investigation_intention = investigation_intention


func generate() -> Array:
	if _drives.band(DriveState.HUNGER) != DriveState.UrgencyBand.URGENT:
		return []
	var known_food := false
	var investigations: Array = []
	for entry in _beliefs.entries():
		if entry.confidence < 0.5:
			continue
		var claim = entry.proposition.claim
		if claim.kind != EpistemicClaim.Kind.PROPERTY or claim.value != true:
			continue
		if claim.semantic_id.equals(_resource_property):
			known_food = true
		elif claim.semantic_id.equals(_investigation_property):
			var bindings = RoleBinding.new()
			bindings.bind(&"target", claim.subject)
			investigations.append(DecisionCandidate.new(
				_investigation_intention, bindings, DecisionCandidate.Scope.INTENTIONAL,
				0.08, 0.0, entry.confidence, _drives.urgency(DriveState.HUNGER),
				0.0, {"source": "need_driven_investigation", "drive_id": "hunger",
					"claim_key": claim.sort_key(), "belief_modality": String(entry.last_modality)}
			))
	if known_food:
		return []
	investigations.sort_custom(func(a, b): return a.stable_key() < b.stable_key())
	return investigations
