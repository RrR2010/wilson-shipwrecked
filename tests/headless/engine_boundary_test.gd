extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const SimulationCadenceClock = preload("res://src/application/simulation/simulation_cadence_clock.gd")
const MotionPort = preload("res://src/application/simulation/motion_port.gd")
const PhysicalObservation = preload("res://src/application/simulation/physical_observation.gd")
const GodotSceneSpatialRegistry = preload("res://src/infrastructure/spatial/godot_scene_spatial_registry.gd")
const GodotSpatialQueryAdapter = preload("res://src/infrastructure/spatial/godot_spatial_query_adapter.gd")
const GodotPhysicalObservationBuffer = preload("res://src/infrastructure/spatial/godot_physical_observation_buffer.gd")
const FakeMotionPort = preload("res://tests/fakes/fake_motion_port.gd")
const FakeSpatialQueryPort = preload("res://tests/fakes/fake_spatial_query_port.gd")

var _failures: Array[String] = []
var _completed := false

func _init() -> void:
	_run_slice()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS engine_boundary_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL engine_boundary_test: %d failure(s)" % _failures.size())
	quit(1)

func _run_slice() -> void:
	_test_fixed_simulation_cadence_is_frame_partition_independent()
	_test_spatial_queries_are_explicit_and_deterministic()
	_test_godot_scene_mapping_is_explicit_and_headless_safe()
	_test_motion_reports_semantic_progress_without_engine_frames()
	_test_physical_observation_is_typed_non_authoritative_input()
	_test_physical_observations_drain_in_engine_order()
	_completed = true

func _test_fixed_simulation_cadence_is_frame_partition_independent() -> void:
	var sixty_hz := SimulationCadenceClock.new(0.1)
	var thirty_hz := SimulationCadenceClock.new(0.1)
	var sixty_steps := 0
	var thirty_steps := 0
	for _i in range(60):
		sixty_steps += sixty_hz.advance(1.0 / 60.0)
	for _i in range(30):
		thirty_steps += thirty_hz.advance(1.0 / 30.0)
	_expect_equal(sixty_steps, 10, "60 Hz partition emits ten semantic steps per second")
	_expect_equal(thirty_steps, 10, "30 Hz partition emits ten semantic steps per second")
	_expect_true(absf(sixty_hz.remaining_seconds() - thirty_hz.remaining_seconds()) < 1.0e-6, "equal elapsed time leaves equal remainder")
	var coarse := SimulationCadenceClock.new(0.1)
	_expect_equal(coarse.advance(0.35), 3, "large delta emits every due fixed step")
	_expect_true(absf(coarse.remaining_seconds() - 0.05) < 1.0e-6, "large delta preserves deterministic remainder")

func _test_spatial_queries_are_explicit_and_deterministic() -> void:
	var wilson_ref := RuntimeWorldRef.wilson()
	var coconut_ref := RuntimeWorldRef.entity(DomainId.entity(&"coconut_17"))
	var unknown_ref := RuntimeWorldRef.entity(DomainId.entity(&"unknown"))
	var spatial := FakeSpatialQueryPort.new()
	spatial.set_distance(wilson_ref, coconut_ref, 13.8)
	spatial.set_route(wilson_ref, coconut_ref, true, 15.2)
	spatial.set_line_of_sight(wilson_ref, coconut_ref, false)
	spatial.set_interaction_reachable(wilson_ref, coconut_ref, &"pickup", true)
	_expect_true(is_equal_approx(spatial.metric_distance(wilson_ref, coconut_ref), 13.8), "configured metric distance is stable")
	_expect_true(spatial.has_route(wilson_ref, coconut_ref), "configured route is available")
	_expect_true(is_equal_approx(spatial.route_cost(wilson_ref, coconut_ref), 15.2), "configured route cost is stable")
	_expect_true(not spatial.has_line_of_sight(wilson_ref, coconut_ref), "visibility is independent from route availability")
	_expect_true(spatial.is_interaction_reachable(wilson_ref, coconut_ref, &"pickup"), "interaction reachability is explicit")
	_expect_true(not spatial.has_route(wilson_ref, unknown_ref), "unmapped route fails closed")
	_expect_true(is_inf(spatial.metric_distance(wilson_ref, unknown_ref)), "unmapped distance has explicit unavailable result")

func _test_godot_scene_mapping_is_explicit_and_headless_safe() -> void:
	var wilson_ref := RuntimeWorldRef.wilson()
	var coconut_ref := RuntimeWorldRef.entity(DomainId.entity(&"coconut_17"))
	var unknown_ref := RuntimeWorldRef.entity(DomainId.entity(&"unknown"))
	var registry := GodotSceneSpatialRegistry.new()
	var wilson := Node3D.new()
	var coconut := Node3D.new()
	var pickup_anchor := Node3D.new()
	root.add_child(wilson)
	root.add_child(coconut)
	coconut.add_child(pickup_anchor)
	wilson.global_position = Vector3.ZERO
	coconut.global_position = Vector3(3.0, 0.0, 4.0)
	pickup_anchor.global_position = Vector3(1.0, 0.0, 0.0)
	_expect_true(registry.bind(wilson_ref, wilson), "semantic Wilson ref binds explicitly")
	_expect_true(registry.bind(coconut_ref, coconut), "semantic target ref binds explicitly")
	_expect_true(registry.bind_anchor(coconut_ref, &"pickup", pickup_anchor), "typed interaction anchor binds explicitly")
	_expect_true(not registry.bind(wilson_ref, coconut), "duplicate semantic ref cannot silently remap")
	var spatial := GodotSpatialQueryAdapter.new(registry)
	_expect_true(is_equal_approx(spatial.metric_distance(wilson_ref, coconut_ref), 5.0), "Godot adapter reports metric Node3D distance")
	_expect_true(is_inf(spatial.metric_distance(wilson_ref, unknown_ref)), "unmapped Godot ref fails explicitly")
	_expect_true(spatial.is_interaction_reachable(wilson_ref, coconut_ref, &"pickup"), "interaction reachability uses semantic anchor rather than node name")
	_expect_true(not spatial.has_route(wilson_ref, coconut_ref), "route query fails closed without configured navigation map")
	_expect_true(not spatial.has_line_of_sight(wilson_ref, coconut_ref), "visibility query fails closed without physics space state")
	wilson.queue_free()
	coconut.queue_free()

func _test_motion_reports_semantic_progress_without_engine_frames() -> void:
	var wilson_ref := RuntimeWorldRef.wilson()
	var coconut_ref := RuntimeWorldRef.entity(DomainId.entity(&"coconut_17"))
	var motion := FakeMotionPort.new()
	_expect_true(motion.request_move(wilson_ref, coconut_ref), "semantic move request is accepted")
	_expect_true(motion.get_target(wilson_ref).equals(coconut_ref), "motion keeps semantic target identity")
	_expect_equal(motion.get_status(wilson_ref), MotionPort.MotionStatus.MOVING, "motion begins in moving state")
	motion.set_status(wilson_ref, MotionPort.MotionStatus.ARRIVED)
	_expect_equal(motion.get_status(wilson_ref), MotionPort.MotionStatus.ARRIVED, "engine progression can report semantic arrival")

func _test_physical_observation_is_typed_non_authoritative_input() -> void:
	var wilson_ref := RuntimeWorldRef.wilson()
	var rock_ref := RuntimeWorldRef.entity(DomainId.entity(&"falling_rock"))
	var observation := PhysicalObservation.new(
		PhysicalObservation.Kind.CONTACT,
		wilson_ref,
		rock_ref,
		4.5,
		Vector3(1.0, 0.5, 2.0),
		Vector3.UP
	)
	_expect_equal(observation.kind, PhysicalObservation.Kind.CONTACT, "physical fact has typed observation kind")
	_expect_true(observation.subject.equals(wilson_ref), "physical fact preserves typed subject identity")
	_expect_true(observation.other.equals(rock_ref), "physical fact preserves typed counterpart identity")
	_expect_true(is_equal_approx(observation.magnitude, 4.5), "physical fact carries finite magnitude without implying consequence")

func _test_physical_observations_drain_in_engine_order() -> void:
	var wilson_ref := RuntimeWorldRef.wilson()
	var rock_ref := RuntimeWorldRef.entity(DomainId.entity(&"falling_rock"))
	var buffer := GodotPhysicalObservationBuffer.new()
	var first := PhysicalObservation.new(PhysicalObservation.Kind.OVERLAP_ENTERED, wilson_ref, rock_ref)
	var second := PhysicalObservation.new(PhysicalObservation.Kind.CONTACT, wilson_ref, rock_ref, 2.0)
	_expect_true(buffer.enqueue(first), "first engine observation enqueues")
	_expect_true(buffer.enqueue(second), "second engine observation enqueues")
	_expect_equal(buffer.pending_count(), 2, "physics observations accumulate between semantic steps")
	var drained := buffer.drain_observations()
	_expect_equal(drained.size(), 2, "semantic step drains complete pending batch")
	_expect_true(drained[0] == first and drained[1] == second, "physical observation order is preserved")
	_expect_equal(buffer.pending_count(), 0, "drain consumes observations exactly once")

func _expect_true(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)

func _expect_equal(actual: Variant, expected: Variant, message: String) -> void:
	if actual != expected:
		_failures.append("%s (expected=%s actual=%s)" % [message, expected, actual])
