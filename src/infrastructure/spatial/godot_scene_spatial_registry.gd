class_name GodotSceneSpatialRegistry
extends RefCounted

const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")

## Explicit adapter mapping stable semantic runtime refs and interaction anchors
## to live Godot Node3D instances.
##
## Node names, scene paths and instance IDs are never inferred as domain identity.

var _nodes_by_ref: Dictionary = {}
var _refs_by_node_id: Dictionary = {}
var _anchors_by_key: Dictionary = {}

func bind(runtime_ref: RuntimeWorldRef, node: Node3D) -> bool:
	if runtime_ref == null or node == null:
		return false
	var key := runtime_ref.key()
	var node_id := node.get_instance_id()
	if _nodes_by_ref.has(key):
		return _nodes_by_ref[key] == node
	if _refs_by_node_id.has(node_id):
		return _refs_by_node_id[node_id].equals(runtime_ref)
	_nodes_by_ref[key] = node
	_refs_by_node_id[node_id] = runtime_ref
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
	var bound_node = _nodes_by_ref[key]
	if node != null and bound_node != node:
		return false
	_nodes_by_ref.erase(key)
	if bound_node != null and is_instance_valid(bound_node):
		var node_id := bound_node.get_instance_id()
		var reverse_ref = _refs_by_node_id.get(node_id)
		if reverse_ref != null and reverse_ref.equals(runtime_ref):
			_refs_by_node_id.erase(node_id)
	return true

func resolve(runtime_ref: RuntimeWorldRef) -> Node3D:
	if runtime_ref == null:
		return null
	return _resolve_from(_nodes_by_ref, runtime_ref.key())

func runtime_ref_for_node(node: Node3D):
	if node == null or not is_instance_valid(node):
		return null
	return _refs_by_node_id.get(node.get_instance_id())

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
	_refs_by_node_id.clear()
	_anchors_by_key.clear()

func _resolve_from(source: Dictionary, key: Variant) -> Node3D:
	var node = source.get(key)
	if node == null or not is_instance_valid(node):
		source.erase(key)
		return null
	return node as Node3D

func _anchor_key(runtime_ref: RuntimeWorldRef, interaction_id: StringName) -> String:
	return "%s|%s" % [runtime_ref.key(), interaction_id]
