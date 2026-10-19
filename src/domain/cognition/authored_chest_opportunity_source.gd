class_name AuthoredChestOpportunitySource
extends RefCounted

const DecisionCandidate = preload("res://src/domain/cognition/decision_candidate.gd")
const RoleBinding = preload("res://src/domain/actions/role_binding.gd")

## Temporary representative chest policy. Item knowledge must originate in
## an inspection-produced belief, never from hidden World containment.
var _world
var _beliefs
var _actor
var _chest
var _item
var _chest_belief
var _content_belief
var _open_property
var _inside
var _held_by
var _cycle_receipt
var _open_intention
var _withdraw_intention
var _deposit_intention

func _init(world, beliefs, actor, chest, item, chest_belief, content_belief, open_property, inside, held_by, cycle_receipt, open_intention, withdraw_intention, deposit_intention) -> void:
	_world = world
	_beliefs = beliefs
	_actor = actor
	_chest = chest
	_item = item
	_chest_belief = chest_belief
	_content_belief = content_belief
	_open_property = open_property
	_inside = inside
	_held_by = held_by
	_cycle_receipt = cycle_receipt
	_open_intention = open_intention
	_withdraw_intention = withdraw_intention
	_deposit_intention = deposit_intention
	assert(_open_intention != null and _withdraw_intention != null and _deposit_intention != null)

func generate() -> Array:
	var seen = _beliefs.get_entry(_chest_belief)
	if seen == null or seen.confidence < 0.5:
		return []
	if not _world.find_relations(_cycle_receipt, _chest, _chest).is_empty():
		return []
	var binding = RoleBinding.new()
	binding.bind(&"actor", _actor)
	binding.bind(&"target", _chest)
	binding.bind(&"chest", _chest)
	binding.bind(&"item", _item)
	if _world.get_instance_property(_chest, _open_property) != true:
		return [_candidate(_open_intention, binding, &"inspect_closed_chest")]
	var content = _beliefs.get_entry(_content_belief)
	if content == null or content.confidence < 0.5:
		return []
	if not _world.find_relations(_held_by, _item, _actor).is_empty():
		return [_candidate(_deposit_intention, binding, &"deposit_discovered_item")]
	if not _world.find_relations(_inside, _item, _chest).is_empty():
		return [_candidate(_withdraw_intention, binding, &"withdraw_discovered_item")]
	return []

func _candidate(intent, binding, source: StringName):
	return DecisionCandidate.new(intent, binding, DecisionCandidate.Scope.INTENTIONAL, 0.28, 0.0, 0.0, 0.0, 0.0, {"source": String(source)})
