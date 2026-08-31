class_name ProjectStore
extends RefCounted

const ProjectInstance = preload("res://src/domain/projects/project_instance.gd")

var _instances: Dictionary = {}


func add(instance) -> bool:
	assert(instance != null, "ProjectStore.add requires instance")
	var key := instance.id.key()
	if _instances.has(key):
		return false
	_instances[key] = instance
	return true


func get_instance(project_id):
	assert(project_id != null, "ProjectStore.get_instance requires project id")
	return _instances.get(project_id.key())


func instances() -> Array:
	var result: Array = _instances.values()
	result.sort_custom(func(a, b): return a.id.sort_key() < b.id.sort_key())
	return result


func apply_contribution(project_id, required_contributions: int) -> bool:
	var instance = get_instance(project_id)
	if instance == null or not instance.is_active():
		return false
	instance.contribution_count += 1
	if instance.contribution_count >= required_contributions:
		instance.lifecycle = ProjectInstance.Lifecycle.COMPLETED
	return true


func set_lifecycle(project_id, lifecycle: int) -> bool:
	var instance = get_instance(project_id)
	if instance == null:
		return false
	instance.lifecycle = lifecycle
	return true
