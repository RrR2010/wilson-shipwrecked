extends SceneTree

const EnvironmentState = preload("res://src/domain/world/environment_state.gd")
const WeatherDefinition = preload("res://src/domain/world/weather_definition.gd")
const WeatherTransitionDefinition = preload("res://src/domain/world/weather_transition_definition.gd")
const WeatherProgressionService = preload("res://src/domain/world/weather_progression_service.gd")

var _failures: Array[String] = []
var _completed := false


func _init() -> void:
	_run_slice()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS weather_progression_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL weather_progression_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_slice() -> void:
	var definitions := [
		WeatherDefinition.new(&"clear", 2.0, 4.0, {&"rain_intensity": 0.0, &"wind_intensity": 0.15}),
		WeatherDefinition.new(&"rain", 1.0, 2.0, {&"rain_intensity": 0.7, &"wind_intensity": 0.35}),
		WeatherDefinition.new(&"storm", 1.0, 1.5, {&"rain_intensity": 1.0, &"wind_intensity": 0.9}),
	]
	var transitions := [
		WeatherTransitionDefinition.new(&"clear", &"rain", 3.0),
		WeatherTransitionDefinition.new(&"clear", &"storm", 1.0),
		WeatherTransitionDefinition.new(&"rain", &"clear", 2.0),
		WeatherTransitionDefinition.new(&"rain", &"storm", 1.0),
		WeatherTransitionDefinition.new(&"storm", &"rain", 2.0),
		WeatherTransitionDefinition.new(&"storm", &"clear", 1.0),
	]

	var first_state = EnvironmentState.new(&"clear", &"day")
	var second_state = EnvironmentState.new(&"clear", &"day")
	var first = WeatherProgressionService.new(first_state, definitions, transitions, 424242)
	var second = WeatherProgressionService.new(second_state, definitions, transitions, 424242)
	_expect_true(first_state.weather_planned_duration >= 2.0 and first_state.weather_planned_duration <= 4.0, "initial duration comes from current weather definition")
	_expect_true(is_equal_approx(first_state.weather_planned_duration, second_state.weather_planned_duration), "same seed produces same initial duration")
	_expect_true(is_equal_approx(first.condition(&"rain_intensity"), 0.0), "conditions derive from current authored regime")

	var first_result = first.advance(first_state.weather_planned_duration)
	var second_result = second.advance(second_state.weather_planned_duration)
	_expect_equal(first_result.transitions.size(), 1, "crossing planned duration causes exactly one weather transition")
	_expect_equal(second_result.transitions.size(), 1, "matching deterministic run also transitions once")
	_expect_equal(first_state.weather, second_state.weather, "same seed and graph produce same next weather")
	_expect_equal(first_state.weather_transition_index, 1, "transition index advances with procedural weather history")
	_expect_true(first.condition(&"rain_intensity") > 0.0, "new weather exposes its composed environmental conditions")

	var restored = EnvironmentState.new(
		first_state.weather,
		first_state.daylight_phase,
		first_state.weather_elapsed,
		first_state.weather_planned_duration,
		first_state.weather_transition_index
	)
	var restored_service = WeatherProgressionService.new(restored, definitions, transitions, 424242)
	var delta := first_state.weather_planned_duration * 0.5
	first.advance(delta)
	restored_service.advance(delta)
	_expect_equal(restored.weather, first_state.weather, "restored progression retains current weather")
	_expect_true(is_equal_approx(restored.weather_elapsed, first_state.weather_elapsed), "restored progression retains elapsed phase")
	_expect_true(is_equal_approx(restored.weather_planned_duration, first_state.weather_planned_duration), "restored progression retains deterministic planned duration")
	_expect_equal(restored.weather_transition_index, first_state.weather_transition_index, "restored progression retains procedural transition index")

	var overshoot_state = EnvironmentState.new(&"clear", &"day")
	var overshoot = WeatherProgressionService.new(overshoot_state, definitions, transitions, 7)
	var initial_duration := overshoot_state.weather_planned_duration
	var overshoot_result = overshoot.advance(initial_duration + 0.25)
	_expect_equal(overshoot_result.transitions.size(), 1, "overshoot preserves leftover elapsed into next regime")
	_expect_true(is_equal_approx(overshoot_state.weather_elapsed, 0.25), "transition conserves elapsed time")

	_completed = true


func _expect_true(actual: bool, label: String) -> void:
	if not actual:
		_failures.append("Expected true: %s" % label)


func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
