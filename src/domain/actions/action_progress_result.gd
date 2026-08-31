class_name ActionProgressResult
extends RefCounted

var execution_id: StringName
var progress: float
var committed: bool
var completed: bool
var new_outcome


func _init(
	p_execution_id: StringName,
	p_progress: float,
	p_committed: bool,
	p_completed: bool,
	p_new_outcome = null
) -> void:
	execution_id = p_execution_id
	progress = p_progress
	committed = p_committed
	completed = p_completed
	new_outcome = p_new_outcome
