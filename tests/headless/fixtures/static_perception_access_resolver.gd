extends RefCounted

var access_by_execution: Dictionary


func _init(p_access_by_execution: Dictionary = {}) -> void:
	access_by_execution = p_access_by_execution.duplicate()


func resolve(_world_events: Array, _step) -> Dictionary:
	return access_by_execution.duplicate()
