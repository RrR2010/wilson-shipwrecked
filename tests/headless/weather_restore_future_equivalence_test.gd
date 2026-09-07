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
const SimulationSnapshotService = preload("res://src/infrastructure/persistence/simulation_snapshot_service.gd")
const ActionExecutionSnapshotService = preload("res://src/infrastructure/persistence/action_execution_snapshot_service.gd")
const RunRuntimeRestoreService = preload("res://src/infrastructure/persistence/run_runtime_restore_service.gd")

var _failures: Array[String] = []
var _completed := false


func _init() -> void:
	_run_slice()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS weather_restore_future_equivalence_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL weather_restore_future_equivalence_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_slice() -> void:
	var camp = DomainId.place(&"weather_restore_camp")
	var moisture = DomainId.property(&"moisture")
	var absorbency = DomainId.property(&"absorbency")
	var covering = DomainId.capability(&"covering")
	var cloth_type = DomainId.entity_type(&"cloth")
	var cloth_id = DomainId.entity(&"cloth_restore_1")
	var weather_changed = DomainId.event_definition(&"weather_changed")
	var content = ContentRegistry.new()
	_expect_true(content.register_property_definition(PropertyDefinition.new(moisture, PropertyDefinition.ValueFamily.NUMBER, 0.0, 1.0)).ok, "moisture registers")
	_expect_true(content.register_property_definition(PropertyDefinition.new(absorbency, PropertyDefinition.ValueFamily.NUMBER, 0.0, 1.0)).ok, "absorbency registers")
	_expect_true(content.register_entity_definition(EntityDefinition.new(
		cloth_type,
		[],
		{moisture.key(): 0.0, absorbency.key(): 1.0},
		[covering]
	)).ok, "cloth registers")
	_expect_true(content.register_event_definition(EventDefinition.new(
		weather_changed,
		[],
		[&"hearing"],
		1.0,
		EventDefinition.AccessScope.AMBIENT
	)).ok, "ambient weather event registers")
	_expect_true(content.register_weather_definition(WeatherDefinition.new(
		&"clear", 1.0, 1.0, {&"rain_intensity": 0.0}
	)).ok, "clear registers")
	_expect_true(content.register_weather_definition(WeatherDefinition.new(
		&"rain", 4.0, 4.0, {&"rain_intensity": 1.0}
	)).ok, "rain registers")
	_expect_true(content.register_weather_transition_definition(WeatherTransitionDefinition.new(
		&"clear", &"rain", 1.0, weather_changed
	)).ok, "clear-to-rain registers")
	_expect_true(content.register_weather_transition_definition(WeatherTransitionDefinition.new(
		&"rain", &"clear", 1.0, weather_changed
	)).ok, "rain-to-clear registers")
	_expect_true(content.register_environmental_response_definition(EnvironmentalResponseDefinition.new(
		&"covering_gets_wet",
		&"rain_intensity",
		moisture,
		0.2,
		0.0,
		1.0,
		&"",
		covering,
		absorbency
	)).ok, "rain response registers")
	_expect_true(content.seal().ok, "content seals")

	var entities = EntityStore.new()
	_expect_true(entities.add_entity(EntityInstance.new(cloth_id, cloth_type, camp)).ok, "cloth owner state added")
	var relations = WorldRelationStore.new()
	var wilson_world = WilsonWorldState.new(camp)
	var beliefs = BeliefStore.new()
	var intentions = CurrentIntentionStore.new()
	var environment = EnvironmentState.new(&"clear", &"day")
	var dynamic_processes = DynamicProcessStore.new()
	var original_result = RunRuntimeComposer.new().compose(
		entities,
		relations,
		wilson_world,
		beliefs,
		intentions,
		content,
		environment,
		dynamic_processes
	)
	_expect_true(original_result.ok, "original environmental runtime composes")
	if not original_result.ok:
		_completed = true
		return
	var original = original_result.composition
	var cloth = RuntimeWorldRef.entity(cloth_id)

	# Cross into rain and advance halfway through the four-second rain regime.
	original.world_advance.advance(3.0, SimulationStepContext.new(&"before_snapshot", 3.0, 3.0, null, []))
	_expect_equal(environment.weather, &"rain", "fixture reaches rain before snapshot")
	_expect_float(environment.weather_elapsed, 2.0, "fixture captures mid-regime elapsed time")
	_expect_float(original.world_query.get_instance_property(cloth, moisture), 0.4, "two seconds of rain affect material before snapshot")

	var simulation_snapshot = SimulationSnapshotService.new().capture(
		entities,
		relations,
		wilson_world,
		beliefs,
		intentions,
		null,
		null,
		null,
		null,
		null,
		null,
		environment,
		dynamic_processes
	)
	var action_snapshot = ActionExecutionSnapshotService.new().capture(original.action_execution)
	var parsed_simulation = JSON.parse_string(JSON.stringify(simulation_snapshot))
	var parsed_actions = JSON.parse_string(JSON.stringify(action_snapshot))
	_expect_true(parsed_simulation is Dictionary and parsed_actions is Dictionary, "snapshots survive JSON boundary")
	if not (parsed_simulation is Dictionary) or not (parsed_actions is Dictionary):
		_completed = true
		return

	var restored_result = RunRuntimeRestoreService.new().restore(parsed_simulation, parsed_actions, content)
	_expect_true(restored_result.ok, "environmental runtime restores through production boundary")
	if not restored_result.ok:
		_completed = true
		return
	var restored = restored_result.runtime
	var restored_environment = restored_result.simulation.environment
	var restored_cloth = RuntimeWorldRef.entity(cloth_id)
	_expect_true(restored.world_advance != null, "restore reconstructs environmental world advance")
	_expect_equal(restored_environment.weather, environment.weather, "restored weather regime matches captured cause")
	_expect_float(restored_environment.weather_elapsed, environment.weather_elapsed, "restored weather elapsed matches captured cause")
	_expect_float(restored.world_query.get_instance_property(restored_cloth, moisture), 0.4, "restored material state matches captured cause")

	# Both worlds now have exactly two seconds of rain remaining. Advancing three
	# seconds must produce 2s rain + 1s clear in both, including material response.
	var original_future = original.world_advance.advance(3.0, SimulationStepContext.new(&"original_future", 3.0, 6.0, null, []))
	var restored_future = restored.world_advance.advance(3.0, SimulationStepContext.new(&"restored_future", 3.0, 6.0, null, []))
	_expect_equal(restored_environment.weather, environment.weather, "restored and original futures choose the same next weather")
	_expect_float(restored_environment.weather_elapsed, environment.weather_elapsed, "restored and original futures conserve identical phase elapsed")
	_expect_float(restored_environment.weather_planned_duration, environment.weather_planned_duration, "restored and original futures retain identical planned duration")
	_expect_equal(restored_environment.weather_transition_index, environment.weather_transition_index, "restored and original futures retain identical transition history")
	_expect_float(
		restored.world_query.get_instance_property(restored_cloth, moisture),
		float(original.world_query.get_instance_property(cloth, moisture)),
		"restored and original futures apply identical material response"
	)
	_expect_equal(restored_future.events.size(), original_future.events.size(), "restored and original futures emit the same weather event count")
	_expect_float(original.world_query.get_instance_property(cloth, moisture), 0.8, "only two remaining rain seconds affect future material state")

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
