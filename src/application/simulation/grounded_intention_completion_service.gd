class_name GroundedIntentionCompletionService
extends RefCounted

const MutationResult = preload("res://src/domain/core/mutation_result.gd")

## Cross-owner application boundary that clears Wilson's current intention only
## when an authored completion policy matches a World-accepted action outcome.

var _intention_store
var _definitions: Array
var _applied_execution_ids: Dictionary = {}


func _init(p_intention_store, p_definitions: Array) -> void:
	assert(p_intention_store != null, "Grounded intention completion requires CurrentIntentionStore")
	_intention_store = p_intention_store
	_definitions = p_definitions.duplicate()
	_definitions.sort_custom(func(a, b): return a.stable_key() < b.stable_key())
	var seen: Dictionary = {}
	for definition in _definitions:
		assert(definition != null and definition.has_method("matches"), "Intention completion requires valid definitions")
		var key: String = definition.stable_key()
		assert(not seen.has(key), "Duplicate intention completion definition: %s" % key)
		seen[key] = true


func apply_grounded(outcome, world_commit_result):
	assert(outcome != null, "apply_grounded requires ActionOutcome")
	assert(world_commit_result != null, "apply_grounded requires WorldCommitResult")
	if not world_commit_result.ok:
		return MutationResult.success(&"intention_completion_not_grounded", null)
	if _applied_execution_ids.has(outcome.execution_id):
		return MutationResult.success(&"intention_completion_already_applied", null)
	var current = _intention_store.current()
	if current == null:
		return MutationResult.success(&"intention_completion_no_current", null)
	for definition in _definitions:
		if not definition.matches(current, outcome):
			continue
		var clear_result = _intention_store.clear()
		_applied_execution_ids[outcome.execution_id] = true
		return MutationResult.success(&"intention_completion_applied", clear_result.value)
	return MutationResult.success(&"intention_completion_no_match", null)
