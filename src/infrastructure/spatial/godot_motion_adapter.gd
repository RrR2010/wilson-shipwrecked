class_name GodotMotionAdapter
extends "res://src/application/simulation/motion_port.gd"

## CharacterBody3D/NavigationAgent3D implementation of the semantic MotionPort.
##
## Fine transform, steering and path progression remain engine-owned. The domain sees
## only semantic request/status state keyed by RuntimeWorldRef.

var _registry
var _body_by_key: Dictionary = {}
var _agent_by_key: Dictionary = {}
var _speed_by_key: Dictionary = {}
var _target_by_key: Dictionary = {}
var _status_by_key: Dictionary = {}


func _init(registry) -> void:
	assert(registry != null, "GodotMotionAdapter requires spatial registry")
	_registry = registry


func bind_actor(actor_ref, body: CharacterBody3D, navigation_agent: NavigationAgent3D, speed_mps: float = 3.0) -> bool:
	if actor_ref == null or body == null or navigation_agent == null:
		return false
	if not is_finite(speed_mps) or speed_mps <= 0.0:
		return false
	var key: String = String(actor_ref.key())
	if _body_by_key.has(key):
		return _body_by_key[key] == body and _agent_by_key[key] == navigation_agent
	_body_by_key[key] = body
	_agent_by_key[key] = navigation_agent
	_speed_by_key[key] = speed_mps
	_status_by_key[key] = MotionStatus.IDLE
	return true


func unbind_actor(actor_ref) -> void:
	if actor_ref == null:
		return
	var key: String = String(actor_ref.key())
	_body_by_key.erase(key)
	_agent_by_key.erase(key)
	_speed_by_key.erase(key)
	_target_by_key.erase(key)
	_status_by_key.erase(key)


func request_move(actor_ref, target_ref) -> bool:
	if actor_ref == null or target_ref == null:
		return false
	var key: String = String(actor_ref.key())
	var body: CharacterBody3D = _resolve_body(key)
	var agent: NavigationAgent3D = _resolve_agent(key)
	var target_node: Node3D = _registry.resolve(target_ref)
	if body == null or agent == null or target_node == null:
		_status_by_key[key] = MotionStatus.ROUTE_INVALID
		return false
	if not body.is_inside_tree() or not agent.is_inside_tree():
		_status_by_key[key] = MotionStatus.ROUTE_INVALID
		return false
	var navigation_map: RID = agent.get_navigation_map()
	if not navigation_map.is_valid():
		_status_by_key[key] = MotionStatus.ROUTE_INVALID
		return false
	agent.target_position = target_node.global_position
	_target_by_key[key] = target_ref
	_status_by_key[key] = MotionStatus.MOVING
	return true


func cancel_move(actor_ref) -> void:
	if actor_ref == null:
		return
	var key: String = String(actor_ref.key())
	var body: CharacterBody3D = _resolve_body(key)
	if body != null:
		body.velocity.x = 0.0
		body.velocity.z = 0.0
	_target_by_key.erase(key)
	_status_by_key[key] = MotionStatus.CANCELLED


func get_status(actor_ref) -> int:
	if actor_ref == null:
		return MotionStatus.IDLE
	return int(_status_by_key.get(String(actor_ref.key()), MotionStatus.IDLE))


func get_target(actor_ref):
	if actor_ref == null:
		return null
	return _target_by_key.get(String(actor_ref.key()))


func physics_tick(_delta_seconds: float) -> void:
	var keys: Array = _status_by_key.keys()
	keys.sort_custom(func(a, b): return String(a) < String(b))
	for raw_key in keys:
		var key: String = String(raw_key)
		if int(_status_by_key.get(key, MotionStatus.IDLE)) != MotionStatus.MOVING:
			continue
		var body: CharacterBody3D = _resolve_body(key)
		var agent: NavigationAgent3D = _resolve_agent(key)
		if body == null or agent == null or not body.is_inside_tree() or not agent.is_inside_tree():
			_status_by_key[key] = MotionStatus.ROUTE_INVALID
			continue
		if agent.is_navigation_finished():
			body.velocity.x = 0.0
			body.velocity.z = 0.0
			_status_by_key[key] = MotionStatus.ARRIVED
			continue
		var next_position: Vector3 = agent.get_next_path_position()
		var direction: Vector3 = next_position - body.global_position
		direction.y = 0.0
		if direction.length_squared() <= 1.0e-8:
			body.velocity.x = 0.0
			body.velocity.z = 0.0
			continue
		direction = direction.normalized()
		var speed: float = float(_speed_by_key.get(key, 3.0))
		body.velocity.x = direction.x * speed
		body.velocity.z = direction.z * speed
		body.move_and_slide()


func _resolve_body(key: String) -> CharacterBody3D:
	var body = _body_by_key.get(key)
	if body == null or not is_instance_valid(body):
		_body_by_key.erase(key)
		return null
	return body as CharacterBody3D


func _resolve_agent(key: String) -> NavigationAgent3D:
	var agent = _agent_by_key.get(key)
	if agent == null or not is_instance_valid(agent):
		_agent_by_key.erase(key)
		return null
	return agent as NavigationAgent3D
