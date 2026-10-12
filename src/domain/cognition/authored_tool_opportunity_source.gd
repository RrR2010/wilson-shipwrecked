class_name AuthoredToolOpportunitySource
extends RefCounted

const DecisionCandidate = preload("res://src/domain/cognition/decision_candidate.gd")
const RoleBinding = preload("res://src/domain/actions/role_binding.gd")

## A bounded authored opportunity: pick up a known tool, then inspect a known
## target while held. World owns possession; cognition owns discovery.
var _world
var _beliefs
var _tool
var _actor
var _target
var _known_tool
var _known_target
var _held_relation
var _inspection_receipt
var _pickup_intention
var _use_intention


func _init(world, beliefs, tool, actor, target, known_tool, known_target, held_relation, inspection_receipt, pickup_intention, use_intention) -> void:
	assert(pickup_intention != null and use_intention != null, "AuthoredToolOpportunitySource requires both semantic intention ids")
	_world = world
	_beliefs = beliefs
	_tool = tool
	_actor = actor
	_target = target
	_known_tool = known_tool
	_known_target = known_target
	_held_relation = held_relation
	_inspection_receipt = inspection_receipt
	_pickup_intention = pickup_intention
	_use_intention = use_intention


func generate() -> Array:
	# Never emit a candidate that would violate CurrentIntentionStore's invariant.
	if _pickup_intention == null or _use_intention == null:
		return []
	var known = _beliefs.get_entry(_known_tool)
	if known == null or known.confidence < 0.5:
		return []
	var held = not _world.find_relations(_held_relation, _tool, _actor).is_empty()
	var bindings = RoleBinding.new()
	bindings.bind(&"actor", _actor)
	bindings.bind(&"tool", _tool)
	if not held:
		bindings.bind(&"target", _tool)
		return [DecisionCandidate.new(_pickup_intention, bindings, DecisionCandidate.Scope.INTENTIONAL, 0.65, 0.0, 0.0, 0.0, 0.0, {"source": "known_tool"})]
	if _beliefs.get_entry(_known_target) == null:
		return []
	if not _world.find_relations(_inspection_receipt, _target, _target).is_empty():
		return []
	bindings.bind(&"target", _target)
	return [DecisionCandidate.new(_use_intention, bindings, DecisionCandidate.Scope.INTENTIONAL, 0.56, 0.0, 0.0, 0.0, 0.0, {"source": "held_tool_exploration"})]
