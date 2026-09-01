class_name GodotSceneSpatialRegistry
extends RefCounted

## Explicit adapter mapping stable semantic runtime refs to live Godot Node3D instances.
##
## Node names, scene paths and instance IDs are never inferred as domain identity.

var _nodes_by_ref: Dictionary = {}

func bind(runtime_ref: StringName, node: Node3D) -> bool:
	if runtime_ref.is_empty() or node == null:
		return false
	if _nodes_by_ref.has(runtime_ref):
		return _nodes_by_ref[runtime_ref] == node
	_nodes_by_ref[runtime_ref] = node
	return true

func unbind(runtime_ref: StringName, node: Node3D = null) -> bool:
	if not _nodes_by_ref.has(runtime_ref):
		return false
	if node != null and _nodes_by_ref[runtime_ref] != node:
		return false
	_nodes_by_ref.erase(runtime_ref)
	return true

func resolve(runtime_ref: StringName) -> Node3D:
	var node = _nodes_by_ref.get(runtime_ref)
	if node == null or not is_instance_valid(node):
		_nodes_by_ref.erase(runtime_ref)
		return null
	return node as Node3D

func has(runtime_ref: StringName) -> bool:
	return resolve(runtime_ref) != null

func clear() -> void:
	_nodes_by_ref.clear()
