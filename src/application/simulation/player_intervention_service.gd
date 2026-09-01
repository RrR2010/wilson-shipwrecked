class_name PlayerInterventionService
extends RefCounted

const MutationResult = preload("res://src/domain/core/mutation_result.gd")

var _player_state
var _world_intervention_port
var _definitions: Dictionary = {}

func _init(player_state, world_intervention_port, definitions: Array) -> void:
	assert(player_state != null, "PlayerInterventionService requires PlayerRunState")
	assert(world_intervention_port != null and world_intervention_port.has_method("apply_intervention"), "World intervention port must implement apply_intervention(request)")
	_player_state = player_state
	_world_intervention_port = world_intervention_port
	for definition in definitions:
		assert(definition != null, "Intervention definition cannot be null")
		assert(not _definitions.has(definition.id), "Duplicate intervention definition")
		_definitions[definition.id] = definition

func apply(request):
	assert(request != null, "apply requires PhysicalInterventionRequest")
	var definition = _definitions.get(request.definition_id)
	if definition == null:
		return MutationResult.failure(&"unknown_intervention", [String(request.definition_id)])
	if not _player_state.has_permission(definition.permission):
		return MutationResult.failure(&"intervention_not_permitted", [String(definition.permission)])
	if _player_state.god_power < definition.god_power_cost:
		return MutationResult.failure(&"insufficient_god_power", [])
	var world_result = _world_intervention_port.apply_intervention(request)
	if world_result == null or not world_result.ok:
		return world_result if world_result != null else MutationResult.failure(&"world_intervention_failed", [])
	assert(_player_state.spend(definition.god_power_cost), "Validated intervention cost must remain affordable until commit")
	return MutationResult.success(&"intervention_committed", world_result.value)
