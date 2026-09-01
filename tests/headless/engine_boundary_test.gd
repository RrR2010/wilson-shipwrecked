extends SceneTree

const SimulationCadenceClock = preload("res://src/application/simulation/simulation_cadence_clock.gd")
const MotionPort = preload("res://src/application/simulation/motion_port.gd")
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
	_test_motion_reports_semantic_progress_without_engine_frames()
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
	var spatial := FakeSpatialQueryPort.new()
	spatial.set_distance(&"wilson", &"coconut_17", 13.8)
	spatial.set_route(&"wilson", &"coconut_17", true, 15.2)
	spatial.set_line_of_sight(&"wilson", &"coconut_17", false)
	spatial.set_interaction_reachable(&"wilson", &"coconut_17", &"pickup", true)

	_expect_true(is_equal_approx(spatial.metric_distance(&"wilson", &"coconut_17"), 13.8), "configured metric distance is stable")
	_expect_true(spatial.has_route(&"wilson", &"coconut_17"), "configured route is available")
	_expect_true(is_equal_approx(spatial.route_cost(&"wilson", &"coconut_17"), 15.2), "configured route cost is stable")
	_expect_true(not spatial.has_line_of_sight(&"wilson", &"coconut_17"), "visibility is independent from route availability")
	_expect_true(spatial.is_interaction_reachable(&"wilson", &"coconut_17", &"pickup"), "interaction reachability is explicit")
	_expect_true(not spatial.has_route(&"wilson", &"unknown"), "unmapped route fails closed")
	_expect_true(is_inf(spatial.metric_distance(&"wilson", &"unknown")), "unmapped distance has explicit unavailable result")

func _test_motion_reports_semantic_progress_without_engine_frames() -> void:
	var motion := FakeMotionPort.new()
	_expect_true(motion.request_move(&"wilson", &"coconut_17"), "semantic move request is accepted")
	_expect_equal(motion.get_target(&"wilson"), &"coconut_17", "motion keeps semantic target identity")
	_expect_equal(motion.get_status(&"wilson"), MotionPort.MotionStatus.MOVING, "motion begins in moving state")
	motion.set_status(&"wilson", MotionPort.MotionStatus.ARRIVED)
	_expect_equal(motion.get_status(&"wilson"), MotionPort.MotionStatus.ARRIVED, "engine progression can report semantic arrival")

func _expect_true(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)

func _expect_equal(actual: Variant, expected: Variant, message: String) -> void:
	if actual != expected:
		_failures.append("%s (expected=%s actual=%s)" % [message, expected, actual])
