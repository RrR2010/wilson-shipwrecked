class_name SemanticChangeSet
extends RefCounted

var changes: Array

func _init(p_changes: Array = []) -> void:
	changes = p_changes.duplicate()

func add(change) -> void:
	assert(change != null, "SemanticChangeSet cannot add null")
	changes.append(change)

func is_empty() -> bool:
	return changes.is_empty()

func duplicate_set():
	return SemanticChangeSet.new(changes)
