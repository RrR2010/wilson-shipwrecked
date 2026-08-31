extends RefCounted

const WorldAdvanceResult = preload("res://src/application/simulation/world_advance_result.gd")

var events: Array


func _init(p_events: Array = []) -> void:
	events = p_events.duplicate()


func advance(_elapsed: float, _step):
	return WorldAdvanceResult.new(events)
