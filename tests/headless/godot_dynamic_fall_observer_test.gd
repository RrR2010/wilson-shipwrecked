extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const PhysicalObservation = preload("res://src/application/simulation/physical_observation.gd")
const GodotSceneSpatialRegistry = preload("res://src/infrastructure/spatial/godot_scene_spatial_registry.gd")
const GodotPhysicalObservationBuffer = preload("res://src/infrastructure/spatial/godot_physical_observation_buffer.gd")
const GodotDynamicFallObserver = preload("res://src/infrastructure/spatial/godot_dynamic_fall_observer.gd")

var _failures: Array[String] = []


func _init() -> void:
	_run()
	if _failures.is_empty():
		print("PASS godot_dynamic_fall_observer_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL godot_dynamic_fall_observer_test: %d failure(s)" % _failures.size())
	quit(1)


func _run() -> void:
	var registry = GodotSceneSpatialRegistry.new()
	var buffer = GodotPhysicalObservationBuffer.new()
	var observer = GodotDynamicFallObserver.new(registry, buffer, 1.0)
	var palm = RigidBody3D.new()
	palm.position = Vector3(2.0, 5.0, -1.0)
	var palm_ref = RuntimeWorldRef.entity(DomainId.entity(&"fall_observer_palm"))

	_expect_true(registry.bind(palm_ref, palm), "registered rigid body receives semantic identity")
	palm.linear_velocity = Vector3(0.0, -0.5, 0.0)
	_expect_false(observer.sample_body(palm), "sub-threshold downward motion does not emit FALL")
	_expect_equal(buffer.pending_count(), 0, "sub-threshold sample leaves buffer empty")

	palm.linear_velocity = Vector3(0.0, -3.0, 0.0)
	_expect_true(observer.sample_body(palm), "threshold crossing emits FALL")
	_expect_equal(buffer.pending_count(), 1, "fall edge enqueues exactly one observation")
	var first = buffer.drain_observations()
	_expect_equal(first.size(), 1, "fall batch contains one observation")
	if first.size() == 1:
		var observation = first[0]
		_expect_equal(observation.kind, PhysicalObservation.Kind.FALL, "observation kind is FALL")
		_expect_true(observation.subject.equals(palm_ref), "fall subject uses explicit semantic binding")
		_expect_true(observation.other == null, "fall observation has no fabricated other subject")
		_expect_true(is_equal_approx(observation.magnitude, 3.0), "fall magnitude records downward speed")
		_expect_true(observation.point.is_equal_approx(palm.position), "fall point records body position")
		_expect_true(observation.normal.is_equal_approx(Vector3.DOWN), "fall direction is downward")

	palm.linear_velocity = Vector3(0.0, -5.0, 0.0)
	_expect_false(observer.sample_body(palm), "continued fall is edge-triggered rather than emitted every sample")
	_expect_equal(buffer.pending_count(), 0, "continued fall does not spam the observation buffer")

	palm.linear_velocity = Vector3.ZERO
	_expect_false(observer.sample_body(palm), "stopped body rearms the fall edge")
	palm.linear_velocity = Vector3(0.0, -2.0, 0.0)
	_expect_true(observer.sample_body(palm), "a later distinct fall emits a new observation")
	_expect_equal(buffer.pending_count(), 1, "rearmed body emits one later FALL")

	var unregistered = RigidBody3D.new()
	unregistered.linear_velocity = Vector3(0.0, -4.0, 0.0)
	_expect_false(observer.sample_body(unregistered), "unregistered engine node cannot invent semantic identity")

	palm.free()
	unregistered.free()


func _expect_true(actual: bool, label: String) -> void:
	if not actual:
		_failures.append("Expected true: %s" % label)


func _expect_false(actual: bool, label: String) -> void:
	if actual:
		_failures.append("Expected false: %s" % label)


func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
