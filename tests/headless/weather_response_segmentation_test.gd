extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const ContentRegistry = preload("res://src/domain/content/content_registry.gd")
const PropertyDefinition = preload("res://src/domain/content/property_definition.gd")
const EntityDefinition = preload("res://src/domain/content/entity_definition.gd")
const EntityInstance = preload("res://src/domain/world/entity_instance.gd")
const EntityStore = preload("res://src/domain/world/entity_store.gd")
const WorldRelationStore = preload("res://src/domain/world/world_relation_store.gd")
const DefaultWorldQuery = preload("res://src/domain/world/default_world_query.gd")
const EnvironmentState = preload("res://src/domain/world/environment_state.gd")
const WeatherDefinition = preload("res://src/domain/world/weather_definition.gd")
const WeatherTransitionDefinition = preload("res://src/domain/world/weather_transition_definition.gd")
const WeatherProgressionService = preload("res://src/domain/world/weather_progression_service.gd")
const EnvironmentalResponseDefinition = preload("res://src/domain/world/environmental_response_definition.gd")
const EnvironmentalResponseAdvanceService = preload("res://src/domain/world/environmental_response_advance_service.gd")
const SemanticChangeSet = preload("res://src/domain/world/semantic_change_set.gd")
const EnvironmentWorldAdvanceService = preload("res://src/application/simulation/environment_world_advance_service.gd")
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
		print("PASS weather_response_segmentation_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL weather_response_segmentation_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_slice() -> void:
	var moisture = DomainId.property(&"moisture")
	var covering = DomainId.capability(&"covering")
	var cloth_type = DomainId.entity_type(&"cloth")
	var camp = DomainId.place(&"camp")
	var content = ContentRegistry.new()
	_expect_true(content.register_property_definition(PropertyDefinition.new(moisture, PropertyDefinition.ValueFamily.NUMBER, 0.0, 1.0)).ok, "moisture property registers")
	_expect_true(content.register_entity_definition(EntityDefinition.new(cloth_type, [], {moisture.key(): 0.0}, [covering])).ok, "cloth semantics register")
	_expect_true(content.seal().ok, "content seals")

	var entities = EntityStore.new()
	var cloth_id = DomainId.entity(&"cloth_1")
	_expect_true(entities.add_entity(EntityInstance.new(cloth_id, cloth_type, camp)).ok, "cloth instance added")
	var cloth = RuntimeWorldRef.entity(cloth_id)
	var query = DefaultWorldQuery.new(entities, WorldRelationStore.new(), content)
	var environment = EnvironmentState.new(&"clear", &"day")
	var weather = WeatherProgressionService.new(
		environment,
		[
			WeatherDefinition.new(&"clear", 1.0, 1.0, {&"rain_intensity": 0.0}),
			WeatherDefinition.new(&"rain", 10.0, 10.0, {&"rain_intensity": 1.0}),
		],
		[
			WeatherTransitionDefinition.new(&"clear", &"rain"),
			WeatherTransitionDefinition.new(&"rain", &"clear"),
		]
	)
	var response = EnvironmentalResponseAdvanceService.new(
		weather,
		query,
		entities,
		[
			EnvironmentalResponseDefinition.new(
				&"covering_gets_wet",
				&"rain_intensity",
				moisture,
				0.25,
				0.0,
				1.0,
				&"",
				covering
			)
		]
	)
	var world_advance = EnvironmentWorldAdvanceService.new(
		DynamicProcessAdvanceStub.new(),
		null,
		null,
		null,
		null,
		weather,
		null,
		response
	)

	# One coarse step spans 1s clear + 1s rain. If final-state weather were applied
	# retroactively to the whole step, moisture would incorrectly become 0.5.
	world_advance.advance(2.0, SimulationStepContext.new(&"coarse_weather_step", 2.0, 2.0, null, []))
	_expect_equal(environment.weather, &"rain", "coarse step reaches rain regime")
	_expect_float(environment.weather_elapsed, 1.0, "coarse step conserves elapsed time in new regime")
	_expect_float(query.get_instance_property(cloth, moisture), 0.25, "environmental response applies only during elapsed rain segment")

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
