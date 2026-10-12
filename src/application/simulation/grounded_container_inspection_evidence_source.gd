class_name GroundedContainerInspectionEvidenceSource
extends RefCounted

const EpistemicClaim = preload("res://src/domain/cognition/epistemic_claim.gd")
const PerceptualEvidence = preload("res://src/domain/cognition/perceptual_evidence.gd")
const PerceptionResult = preload("res://src/domain/cognition/perception_result.gd")

## Read-only World -> perception boundary. Never reveals an opaque inventory
## until an authored inspect action has successfully committed in World.
var _world
var _action_id
var _event_id
var _inside_relation
var _target_role: StringName

func _init(world_query, action_id, event_id, inside_relation, target_role: StringName = &"target") -> void:
	assert(world_query != null and action_id != null and event_id != null and inside_relation != null)
	_world = world_query
	_action_id = action_id
	_event_id = event_id
	_inside_relation = inside_relation
	_target_role = target_role

func collect(outcome, commit_result):
	if outcome == null or commit_result == null or not commit_result.ok:
		return PerceptionResult.new()
	if not outcome.action_id.equals(_action_id) or not outcome.event_type.equals(_event_id):
		return PerceptionResult.new()
	if not outcome.bindings.has(_target_role):
		return PerceptionResult.new()
	var container = outcome.bindings.get_subject(_target_role)
	var evidence: Array = []
	for item in _world.get_container_contents(container, _inside_relation):
		evidence.append(PerceptualEvidence.new(
			EpistemicClaim.relation_claim(item, _inside_relation, container),
			0.95, outcome.execution_id, &"inspection"
		))
		var quantity = _world.get_quantity(item)
		if quantity is int or quantity is float:
			evidence.append(PerceptualEvidence.new(
				EpistemicClaim.quantity_claim(item, quantity),
				0.95, outcome.execution_id, &"inspection"
			))
	return PerceptionResult.new([], evidence)
