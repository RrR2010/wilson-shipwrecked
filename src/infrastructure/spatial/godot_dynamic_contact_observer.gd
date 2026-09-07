class_name GodotDynamicContactObserver
extends RefCounted

const PhysicalObservation = preload("res://src/application/simulation/physical_observation.gd")

## Converts Godot body-entered callbacks into non-authoritative PhysicalObservation
## facts. Semantic identity comes only from GodotSceneSpatialRegistry bindings.
## This adapter never decides whether contact is harmful and never mutates World.

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

func observe_contact(subject_body: Node3D, other_body: Node3D) -> bool:
	if subject_body == null or other_body == null:
		return false
	var subject_ref = _registry.runtime_ref_for_node(subject_body)
	var other_ref = _registry.runtime_ref_for_node(other_body)
	if subject_ref == null or other_ref == null:
		return false
	var observation = PhysicalObservation.new(
		PhysicalObservation.Kind.CONTACT,
		subject_ref,
		other_ref,
		_relative_speed(subject_body, other_body),
		_midpoint(subject_body, other_body),
		Vector3.ZERO
	)
	return _observation_buffer.enqueue(observation)

func _on_body_entered(other_body: Node, subject_body: RigidBody3D) -> void:
	if other_body is Node3D:
		observe_contact(subject_body, other_body as Node3D)

func _relative_speed(a: Node3D, b: Node3D) -> float:
	return (_linear_velocity(a) - _linear_velocity(b)).length()

func _linear_velocity(node: Node3D) -> Vector3:
	if node is RigidBody3D:
		return (node as RigidBody3D).linear_velocity
	if node is CharacterBody3D:
		return (node as CharacterBody3D).velocity
	return Vector3.ZERO

func _midpoint(a: Node3D, b: Node3D) -> Vector3:
	return (a.global_position + b.global_position) * 0.5
