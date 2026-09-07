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
const PropertyDerivationDefinition = preload("res://src/domain/physical/property_derivation_definition.gd")
const PropertyInputSelector = preload("res://src/domain/physical/property_input_selector.gd")
const WeatherDefinition = preload("res://src/domain/world/weather_definition.gd")
const WeatherTransitionDefinition = preload("res://src/domain/world/weather_transition_definition.gd")
const EnvironmentalResponseDefinition = preload("res://src/domain/world/environmental_response_definition.gd")
const EnvironmentalResponseTargetSelector = preload("res://src/domain/world/environmental_response_target_selector.gd")
const RunRuntimeComposer = preload("res://src/application/simulation/run_runtime_composer.gd")
const SimulationStepContext = preload("res://src/application/simulation/simulation_step_context.gd")

var _failures: Array[String] = []
var _completed := false


func _init() -> void:
	_run_slice()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS weather_wind_binding_stress_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL weather_wind_binding_stress_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_slice() -> void:
	var camp = DomainId.place(&"camp")
	var attached_to = DomainId.relation_type(&"attached_to")
	var covering = DomainId.capability(&"covering")
	var moisture = DomainId.property(&"moisture")
	var wind_susceptibility = DomainId.property(&"wind_susceptibility")
	var binding_integrity = DomainId.property(&"binding_integrity")
	var roof_stability = DomainId.property(&"roof_stability")
	var covering_slot = DomainId.assembly_slot(&"roof_covering")
	var binding_slot = DomainId.assembly_slot(&"roof_binding")
	var host_type = DomainId.entity_type(&"cover_host")
	var cloth_type = DomainId.entity_type(&"cloth")
	var binding_type = DomainId.entity_type(&"fiber_binding")

	var content = ContentRegistry.new()
	_expect_true(content.register_property_definition(PropertyDefinition.new(moisture, PropertyDefinition.ValueFamily.NUMBER, 0.0, 1.0)).ok, "moisture registers")
	_expect_true(content.register_property_definition(PropertyDefinition.new(wind_susceptibility, PropertyDefinition.ValueFamily.NUMBER, 0.0, 1.0)).ok, "wind susceptibility registers")
	_expect_true(content.register_property_definition(PropertyDefinition.new(binding_integrity, PropertyDefinition.ValueFamily.NUMBER, 0.0, 1.0)).ok, "binding integrity registers")
	_expect_true(content.register_property_definition(PropertyDefinition.new(roof_stability, PropertyDefinition.ValueFamily.NUMBER, 0.0, 1.0)).ok, "roof stability registers")
	_expect_true(content.register_entity_definition(EntityDefinition.new(host_type, [], {}, [covering])).ok, "host semantics register")
	_expect_true(content.register_entity_definition(EntityDefinition.new(cloth_type, [], {moisture.key(): 0.8}, [])).ok, "cloth semantics register")
	_expect_true(content.register_entity_definition(EntityDefinition.new(binding_type, [], {binding_integrity.key(): 1.0}, [])).ok, "binding semantics register")
	_expect_true(content.register_property_derivation_definition(PropertyDerivationDefinition.new(
		&"wet_covering_wind_susceptibility",
		[PropertyInputSelector.assembly_slot_property(covering_slot, moisture)],
		wind_susceptibility,
		&"max_numeric"
	)).ok, "assembly-derived wind susceptibility registers")
	_expect_true(content.register_property_derivation_definition(PropertyDerivationDefinition.new(
		&"binding_driven_roof_stability",
		[PropertyInputSelector.assembly_slot_property(binding_slot, binding_integrity)],
		roof_stability,
		&"min_numeric"
	)).ok, "assembly-derived roof stability registers")
	_expect_true(content.register_weather_definition(WeatherDefinition.new(
		&"storm", 10.0, 10.0, {&"wind_intensity": 1.0}
	)).ok, "storm weather registers")
	_expect_true(content.register_weather_transition_definition(WeatherTransitionDefinition.new(
		&"storm", &"storm", 1.0
	)).ok, "storm continuation registers")
	_expect_true(content.register_environmental_response_definition(EnvironmentalResponseDefinition.new(
		&"wind_loads_binding",
		&"wind_intensity",
		binding_integrity,
		-0.5,
		0.0,
		1.0,
		&"",
		covering,
		wind_susceptibility,
		0.0,
		EnvironmentalResponseTargetSelector.assembly_slot(binding_slot)
	)).ok, "wind binding response registers")
	_expect_true(content.seal().ok, "content seals")

	var host_id = DomainId.entity(&"shelter_host_1")
	var cloth_id = DomainId.entity(&"cloth_1")
	var binding_id = DomainId.entity(&"binding_1")
	var entities = EntityStore.new()
	_expect_true(entities.add_entity(EntityInstance.new(host_id, host_type, camp)).ok, "host added")
	_expect_true(entities.add_entity(EntityInstance.new(cloth_id, cloth_type, camp)).ok, "cloth added")
	_expect_true(entities.add_entity(EntityInstance.new(binding_id, binding_type, camp)).ok, "binding added")
	var host = RuntimeWorldRef.entity(host_id)
	var cloth = RuntimeWorldRef.entity(cloth_id)
	var binding = RuntimeWorldRef.entity(binding_id)
	var relations = WorldRelationStore.new()
	_expect_true(relations.add_relation(WorldRelation.new(attached_to, cloth, host, covering_slot)).ok, "covering assembly relation added")
	_expect_true(relations.add_relation(WorldRelation.new(attached_to, binding, host, binding_slot)).ok, "binding assembly relation added")

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
	_expect_true(composed.ok, "runtime composes with assembly-derived environmental response")
	if not composed.ok:
		_completed = true
		return
	var runtime = composed.composition
	var initial_profile = runtime.effective_physical_profiles.resolve(host)
	_expect_float(initial_profile.get_property(wind_susceptibility), 0.8, "host derives wind susceptibility from wet covering slot")
	_expect_float(initial_profile.get_property(roof_stability), 1.0, "host initially derives full stability from binding slot")

	var result = runtime.world_advance.advance(1.0, SimulationStepContext.new(&"wind_step", 1.0, 1.0, null, []))
	# -0.5 full-rate * 1.0 wind * 0.8 susceptibility = -0.4 binding integrity.
	_expect_float(runtime.world_query.get_instance_property(binding, binding_integrity), 0.6, "wind stress degrades configured binding through semantic slot targeting")
	_expect_true(result.diagnostics.is_empty(), "wind response produces no world-advance diagnostics")
	_expect_true(not result.change_set.is_empty(), "binding degradation emits semantic invalidation")
	_expect_float(runtime.effective_physical_profiles.resolve(host).get_property(roof_stability), 1.0, "cached host profile remains stable until explicit invalidation boundary")
	var invalidation = runtime.derived_invalidator.apply(result.change_set)
	_expect_true(not invalidation.is_empty(), "world change enters derived invalidation boundary")
	_expect_float(runtime.effective_physical_profiles.resolve(host).get_property(roof_stability), 0.6, "component invalidation propagates to host assembly profile")

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
