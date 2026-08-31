class_name ProjectCandidateSource
extends RefCounted

const DecisionCandidate = preload("res://src/domain/cognition/decision_candidate.gd")

var _store
var _definitions_by_key: Dictionary = {}


func _init(store, definitions: Array) -> void:
	assert(store != null, "ProjectCandidateSource requires ProjectStore")
	_store = store
	for definition in definitions:
		assert(definition != null, "Project definitions cannot contain null")
		_definitions_by_key[definition.id.key()] = definition


func generate() -> Array:
	var result: Array = []
	for instance in _store.instances():
		if not instance.is_active():
			continue
		var definition = _definitions_by_key.get(instance.definition_id.key())
		if definition == null:
			continue
		result.append(DecisionCandidate.new(
			definition.intention_id,
			instance.subject_bindings.duplicate_binding(),
			DecisionCandidate.Scope.INTENTIONAL,
			definition.candidate_base_score,
			0.0,
			0.0,
			0.0,
			0.0,
			{
				"source": "project",
				"project_id": instance.id.sort_key(),
				"project_definition_id": instance.definition_id.sort_key(),
				"contribution_count": instance.contribution_count,
			}
		))
	result.sort_custom(func(a, b): return a.stable_key() < b.stable_key())
	return result
