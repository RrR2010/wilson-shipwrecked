class_name AssemblyValidityResult
extends RefCounted

enum Status {
	VALID,
	INCOMPLETE,
	INCOMPATIBLE_COMPONENT,
	BROKEN_BINDING,
	INVALID_CONFIGURATION,
}

var status: int
var diagnostics: Array[String]
var slot_results: Dictionary


func _init(p_status: int, p_diagnostics: Array[String] = [], p_slot_results: Dictionary = {}) -> void:
	assert(p_status >= 0 and p_status < Status.size(), "Invalid AssemblyValidity status")
	status = p_status
	diagnostics = p_diagnostics.duplicate()
	slot_results = p_slot_results.duplicate(true)


func is_valid() -> bool:
	return status == Status.VALID
