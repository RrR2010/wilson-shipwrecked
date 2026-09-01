class_name DirectorCandidateSource
extends RefCounted

const DecisionCandidate = preload("res://src/domain/cognition/decision_candidate.gd")
const DirectorOpportunityState = preload("res://src/domain/director/director_opportunity_state.gd")

var _store
var _definitions: Dictionary = {}

func _init(store, definitions: Array) -> void:
	_store = store
	for definition in definitions:
		_definitions[definition.id] = definition

func generate() -> Array:
	var result: Array = []
	for state in _store.states():
		if state.lifecycle != DirectorOpportunityState.Lifecycle.ACTIVE:
			continue
		var definition = _definitions.get(state.definition_id)
		if definition == null:
			continue
		result.append(DecisionCandidate.new(
			definition.intention_id,
			definition.bindings.duplicate_binding(),
			DecisionCandidate.Scope.INTENTIONAL,
			0.0,
			0.0,
			0.0,
			0.0,
			definition.candidate_bias,
			{"source": "director", "opportunity_id": String(definition.id)}
		))
	result.sort_custom(func(a, b): return a.stable_key() < b.stable_key())
	return result
