extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const ContentRegistry = preload("res://src/domain/content/content_registry.gd")
const PropertyDefinition = preload("res://src/domain/content/property_definition.gd")
const EntityDefinition = preload("res://src/domain/content/entity_definition.gd")
const EventDefinition = preload("res://src/domain/content/event_definition.gd")
const EntityInstance = preload("res://src/domain/world/entity_instance.gd")
const EntityStore = preload("res://src/domain/world/entity_store.gd")
const WorldRelationStore = preload("res://src/domain/world/world_relation_store.gd")
const WilsonWorldState = preload("res://src/domain/world/wilson_world_state.gd")
const EnvironmentState = preload("res://src/domain/world/environment_state.gd")
const DynamicProcessStore = preload("res://src/domain/world/dynamic_process_store.gd")
const WeatherDefinition = preload("res://src/domain/world/weather_definition.gd")
const WeatherTransitionDefinition = preload("res://src/domain/world/weather_transition_definition.gd")
const EnvironmentalResponseDefinition = preload("res://src/domain/world/environmental_response_definition.gd")
const BeliefStore = preload("res://src/domain/cognition/belief_store.gd")
const CurrentIntentionStore = preload("res://src/domain/cognition/current_intention_store.gd")
const RunRuntimeComposer = preload("res://src/application/simulation/run_runtime_composer.gd")
const SimulationStepContext = preload("res://src/application/simulation/simulation_step_context.gd")

var _failures: Array[String] = []
var _completed := false


func _init() -> void:
	_run_slice()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS run_runtime_environment_composition_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL run_runtime_environment_composition_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_slice() -> void:
	var moisture = DomainId.property(&"moisture")
	var absorbency = DomainId.property(&"absorbency")
	var covering = DomainId.capability(&"covering")
	var cloth_type = DomainId.entity_type(&"cloth")
	var camp = DomainId.place(&"camp")
	var weather_changed = DomainId.event_definition(&"weather_changed")

	var content = ContentRegistry.new()
	_expect_true(content.register_property_definition(PropertyDefinition.new(moisture, PropertyDefinition.ValueFamily.NUMBER, 0.0, 1.0)).ok, "moisture registers")
	_expect_true(content.register_property_definition(PropertyDefinition.new(absorbency, PropertyDefinition.ValueFamily.NUMBER, 0.0, 1.0)).ok, "absorbency registers")
	_expect_true(content.register_entity_definition(EntityDefinition.new(
		cloth_type,
		[],
		{moisture.key(): 0.0, absorbency.key(): 1.0},
		[covering]
	)).ok, "cloth semantics register")
	_expect_true(content.register_event_definition(EventDefinition.new(
		weather_changed,
		[],
		[&"vision", &"hearing"],
		1.0,
		EventDefinition.AccessScope.AMBIENT
	)).ok, "ambient weather event registers")
	_expect_true(content.register_weather_definition(WeatherDefinition.new(
		&"clear", 1.0, 1.0, {&"rain_intensity": 0.0}
	)).ok, "clear weather registers")
	_expect_true(content.register_weather_definition(WeatherDefinition.new(
		&"rain", 10.0, 10.0, {&"rain_intensity": 1.0}
	)).ok, "rain weather registers")
	_expect_true(content.register_weather_transition_definition(WeatherTransitionDefinition.new(
		&"clear", &"rain", 1.0, weather_changed
	)).ok, "clear-to-rain transition registers")
	_expect_true(content.register_weather_transition_definition(WeatherTransitionDefinition.new(
		&"rain", &"clear", 1.0, weather_changed
	)).ok, "rain-to-clear transition registers")
	_expect_true(content.register_environmental_response_definition(EnvironmentalResponseDefinition.new(
		&"covering_gets_wet",
		&"rain_intensity",
		moisture,
		0.25,
		0.0,
		1.0,
		&"",
		covering,
		absorbency
	)).ok, "rain response registers")
	_expect_true(content.seal().ok, "environmental content seals")

	var entities = EntityStore.new()
	var cloth_id = DomainId.entity(&"cloth_1")
	_expect_true(entities.add_entity(EntityInstance.new(cloth_id, cloth_type, camp)).ok, "cloth owner state added")
	var environment = EnvironmentState.new(&"clear", &"day")
	var composition = RunRuntimeComposer.new().compose(
		entities,
		WorldRelationStore.new(),
		WilsonWorldState.new(camp),
		BeliefStore.new(),
		CurrentIntentionStore.new(),
		content,
		environment,
		DynamicProcessStore.new()
	)
	_expect_true(composition.ok, "sealed environmental content and owners compose")
	if not composition.ok:
		_completed = true
		return
	var runtime = composition.composition
	_expect_true(runtime.world_advance != null, "production composition reconstructs world advance")

	var result = runtime.world_advance.advance(
		2.0,
		SimulationStepContext.new(&"runtime_weather_step", 2.0, 2.0, null, [])
	)
	var cloth = RuntimeWorldRef.entity(cloth_id)
	_expect_equal(environment.weather, &"rain", "composed runtime advances authoritative weather")
	_expect_float(runtime.world_query.get_instance_property(cloth, moisture), 0.25, "composed runtime applies rain only over rain segment")
	_expect_equal(result.events.size(), 1, "composed runtime emits authored weather transition event")
	if result.events.size() == 1:
		var access = runtime.perception_access.resolve(result.events, null)
		var perception = runtime.perception.perceive(result.events, access)
		_expect_equal(perception.observed_events.size(), 1, "composed ambient event reaches ordinary perception")

	_completed = true


func _expect_true(actual: bool, label: String) -> void:
	if not actual:
		_failures.append("Expected true: %s" % label)


func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])


func _expect_float(actual: Variant, expected: float, label: String) -> void:
	if actual == null or not is_equal_approx(float(actual), expected):
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
