class_name DynamicProcessStore
extends RefCounted

const DynamicProcessInstance = preload("res://src/domain/world/dynamic_process_instance.gd")

var _instances: Dictionary = {}


func add(instance) -> bool:
	assert(instance != null, "DynamicProcessStore.add requires instance")
	var key: StringName = instance.id
	if _instances.has(key):
		return false
	_instances[key] = instance
	return true


func get_process(process_id: StringName):
	return _instances.get(process_id)


func instances() -> Array:
	var result: Array = _instances.values()
	result.sort_custom(func(a, b): return String(a.id) < String(b.id))
	return result


func set_lifecycle(process_id: StringName, lifecycle: int) -> bool:
	assert(lifecycle >= 0 and lifecycle < DynamicProcessInstance.Lifecycle.size(), "Invalid dynamic process lifecycle")
	var instance = get_process(process_id)
	if instance == null:
		return false
	if instance.lifecycle == DynamicProcessInstance.Lifecycle.COMPLETED and lifecycle != DynamicProcessInstance.Lifecycle.COMPLETED:
		return false
	instance.lifecycle = lifecycle
	return true
