class_name RelationTraversalResult
extends RefCounted

var subjects: Array
var relations: Array
var truncated: bool


func _init(p_subjects: Array, p_relations: Array, p_truncated: bool) -> void:
	subjects = p_subjects.duplicate()
	relations = p_relations.duplicate()
	truncated = p_truncated


func _to_string() -> String:
	return "RelationTraversalResult(subjects=%d, relations=%d, truncated=%s)" % [
		subjects.size(),
		relations.size(),
		truncated,
	]
