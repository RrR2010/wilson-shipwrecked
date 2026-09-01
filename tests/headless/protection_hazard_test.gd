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
const DynamicProcessInstance = preload("res://src/domain/world/dynamic_process_instance.gd")
const DynamicProcessStore = preload("res://src/domain/world/dynamic_process_store.gd")
const HazardRuleDefinition = preload("res://src/domain/world/hazard_rule_definition.gd")
const HazardProjectionService = preload("res://src/domain/world/hazard_projection_service.gd")

var _failures: Array[String] = []
var _completed := false


func _init() -> void:
	_run_slice()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS protection_hazard_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL protection_hazard_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_slice() -> void:
	var coverage = DomainId.property(&"coverage")
	var rain_strength = DomainId.property(&"rain_protection")
	var roof_type = DomainId.entity_type(&"roof_cloth")
	var bed_type = DomainId.entity_type(&"bed")
	var palm_type = DomainId.entity_type(&"palm")
	var camp = DomainId.place(&"camp")
	var protects = DomainId.relation_type(&"protects")

	var content = ContentRegistry.new()
	_expect_true(content.register_property_definition(PropertyDefinition.new(coverage, PropertyDefinition.ValueFamily.NUMBER, 0.0, 1.0)).ok, "coverage property registers")
	_expect_true(content.register_property_definition(PropertyDefinition.new(rain_strength, PropertyDefinition.ValueFamily.NUMBER, 0.0, 1.0)).ok, "rain protection property registers")
	_expect_true(content.register_entity_definition(EntityDefinition.new(roof_type, [], {coverage.key(): 0.8, rain_strength.key(): 0.75}, [])).ok, "roof definition registers")
	_expect_true(content.register_entity_definition(EntityDefinition.new(bed_type, [], {}, [])).ok, "bed definition registers")
	_expect_true(content.register_entity_definition(EntityDefinition.new(palm_type, [], {}, [])).ok, "palm definition registers")
	_expect_true(content.seal().ok, "content seals")

	var entities = EntityStore.new()
	var roof_id = DomainId.entity(&"roof_1")
	var bed_id = DomainId.entity(&"bed_1")
	var palm_id = DomainId.entity(&"palm_1")
	_expect_true(entities.add_entity(EntityInstance.new(roof_id, roof_type, camp)).ok, "roof added")
	_expect_true(entities.add_entity(EntityInstance.new(bed_id, bed_type, camp)).ok, "bed added")
	_expect_true(entities.add_entity(EntityInstance.new(palm_id, palm_type, camp)).ok, "palm added")
	var roof = RuntimeWorldRef.entity(roof_id)
	var bed = RuntimeWorldRef.entity(bed_id)
	var palm = RuntimeWorldRef.entity(palm_id)

	var relations = WorldRelationStore.new()
	var query = DefaultWorldQuery.new(entities, relations, content)
	var protection_rule = ProtectionRuleDefinition.new(&"cloth_rain_cover", &"rain", protects, coverage, rain_strength)
	var projections = ProtectionProjectionService.new(query, [protection_rule])
	var exposure = ExposureResolver.new(projections)

	var unprotected = exposure.resolve(bed, &"rain", 1.0)
	_expect_float(unprotected.exposure_level, 1.0, "cloth without protection relation provides no shielding")
	_expect_true(relations.add_relation(WorldRelation.new(protects, roof, bed)).ok, "protection relation added")
	var protected = exposure.resolve(bed, &"rain", 1.0)
	_expect_equal(protected.protection_refs.size(), 1, "configured cover produces projection")
	_expect_float(protected.protection_refs[0].effective_reduction(), 0.6, "coverage and strength combine boundedly")
	_expect_float(protected.exposure_level, 0.4, "resolved rain exposure is target/configuration specific")

	_expect_true(entities.set_property_override(roof_id, coverage, 0.25).ok, "roof coverage degradation applied")
	var degraded = exposure.resolve(bed, &"rain", 1.0)
	_expect_float(degraded.exposure_level, 0.8125, "degraded component worsens derived protection without leak state")

	var process_store = DynamicProcessStore.new()
	var falling = DynamicProcessInstance.new(&"falling_palm_1", &"falling_palm", palm)
	_expect_true(process_store.add(falling), "falling process added")
	var hazard_rule = HazardRuleDefinition.new(&"falling_palm_hazard", &"falling_palm", 0.9, 0.95, 2.0)
	var hazards = HazardProjectionService.new(process_store, query, [hazard_rule]).derive()
	_expect_equal(hazards.size(), 1, "active dangerous process produces physical hazard projection")
	if hazards.size() == 1:
		_expect_equal(hazards[0].source_process_id, &"falling_palm_1", "hazard keeps process causality")
		_expect_equal(hazards[0].affected_place.key(), camp.key(), "hazard uses coarse authoritative place region")
		_expect_float(hazards[0].severity, 0.9, "hazard severity remains bounded")
	falling.lifecycle = DynamicProcessInstance.Lifecycle.COMPLETED
	_expect_equal(HazardProjectionService.new(process_store, query, [hazard_rule]).derive().size(), 0, "completed process no longer projects future hazard")

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
