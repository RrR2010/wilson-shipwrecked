extends RefCounted

var execution_id: StringName
var intention


func _init(p_execution_id: StringName = &"", p_intention = null) -> void:
	execution_id = p_execution_id
	intention = p_intention


func active_execution_id() -> StringName:
	return execution_id


func current_intention():
	return intention
