extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const ContentRegistry = preload("res://src/domain/content/content_registry.gd")
const PropertyDefinition = preload("res://src/domain/content/property_definition.gd")
const EntityDefinition = preload("res://src/domain/content/entity_definition.gd")
const EntityInstance = preload("res://src/domain/world/entity_instance.gd")
const EntityStore = preload("res://src/domain/world/entity_store.gd")
const WorldRelation = preload("res://src/domain/world/world_relation.gd")
const WorldRelationStore = preload("res://src/domain/world/world_relation_store.gd")
const WilsonWorldState = preload("res://src/domain/world/wilson_world_state.gd")
const EnvironmentState = preload("res://src/domain/world/environment_state.gd")
const DynamicProcessStore = preload("res://src/domain/world/dynamic_process_store.gd")
const SemanticChange = preload("res://src/domain/world/semantic_change.gd")
const SemanticChangeSet = preload("res://src/domain/world/semantic_change_set.gd")
const PropertyDerivationDefinition = preload("res://src/domain/physical/property_derivation_definition.gd")
const PropertyInputSelector = preload("res://src/domain/physical/property_input_selector.gd")
const ProtectionRuleDefinition = preload("res://src/domain/physical/protection_rule_definition.gd")
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
		print("PASS effective_protection_feedback_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL effective_protection_feedback_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_slice() -> void:
	var camp = DomainId.place(&"camp")
	var attached_to = DomainId.relation_type(&"attached_to")
	var protects = DomainId.relation_type(&"protects")
	var binding_slot = DomainId.assembly_slot(&"roof_binding")
	var absorbent = DomainId.capability(&"absorbent")
	var coverage = DomainId.property(&"coverage")
	var rain_protection = DomainId.property(&"rain_protection")
	var binding_integrity = DomainId.property(&"binding_integrity")
	var moisture = DomainId.property(&"moisture")
	var absorbency = DomainId.property(&"absorbency")
	var host_type = DomainId.entity_type(&"shelter_host")
	var binding_type = DomainId.entity_type(&"fiber_binding")
	var bedding_type = DomainId.entity_type(&"bedding")

	var content = ContentRegistry.new()
	_expect_true(content.register_property_definition(PropertyDefinition.new(coverage, PropertyDefinition.ValueFamily.NUMBER, 0.0, 1.0)).ok, "coverage registers")
	_expect_true(content.register_property_definition(PropertyDefinition.new(rain_protection, PropertyDefinition.ValueFamily.NUMBER, 0.0, 1.0)).ok, "rain protection registers")
	_expect_true(content.register_property_definition(PropertyDefinition.new(binding_integrity, PropertyDefinition.ValueFamily.NUMBER, 0.0, 1.0)).ok, "binding integrity registers")
	_expect_true(content.register_property_definition(PropertyDefinition.new(moisture, PropertyDefinition.ValueFamily.NUMBER, 0.0, 1.0)).ok, "moisture registers")
	_expect_true(content.register_property_definition(PropertyDefinition.new(absorbency, PropertyDefinition.ValueFamily.NUMBER, 0.0, 1.0)).ok, "absorbency registers")
	_expect_true(content.register_entity_definition(EntityDefinition.new(host_type, [], {coverage.key(): 0.8}, [])).ok, "host registers")
	_expect_true(content.register_entity_definition(EntityDefinition.new(binding_type, [], {binding_integrity.key(): 1.0}, [])).ok, "binding registers")
	_expect_true(content.register_entity_definition(EntityDefinition.new(bedding_type, [], {moisture.key(): 0.0, absorbency.key(): 1.0}, [absorbent])).ok, "bedding registers")
	_expect_true(content.register_property_derivation_definition(PropertyDerivationDefinition.new(
		&"binding_driven_rain_protection",
		[PropertyInputSelector.assembly_slot_property(binding_slot, binding_integrity)],
		rain_protection,
		&"min_numeric"
	)).ok, "binding-driven protection derivation registers")
	_expect_true(content.register_protection_rule_definition(ProtectionRuleDefinition.new(
		&"rain_cover", &"rain", protects, coverage, rain_protection
	)).ok, "rain protection rule registers")
	_expect_true(content.register_weather_definition(WeatherDefinition.new(
		&"rain", 10.0, 10.0, {&"rain_intensity": 1.0}
	)).ok, "rain weather registers")
	_expect_true(content.register_weather_transition_definition(WeatherTransitionDefinition.new(
		&"rain", &"rain", 1.0
	)).ok, "rain continuation registers")
	_expect_true(content.register_environmental_response_definition(EnvironmentalResponseDefinition.new(
		&"bedding_gets_wet",
		&"rain_intensity",
		moisture,
		0.1,
		0.0,
		1.0,
		&"rain",
		absorbent,
		absorbency,
		0.0
	)).ok, "bedding rain response registers")
	_expect_true(content.seal().ok, "content seals")

	var host_id = DomainId.entity(&"shelter_host_1")
	var binding_id = DomainId.entity(&"binding_1")
	var bedding_id = DomainId.entity(&"bedding_1")
	var entities = EntityStore.new()
	_expect_true(entities.add_entity(EntityInstance.new(host_id, host_type, camp)).ok, "host added")
	_expect_true(entities.add_entity(EntityInstance.new(binding_id, binding_type, camp)).ok, "binding added")
	_expect_true(entities.add_entity(EntityInstance.new(bedding_id, bedding_type, camp)).ok, "bedding added")
	var host = RuntimeWorldRef.entity(host_id)
	var binding = RuntimeWorldRef.entity(binding_id)
	var bedding = RuntimeWorldRef.entity(bedding_id)
	var relations = WorldRelationStore.new()
	_expect_true(relations.add_relation(WorldRelation.new(attached_to, binding, host, binding_slot)).ok, "binding attaches through roof slot")
	_expect_true(relations.add_relation(WorldRelation.new(protects, host, bedding)).ok, "host protects bedding")

	var composed = RunRuntimeComposer.new().compose(
		entities,
		relations,
		WilsonWorldState.new(camp),
		BeliefStore.new(),
		CurrentIntentionStore.new(),
		content,
		EnvironmentState.new(&"rain", &"day"),
		DynamicProcessStore.new()
	)
	_expect_true(composed.ok, "runtime composes effective protection feedback")
	if not composed.ok:
		_completed = true
		return
	var runtime = composed.composition

	_expect_float(runtime.effective_physical_profiles.resolve(host).get_property(rain_protection), 1.0, "intact binding derives full rain protection")
	var first = runtime.world_advance.advance(1.0, SimulationStepContext.new(&"intact_rain", 1.0, 1.0, null, []))
	_expect_true(first.diagnostics.is_empty(), "intact rain step has no diagnostics")
	_expect_float(runtime.world_query.get_instance_property(bedding, moisture), 0.02, "intact protection leaves only twenty percent rain exposure")
	runtime.derived_invalidator.apply(first.change_set)

	_expect_true(entities.set_property_override(binding_id, binding_integrity, 0.25).ok, "binding integrity weakens")
	var binding_change = SemanticChangeSet.new([
		SemanticChange.property_change(binding, binding_integrity),
	])
	var invalidation = runtime.derived_invalidator.apply(binding_change)
	_expect_true(not invalidation.is_empty(), "binding change invalidates dependent host profile")
	_expect_float(runtime.effective_physical_profiles.resolve(host).get_property(rain_protection), 0.25, "weak binding lowers effective rain protection")

	var second = runtime.world_advance.advance(1.0, SimulationStepContext.new(&"weakened_rain", 1.0, 2.0, null, []))
	_expect_true(second.diagnostics.is_empty(), "weakened rain step has no diagnostics")
	# coverage 0.8 * strength 0.25 = 0.2 protection, so residual exposure is 0.8.
	# At rate 0.1/sec the second step adds 0.08 moisture to the prior 0.02.
	_expect_float(runtime.world_query.get_instance_property(bedding, moisture), 0.10, "weakened binding increases rain exposure through effective protection")

	_completed = true


func _expect_true(actual: bool, label: String) -> void:
	if not actual:
		_failures.append("Expected true: %s" % label)


func _expect_float(actual: Variant, expected: float, label: String) -> void:
	if actual == null or not is_equal_approx(float(actual), expected):
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
