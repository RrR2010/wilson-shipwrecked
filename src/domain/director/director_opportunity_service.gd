class_name DirectorOpportunityService
extends RefCounted

const DirectorOpportunityState = preload("res://src/domain/director/director_opportunity_state.gd")

var _store
var _definitions: Dictionary = {}

func _init(store, definitions: Array) -> void:
	assert(store != null, "DirectorOpportunityService requires store")
	_store = store
	for definition in definitions:
		assert(definition != null, "Director opportunity definition cannot be null")
		assert(not _definitions.has(definition.id), "Duplicate director opportunity definition")
		_definitions[definition.id] = definition
		if _store.get_state(definition.id) == null:
			_store.add(DirectorOpportunityState.new(definition.id))

func advance(elapsed: float) -> void:
	assert(elapsed >= 0.0 and is_finite(elapsed), "elapsed must be finite and non-negative")
	for state in _store.states():
		if state.lifecycle != DirectorOpportunityState.Lifecycle.COOLDOWN:
			continue
		state.cooldown_remaining = maxf(0.0, state.cooldown_remaining - elapsed)
		if state.cooldown_remaining <= 0.0:
			var definition = _definitions[state.definition_id]
			state.lifecycle = DirectorOpportunityState.Lifecycle.EXHAUSTED if state.activation_count >= definition.max_activations else DirectorOpportunityState.Lifecycle.ELIGIBLE

func activate(definition_id: StringName) -> bool:
	var state = _store.get_state(definition_id)
	if state == null or state.lifecycle != DirectorOpportunityState.Lifecycle.ELIGIBLE:
		return false
	state.lifecycle = DirectorOpportunityState.Lifecycle.ACTIVE
	state.activation_count += 1
	return true

func resolve(definition_id: StringName) -> bool:
	var state = _store.get_state(definition_id)
	if state == null or state.lifecycle != DirectorOpportunityState.Lifecycle.ACTIVE:
		return false
	var definition = _definitions[definition_id]
	if state.activation_count >= definition.max_activations:
		state.lifecycle = DirectorOpportunityState.Lifecycle.EXHAUSTED
		state.cooldown_remaining = 0.0
	else:
		state.lifecycle = DirectorOpportunityState.Lifecycle.COOLDOWN
		state.cooldown_remaining = definition.cooldown_seconds
	return true
