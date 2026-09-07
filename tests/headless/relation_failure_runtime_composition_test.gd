extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const ContentRegistry = preload("res://src/domain/content/content_registry.gd")
const PropertyDefinition = preload("res://src/domain/content/property_definition.gd")
const EntityDefinition = preload("res://src/domain/content/entity_definition.gd")
const EntityInstance = preload("res://src/domain/world/entity_instance.gd")
const EntityStore = preload("res://src/domain/world/entity_store.gd")
const EnvironmentState = preload("res://src/domain/world/environment_state.gd")
const DynamicProcessStore = preload("res://src/domain/world/dynamic_process_store.gd")
const WorldRelation = preload("res://src/domain/world/world_relation.gd")
const WorldRelationStore = preload("res://src/domain/world/world_relation_store.gd")
const WilsonWorldState = preload("res://src/domain/world/wilson_world_state.gd")
const BeliefStore = preload("res://src/domain/cognition/belief_store.gd")
const CurrentIntentionStore = preload("res://src/domain/cognition/current_intention_store.gd")
const WeatherDefinition = preload("res://src/domain/world/weather_definition.gd")
const WeatherTransitionDefinition = preload("res://src/domain/world/weather_transition_definition.gd")
const EnvironmentalResponseDefinition = preload("res://src/domain/world/environmental_response_definition.gd")
const EnvironmentalResponseTargetSelector = preload("res://src/domain/world/environmental_response_target_selector.gd")
const RelationFailureDefinition = preload("res://src/domain/world/relation_failure_definition.gd")
const RunRuntimeComposer = preload("res://src/application/simulation/run_runtime_composer.gd")
const SimulationStepContext = preload("res://src/application/simulation/simulation_step_context.gd")

var _failures: Array[String] = []
var _completed := false


func _init() -> void:
	_run_slice()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS relation_failure_runtime_composition_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL relation_failure_runtime_composition_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_slice() -> void:
	var camp = DomainId.place(&"camp")
	var attached_to = DomainId.relation_type(&"attached_to")
	var covering = DomainId.capability(&"covering")
	var binding_slot = DomainId.assembly_slot(&"roof_binding")
	var binding_integrity = DomainId.property(&"binding_integrity")
	var wind_susceptibility = DomainId.property(&"wind_susceptibility")
	var host_type = DomainId.entity_type(&"cover_host")
	var binding_type = DomainId.entity_type(&"fiber_binding")

	var content = ContentRegistry.new()
	_expect_true(content.register_property_definition(PropertyDefinition.new(binding_integrity, PropertyDefinition.ValueFamily.NUMBER, 0.0, 1.0)).ok, "binding integrity registers")
	_expect_true(content.register_property_definition(PropertyDefinition.new(wind_susceptibility, PropertyDefinition.ValueFamily.NUMBER, 0.0, 1.0)).ok, "wind susceptibility registers")
	_expect_true(content.register_entity_definition(EntityDefinition.new(host_type, [], {wind_susceptibility.key(): 1.0}, [covering])).ok, "host registers")
	_expect_true(content.register_entity_definition(EntityDefinition.new(binding_type, [], {binding_integrity.key(): 1.0}, [])).ok, "binding registers")
	_expect_true(content.register_weather_definition(WeatherDefinition.new(&"storm", 10.0, 10.0, {&"wind_intensity": 1.0})).ok, "storm registers")
	_expect_true(content.register_weather_transition_definition(WeatherTransitionDefinition.new(&"storm", &"storm", 1.0)).ok, "storm continuation registers")
	_expect_true(content.register_environmental_response_definition(EnvironmentalResponseDefinition.new(
		&"wind_loads_binding",
		&"wind_intensity",
		binding_integrity,
		-0.6,
		0.0,
		1.0,
		&"",
		covering,
		wind_susceptibility,
		0.0,
		EnvironmentalResponseTargetSelector.assembly_slot(binding_slot)
	)).ok, "wind response registers")
	_expect_true(content.register_relation_failure_definition(RelationFailureDefinition.new(
		&"binding_attachment_failure",
		attached_to,
		binding_integrity,
		0.5,
		RelationFailureDefinition.Compare.LTE,
		binding_slot
	)).ok, "relation failure registers")
	_expect_true(content.seal().ok, "content seals")

	var host_id = DomainId.entity(&"host_1")
	var binding_id = DomainId.entity(&"binding_1")
	var host = RuntimeWorldRef.entity(host_id)
	var binding = RuntimeWorldRef.entity(binding_id)
	var entities = EntityStore.new()
	_expect_true(entities.add_entity(EntityInstance.new(host_id, host_type, camp)).ok, "host added")
	_expect_true(entities.add_entity(EntityInstance.new(binding_id, binding_type, camp)).ok, "binding added")
	var relations = WorldRelationStore.new()
	_expect_true(relations.add_relation(WorldRelation.new(attached_to, binding, host, binding_slot)).ok, "binding attached")

	var environment = EnvironmentState.new(&"storm", &"day")
	var composed = RunRuntimeComposer.new().compose(
		entities,
		relations,
		WilsonWorldState.new(camp),
		BeliefStore.new(),
		CurrentIntentionStore.new(),
		content,
		environment,
		DynamicProcessStore.new()
	)
	_expect_true(composed.ok, "runtime composes with authored relation failure")
	if not composed.ok:
		_completed = true
		return
	var runtime = composed.composition
	var result = runtime.world_advance.advance(1.0, SimulationStepContext.new(&"storm_step", 1.0, 1.0, null, []))
	_expect_float(runtime.world_query.get_instance_property(binding, binding_integrity), 0.4, "wind degrades binding before failure evaluation")
	_expect_equal(runtime.world_query.find_relations(attached_to, binding, host).size(), 0, "same world step detaches failed binding")
	_expect_equal(result.change_set.changes.size(), 2, "world step reports property degradation and relation detachment")
	_expect_true(result.diagnostics.is_empty(), "composed failure produces no diagnostics")

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
