class_name GodotSceneSpatialRegistry
extends RefCounted

const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")

## Explicit adapter mapping stable semantic runtime refs and interaction anchors
## to live Godot Node3D instances.
##
## Node names, scene paths and instance IDs are never inferred as domain identity.

var _nodes_by_ref: Dictionary = {}
var _anchors_by_key: Dictionary = {}

func bind(runtime_ref: RuntimeWorldRef, node: Node3D) -> bool:
	if runtime_ref == null or node == null:
		return false
	var key := runtime_ref.key()
	if _nodes_by_ref.has(key):
		return _nodes_by_ref[key] == node
	_nodes_by_ref[key] = node
	return true

func bind_anchor(runtime_ref: RuntimeWorldRef, interaction_id: StringName, node: Node3D) -> bool:
	if runtime_ref == null or interaction_id.is_empty() or node == null:
		return false
	var key := _anchor_key(runtime_ref, interaction_id)
	if _anchors_by_key.has(key):
		return _anchors_by_key[key] == node
	_anchors_by_key[key] = node
	return true

func unbind(runtime_ref: RuntimeWorldRef, node: Node3D = null) -> bool:
	if runtime_ref == null:
		return false
	var key := runtime_ref.key()
	if not _nodes_by_ref.has(key):
		return false
	if node != null and _nodes_by_ref[key] != node:
		return false
	_nodes_by_ref.erase(key)
	return true

func resolve(runtime_ref: RuntimeWorldRef) -> Node3D:
	if runtime_ref == null:
		return null
	return _resolve_from(_nodes_by_ref, runtime_ref.key())

func resolve_anchor(runtime_ref: RuntimeWorldRef, interaction_id: StringName) -> Node3D:
	if runtime_ref == null:
		return null
	if interaction_id.is_empty():
		return resolve(runtime_ref)
	return _resolve_from(_anchors_by_key, _anchor_key(runtime_ref, interaction_id))

func has(runtime_ref: RuntimeWorldRef) -> bool:
	return resolve(runtime_ref) != null

func clear() -> void:
	_nodes_by_ref.clear()
	_anchors_by_key.clear()

func _resolve_from(source: Dictionary, key: Variant) -> Node3D:
	var node = source.get(key)
	if node == null or not is_instance_valid(node):
		source.erase(key)
		return null
	return node as Node3D

func _anchor_key(runtime_ref: RuntimeWorldRef, interaction_id: StringName) -> String:
	return "%s|%s" % [runtime_ref.key(), interaction_id]
