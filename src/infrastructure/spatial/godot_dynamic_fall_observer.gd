class_name GodotDynamicFallObserver
extends RefCounted

const PhysicalObservation = preload("res://src/application/simulation/physical_observation.gd")

## Samples explicitly registered RigidBody3D motion and emits an edge-triggered
## PhysicalObservation.FALL when downward speed crosses a coarse physical threshold.
##
## This adapter reports engine-observed motion only. It does not decide whether the
## fall is dangerous, observable by Wilson, or worthy of reconsideration.

var _registry
var _observation_buffer
var _minimum_downward_speed: float
var _falling_by_body_id: Dictionary = {}


func _init(registry, observation_buffer, minimum_downward_speed: float = 0.5) -> void:
	assert(registry != null, "GodotDynamicFallObserver requires GodotSceneSpatialRegistry")
	assert(observation_buffer != null, "GodotDynamicFallObserver requires PhysicalObservationPort")
	assert(is_finite(minimum_downward_speed) and minimum_downward_speed > 0.0, "Fall observation threshold must be finite and positive")
	_registry = registry
	_observation_buffer = observation_buffer
	_minimum_downward_speed = minimum_downward_speed


func sample_body(body: RigidBody3D) -> bool:
	if body == null:
		return false
	var runtime_ref = _registry.runtime_ref_for_node(body)
	if runtime_ref == null:
		return false

	var body_id: int = body.get_instance_id()
	var downward_speed: float = maxf(0.0, -body.linear_velocity.y)
	var is_falling := downward_speed >= _minimum_downward_speed
	var was_falling: bool = bool(_falling_by_body_id.get(body_id, false))

	if not is_falling:
		_falling_by_body_id[body_id] = false
		return false
	if was_falling:
		return false

	_falling_by_body_id[body_id] = true
	var point := body.global_position if body.is_inside_tree() else body.position
	return _observation_buffer.enqueue(PhysicalObservation.new(
		PhysicalObservation.Kind.FALL,
		runtime_ref,
		null,
		downward_speed,
		point,
		Vector3.DOWN
	))


func forget_body(body: RigidBody3D) -> void:
	if body != null:
		_falling_by_body_id.erase(body.get_instance_id())


func clear() -> void:
	_falling_by_body_id.clear()
