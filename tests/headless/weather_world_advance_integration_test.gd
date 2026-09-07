extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const EnvironmentState = preload("res://src/domain/world/environment_state.gd")
const WeatherDefinition = preload("res://src/domain/world/weather_definition.gd")
const WeatherTransitionDefinition = preload("res://src/domain/world/weather_transition_definition.gd")
const WeatherProgressionService = preload("res://src/domain/world/weather_progression_service.gd")
const SemanticChangeSet = preload("res://src/domain/world/semantic_change_set.gd")
const EnvironmentWorldAdvanceService = preload("res://src/application/simulation/environment_world_advance_service.gd")
const WeatherTransitionEventProjector = preload("res://src/application/simulation/weather_transition_event_projector.gd")
const SimulationStepContext = preload("res://src/application/simulation/simulation_step_context.gd")

var _failures: Array[String] = []
var _completed := false


class DynamicProcessAdvanceStub:
	extends RefCounted

	func advance(_elapsed: float) -> Dictionary:
		return {
			"change_set": SemanticChangeSet.new(),
			"progressed": [],
			"completed": [],
			"diagnostics": [],
			"transitions": [],
		}


func _init() -> void:
	_run_slice()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS weather_world_advance_integration_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL weather_world_advance_integration_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_slice() -> void:
	var environment = EnvironmentState.new(&"clear", &"day")
	var weather_changed = DomainId.event_definition(&"weather_changed")
	var weather = WeatherProgressionService.new(
		environment,
		[
			WeatherDefinition.new(&"clear", 1.0, 1.0, {&"rain_intensity": 0.0}),
			WeatherDefinition.new(&"rain", 2.0, 2.0, {&"rain_intensity": 0.8}),
		],
		[
			WeatherTransitionDefinition.new(&"clear", &"rain", 1.0, weather_changed),
			WeatherTransitionDefinition.new(&"rain", &"clear", 1.0, weather_changed),
		],
		99
	)
	var world_advance = EnvironmentWorldAdvanceService.new(
		DynamicProcessAdvanceStub.new(),
		null,
		null,
		null,
		null,
		weather,
		WeatherTransitionEventProjector.new()
	)

	var quiet = world_advance.advance(0.5, SimulationStepContext.new(&"weather_quiet", 0.5, 0.5, null, []))
	_expect_equal(environment.weather, &"clear", "weather remains in current regime before planned boundary")
	_expect_equal(quiet.events.size(), 0, "ordinary weather progression emits no event before transition")

	var transition = world_advance.advance(0.5, SimulationStepContext.new(&"weather_transition", 0.5, 1.0, null, []))
	_expect_equal(environment.weather, &"rain", "weather transition mutates authoritative EnvironmentState")
	_expect_true(is_equal_approx(weather.condition(&"rain_intensity"), 0.8), "new composed conditions are immediately available")
	_expect_equal(transition.events.size(), 1, "weather boundary emits one semantic WorldEvent")
	if transition.events.size() == 1:
		_expect_equal(transition.events[0].event_type.key(), weather_changed.key(), "weather event uses authored ambient event type")
		_expect_true(transition.events[0].bindings.role_names().is_empty(), "ambient weather event needs no synthetic entity role")

	_completed = true


func _expect_true(actual: bool, label: String) -> void:
	if not actual:
		_failures.append("Expected true: %s" % label)


func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
