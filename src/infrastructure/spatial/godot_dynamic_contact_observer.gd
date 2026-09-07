class_name GodotDynamicContactObserver
extends RefCounted

const PhysicalObservation = preload("res://src/application/simulation/physical_observation.gd")

## Converts Godot body-entered callbacks into non-authoritative PhysicalObservation
## facts. Semantic identity comes only from GodotSceneSpatialRegistry bindings.
## This adapter never decides whether contact is harmful and never mutates World.
##
## Contact observations are oriented toward the contacted/impacted body:
## `subject` is the body entered by the observed dynamic body, while `other` is
## the dynamic body that produced the callback. This keeps body consequence
## policies independent from which RigidBody3D happened to report the contact.

var _registry
var _observation_buffer
var _callbacks_by_body_id: Dictionary = {}

func _init(registry, observation_buffer) -> void:
	assert(registry != null, "GodotDynamicContactObserver requires GodotSceneSpatialRegistry")
	assert(observation_buffer != null, "GodotDynamicContactObserver requires PhysicalObservationPort")
	_registry = registry
	_observation_buffer = observation_buffer

func bind_body(body: RigidBody3D) -> bool:
	if body == null:
		return false
	if _registry.runtime_ref_for_node(body) == null:
		return false
	var body_id := body.get_instance_id()
	if _callbacks_by_body_id.has(body_id):
		return true
	body.contact_monitor = true
	body.max_contacts_reported = maxi(body.max_contacts_reported, 1)
	var callback := Callable(self, "_on_body_entered").bind(body)
	body.body_entered.connect(callback)
	_callbacks_by_body_id[body_id] = callback
	return true

func unbind_body(body: RigidBody3D) -> bool:
	if body == null:
		return false
	var body_id := body.get_instance_id()
	var callback = _callbacks_by_body_id.get(body_id)
	if callback == null:
		return false
	if body.body_entered.is_connected(callback):
		body.body_entered.disconnect(callback)
	_callbacks_by_body_id.erase(body_id)
	return true

func observe_contact(dynamic_body: Node3D, impacted_body: Node3D) -> bool:
	if dynamic_body == null or impacted_body == null:
		return false
	var dynamic_ref = _registry.runtime_ref_for_node(dynamic_body)
	var impacted_ref = _registry.runtime_ref_for_node(impacted_body)
	if dynamic_ref == null or impacted_ref == null:
		return false
	var observation = PhysicalObservation.new(
		PhysicalObservation.Kind.CONTACT,
		impacted_ref,
		dynamic_ref,
		_relative_speed(dynamic_body, impacted_body),
		_midpoint(dynamic_body, impacted_body),
		Vector3.ZERO
	)
	return _observation_buffer.enqueue(observation)

func _on_body_entered(other_body: Node, dynamic_body: RigidBody3D) -> void:
	if other_body is Node3D:
		observe_contact(dynamic_body, other_body as Node3D)

func _relative_speed(a: Node3D, b: Node3D) -> float:
	return (_linear_velocity(a) - _linear_velocity(b)).length()

func _linear_velocity(node: Node3D) -> Vector3:
	if node is RigidBody3D:
		return (node as RigidBody3D).linear_velocity
	if node is CharacterBody3D:
		return (node as CharacterBody3D).velocity
	return Vector3.ZERO

func _midpoint(a: Node3D, b: Node3D) -> Vector3:
	var a_position := a.global_position if a.is_inside_tree() else a.position
	var b_position := b.global_position if b.is_inside_tree() else b.position
	return (a_position + b_position) * 0.5
