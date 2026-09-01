extends RefCounted

const SemanticChangeSet = preload("res://src/domain/world/semantic_change_set.gd")


func advance(_elapsed: float) -> Dictionary:
	return {
		"change_set": SemanticChangeSet.new(),
		"progressed": [],
		"completed": [],
		"diagnostics": [],
	}
