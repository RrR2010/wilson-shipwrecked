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
const DefaultWorldQuery = preload("res://src/domain/world/default_world_query.gd")
const ProtectionRuleDefinition = preload("res://src/domain/physical/protection_rule_definition.gd")
const ProtectionProjectionService = preload("res://src/domain/physical/protection_projection_service.gd")
const ExposureResolver = preload("res://src/domain/physical/exposure_resolver.gd")
const EnvironmentalResponseDefinition = preload("res://src/domain/world/environmental_response_definition.gd")
const EnvironmentalResponseAdvanceService = preload("res://src/domain/world/environmental_response_advance_service.gd")

var _failures: Array[String] = []
var _completed := false


class ConditionProviderStub:
	extends RefCounted

	func condition(condition_id: StringName, fallback: float = 0.0) -> float:
		if condition_id == &"rain_intensity":
			return 1.0
		return fallback


func _init() -> void:
	_run_slice()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS environmental_response_protection_integration_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL environmental_response_protection_integration_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_slice() -> void:
	var moisture = DomainId.property(&"moisture")
	var absorbency = DomainId.property(&"absorbency")
	var coverage = DomainId.property(&"coverage")
	var rain_protection = DomainId.property(&"rain_protection")
	var covering = DomainId.capability(&"covering")
	var protects = DomainId.relation_type(&"protects")
	var cloth_type = DomainId.entity_type(&"cloth")
	var roof_type = DomainId.entity_type(&"roof")
	var camp = DomainId.place(&"camp")

	var content = ContentRegistry.new()
	_expect_true(content.register_property_definition(PropertyDefinition.new(moisture, PropertyDefinition.ValueFamily.NUMBER, 0.0, 1.0)).ok, "moisture registers")
	_expect_true(content.register_property_definition(PropertyDefinition.new(absorbency, PropertyDefinition.ValueFamily.NUMBER, 0.0, 1.0)).ok, "absorbency registers")
	_expect_true(content.register_property_definition(PropertyDefinition.new(coverage, PropertyDefinition.ValueFamily.NUMBER, 0.0, 1.0)).ok, "coverage registers")
	_expect_true(content.register_property_definition(PropertyDefinition.new(rain_protection, PropertyDefinition.ValueFamily.NUMBER, 0.0, 1.0)).ok, "rain protection registers")
	_expect_true(content.register_entity_definition(EntityDefinition.new(
		cloth_type,
		[],
		{moisture.key(): 0.0, absorbency.key(): 1.0},
		[covering]
	)).ok, "cloth semantics register")
	_expect_true(content.register_entity_definition(EntityDefinition.new(
		roof_type,
		[],
		{coverage.key(): 0.8, rain_protection.key(): 0.75},
		[]
	)).ok, "roof semantics register")
	_expect_true(content.seal().ok, "content seals")

	var entities = EntityStore.new()
	var exposed_id = DomainId.entity(&"cloth_exposed")
	var protected_id = DomainId.entity(&"cloth_protected")
	var roof_id = DomainId.entity(&"roof_1")
	_expect_true(entities.add_entity(EntityInstance.new(exposed_id, cloth_type, camp)).ok, "exposed cloth added")
	_expect_true(entities.add_entity(EntityInstance.new(protected_id, cloth_type, camp)).ok, "protected cloth added")
	_expect_true(entities.add_entity(EntityInstance.new(roof_id, roof_type, camp)).ok, "roof added")

	var relations = WorldRelationStore.new()
	var roof = RuntimeWorldRef.entity(roof_id)
	var protected_cloth = RuntimeWorldRef.entity(protected_id)
	_expect_true(relations.add_relation(WorldRelation.new(protects, roof, protected_cloth)).ok, "roof protects cloth")
	var query = DefaultWorldQuery.new(entities, relations, content)

	var protection = ProtectionProjectionService.new(query, [
		ProtectionRuleDefinition.new(&"rain_cover", &"rain", protects, coverage, rain_protection),
	])
	var exposure = ExposureResolver.new(protection)
	var response = EnvironmentalResponseDefinition.new(
		&"absorbent_covering_gets_wet",
		&"rain_intensity",
		moisture,
		0.5,
		0.0,
		1.0,
		&"rain",
		covering,
		absorbency,
		0.0
	)
	var advance = EnvironmentalResponseAdvanceService.new(
		ConditionProviderStub.new(),
		query,
		entities,
		[response],
		exposure
	)

	var result = advance.advance(1.0)
	var exposed_cloth = RuntimeWorldRef.entity(exposed_id)
	_expect_float(query.get_instance_property(exposed_cloth, moisture), 0.5, "unprotected cloth receives full rain response")
	# Roof reduction is 0.8 * 0.75 = 0.6, leaving 0.4 residual exposure.
	_expect_float(query.get_instance_property(protected_cloth, moisture), 0.2, "protected cloth receives only residual rain response")
	_expect_equal(result["transitions"].size(), 2, "both eligible cloth targets retain explicit response transitions")

	var protected_transition = null
	for transition in result["transitions"]:
		if transition["subject"].key() == protected_cloth.key():
			protected_transition = transition
			break
	_expect_true(protected_transition != null, "protected target transition is traceable")
	if protected_transition != null:
		_expect_float(protected_transition["raw_condition"], 1.0, "response retains raw environmental magnitude")
		_expect_float(protected_transition["residual_exposure"], 0.4, "response records derived residual exposure")

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
