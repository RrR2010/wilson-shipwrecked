class_name SemanticChangeSet
extends RefCounted

var changes: Array

func _init(p_changes: Array = []) -> void:
	changes = p_changes.duplicate()

func add(change) -> void:
	assert(change != null, "SemanticChangeSet cannot add null")
	changes.append(change)

func append_set(other) -> void:
	assert(other != null and other is SemanticChangeSet, "append_set requires SemanticChangeSet")
	changes.append_array(other.changes)

func is_empty() -> bool:
	return changes.is_empty()

func duplicate_set():
	return get_script().new(changes)
