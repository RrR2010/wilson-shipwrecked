class_name DecisionCommitCoordinator
extends RefCounted

const DecisionCandidate = preload("res://src/domain/cognition/decision_candidate.gd")

## Application-layer bridge from pure DecisionSelectionResult to Wilson's
## authoritative CurrentIntentionStore.
## Immediate-threat commitments may temporarily suspend the prior autonomous
## intention instead of discarding it.

var _intention_store


func _init(intention_store) -> void:
	assert(intention_store != null, "DecisionCommitCoordinator requires CurrentIntentionStore")
	_intention_store = intention_store


func apply(decision_result, step_id: StringName):
	assert(decision_result != null, "apply requires DecisionSelectionResult")
	if not decision_result.has_selection():
		return null
	var selected = decision_result.selected_candidate
	if selected.scope == DecisionCandidate.Scope.IMMEDIATE_THREAT and _intention_store.has_current() and not _intention_store.has_suspended():
		var suspend_result = _intention_store.suspend_current()
		if not suspend_result.ok:
			return suspend_result
	return _intention_store.select(selected.intention_id, selected.bindings, step_id)
