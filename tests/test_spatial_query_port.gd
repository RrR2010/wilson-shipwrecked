extends RefCounted

func run() -> void:
	_test_fake_is_explicit_and_deterministic()

func _test_fake_is_explicit_and_deterministic() -> void:
	var spatial := FakeSpatialQueryPort.new()
	spatial.set_distance(&"wilson", &"coconut_17", 13.8)
	spatial.set_route(&"wilson", &"coconut_17", true, 15.2)
	spatial.set_line_of_sight(&"wilson", &"coconut_17", false)
	spatial.set_interaction_reachable(&"wilson", &"coconut_17", &"pickup", true)

	assert(is_equal_approx(spatial.metric_distance(&"wilson", &"coconut_17"), 13.8))
	assert(spatial.has_route(&"wilson", &"coconut_17"))
	assert(is_equal_approx(spatial.route_cost(&"wilson", &"coconut_17"), 15.2))
	assert(not spatial.has_line_of_sight(&"wilson", &"coconut_17"))
	assert(spatial.is_interaction_reachable(&"wilson", &"coconut_17", &"pickup"))

	assert(not spatial.has_route(&"wilson", &"unknown"))
	assert(is_inf(spatial.metric_distance(&"wilson", &"unknown")))
