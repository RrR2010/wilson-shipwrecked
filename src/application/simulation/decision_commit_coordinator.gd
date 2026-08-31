class_name DecisionCommitCoordinator
extends RefCounted

## Application-layer bridge from pure DecisionSelectionResult to Wilson's
## authoritative CurrentIntentionStore.

var _intention_store


func _init(intention_store) -> void:
	assert(intention_store != null, "DecisionCommitCoordinator requires CurrentIntentionStore")
	_intention_store = intention_store


func apply(decision_result, step_id: StringName):
	assert(decision_result != null, "apply requires DecisionSelectionResult")
	if not decision_result.has_selection():
		return null
	var selected = decision_result.selected_candidate
	return _intention_store.select(selected.intention_id, selected.bindings, step_id)
