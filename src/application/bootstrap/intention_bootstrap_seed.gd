class_name IntentionBootstrapSeed
extends RefCounted

var intention_id
var bindings
var selected_step_id: StringName


func _init(p_intention_id, p_bindings, p_selected_step_id: StringName) -> void:
	assert(p_intention_id != null, "IntentionBootstrapSeed requires intention id")
	assert(p_bindings != null, "IntentionBootstrapSeed requires bindings")
	assert(p_selected_step_id != &"", "IntentionBootstrapSeed requires selected step id")
	intention_id = p_intention_id
	bindings = p_bindings.duplicate_binding()
	selected_step_id = p_selected_step_id
