class_name CurrentIntentionState
extends RefCounted

const DomainId = preload("res://src/domain/core/domain_id.gd")

## Durable Wilson-owned selected intention. This is cognition state, not a
## decision projection. Bindings are copied so later candidate mutation cannot
## retroactively change the committed intention.

var intention_id
var bindings
var selected_step_id: StringName


func _init(p_intention_id, p_bindings, p_selected_step_id: StringName) -> void:
	assert(p_intention_id != null, "CurrentIntentionState requires SemanticIntentionId")
	p_intention_id.assert_kind(DomainId.Kind.SEMANTIC_INTENTION)
	assert(p_bindings != null, "CurrentIntentionState requires bindings")
	assert(p_selected_step_id != &"", "CurrentIntentionState requires selected step id")
	intention_id = p_intention_id
	bindings = p_bindings.duplicate_binding()
	selected_step_id = p_selected_step_id
