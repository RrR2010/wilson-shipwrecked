extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const PhysicalObservation = preload("res://src/application/simulation/physical_observation.gd")
const GodotSceneSpatialRegistry = preload("res://src/infrastructure/spatial/godot_scene_spatial_registry.gd")
const GodotPhysicalObservationBuffer = preload("res://src/infrastructure/spatial/godot_physical_observation_buffer.gd")
const GodotDynamicContactObserver = preload("res://src/infrastructure/spatial/godot_dynamic_contact_observer.gd")

var _failures: Array[String] = []

func _init() -> void:
	if not GodotSceneSpatialRegistry.can_instantiate():
		_failures.append("GodotSceneSpatialRegistry must compile and instantiate")
	if not GodotPhysicalObservationBuffer.can_instantiate():
		_failures.append("GodotPhysicalObservationBuffer must compile and instantiate")
	if not GodotDynamicContactObserver.can_instantiate():
		_failures.append("GodotDynamicContactObserver must compile and instantiate")
	if _failures.is_empty():
		_run_test()
	if _failures.is_empty():
		print("PASS godot_dynamic_contact_observer_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL godot_dynamic_contact_observer_test: %d failure(s)" % _failures.size())
	quit(1)

func _run_test() -> void:
	var registry = GodotSceneSpatialRegistry.new()
	var buffer = GodotPhysicalObservationBuffer.new()
	var observer = GodotDynamicContactObserver.new(registry, buffer)

	var palm_ref = RuntimeWorldRef.entity(DomainId.entity(&"palm_17"))
	var wilson_ref = RuntimeWorldRef.wilson()
	var palm = RigidBody3D.new()
	var wilson = CharacterBody3D.new()
	palm.position = Vector3(2.0, 1.0, 0.0)
	wilson.position = Vector3.ZERO
	palm.linear_velocity = Vector3(-6.0, 0.0, 0.0)
	wilson.velocity = Vector3(1.0, 0.0, 0.0)

	_expect_true(registry.bind(palm_ref, palm), "palm binding succeeds")
	_expect_true(registry.bind(wilson_ref, wilson), "Wilson binding succeeds")
	_expect_true(registry.runtime_ref_for_node(palm).equals(palm_ref), "reverse lookup preserves palm semantic identity")
	_expect_true(registry.runtime_ref_for_node(wilson).equals(wilson_ref), "reverse lookup preserves Wilson semantic identity")

	_expect_true(observer.bind_body(palm), "bound RigidBody3D can produce contact observations")
	_expect_true(palm.contact_monitor, "observer enables contact monitoring")
	_expect_true(palm.max_contacts_reported >= 1, "observer requests at least one reported contact")

	_expect_true(observer.observe_contact(palm, wilson), "explicit contact callback enqueues observation")
	_expect_equal(buffer.pending_count(), 1, "one contact observation is buffered")
	var observations = buffer.drain_observations()
	_expect_equal(observations.size(), 1, "contact buffer drains one observation")
	if observations.size() == 1:
		var observation = observations[0]
		_expect_equal(observation.kind, PhysicalObservation.Kind.CONTACT, "contact callback keeps physical observation kind")
		_expect_true(observation.subject.equals(palm_ref), "contact subject uses semantic palm ref")
		_expect_true(observation.other.equals(wilson_ref), "contact other uses semantic Wilson ref")
		_expect_true(is_equal_approx(observation.magnitude, 7.0), "contact magnitude is observed relative speed")
		_expect_true(observation.point.distance_to(Vector3(1.0, 0.5, 0.0)) < 0.001, "contact point is a coarse engine observation")

	var unbound = RigidBody3D.new()
	_expect_true(not observer.bind_body(unbound), "unbound body cannot silently acquire semantic identity")
	_expect_true(not observer.observe_contact(unbound, wilson), "unbound contact is rejected")
	_expect_equal(buffer.pending_count(), 0, "rejected contact produces no observation")

	_expect_true(observer.unbind_body(palm), "observer disconnects bound body")
	_expect_true(registry.unbind(palm_ref, palm), "registry unbind succeeds")
	_expect_true(registry.runtime_ref_for_node(palm) == null, "reverse lookup clears with binding")

	palm.free()
	wilson.free()
	unbound.free()

func _expect_true(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)

func _expect_equal(actual: Variant, expected: Variant, message: String) -> void:
	if actual != expected:
		_failures.append("%s (expected=%s actual=%s)" % [message, expected, actual])
