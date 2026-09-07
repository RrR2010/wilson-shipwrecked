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
const EnvironmentalResponseDefinition = preload("res://src/domain/world/environmental_response_definition.gd")
const EnvironmentalResponseAdvanceService = preload("res://src/domain/world/environmental_response_advance_service.gd")

var _failures: Array[String] = []
var _completed := false


class ConditionProviderStub:
	extends RefCounted

	var values: Dictionary

	func _init(p_values: Dictionary) -> void:
		values = p_values.duplicate(true)

	func condition(condition_id: StringName, fallback: float = 0.0) -> float:
		return float(values.get(condition_id, fallback))


func _init() -> void:
	_run_slice()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS environmental_response_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL environmental_response_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_slice() -> void:
	var moisture = DomainId.property(&"moisture")
	var absorbency = DomainId.property(&"absorbency")
	var covering = DomainId.capability(&"covering")
	var cloth_type = DomainId.entity_type(&"cloth")
	var stone_type = DomainId.entity_type(&"stone")
	var camp = DomainId.place(&"camp")

	var content = ContentRegistry.new()
	_expect_true(content.register_property_definition(PropertyDefinition.new(moisture, PropertyDefinition.ValueFamily.NUMBER, 0.0, 1.0)).ok, "moisture property registers")
	_expect_true(content.register_property_definition(PropertyDefinition.new(absorbency, PropertyDefinition.ValueFamily.NUMBER, 0.0, 1.0)).ok, "absorbency property registers")
	_expect_true(content.register_entity_definition(EntityDefinition.new(
		cloth_type,
		[],
		{moisture.key(): 0.1, absorbency.key(): 0.8},
		[covering]
	)).ok, "cloth semantics register")
	_expect_true(content.register_entity_definition(EntityDefinition.new(
		stone_type,
		[],
		{moisture.key(): 0.1, absorbency.key(): 0.0},
		[]
	)).ok, "stone semantics register")
	_expect_true(content.seal().ok, "content seals")

	var entities = EntityStore.new()
	var cloth_id = DomainId.entity(&"cloth_1")
	var stone_id = DomainId.entity(&"stone_1")
	_expect_true(entities.add_entity(EntityInstance.new(cloth_id, cloth_type, camp)).ok, "cloth instance added")
	_expect_true(entities.add_entity(EntityInstance.new(stone_id, stone_type, camp)).ok, "stone instance added")
	var cloth = RuntimeWorldRef.entity(cloth_id)
	var stone = RuntimeWorldRef.entity(stone_id)
	var query = DefaultWorldQuery.new(entities, WorldRelationStore.new(), content)
	var rain = ConditionProviderStub.new({&"rain_intensity": 0.5})
	var response = EnvironmentalResponseDefinition.new(
		&"absorbent_covering_gets_wet",
		&"rain_intensity",
		moisture,
		0.5,
		0.0,
		1.0,
		&"",
		covering,
		absorbency,
		0.1
	)
	var advance = EnvironmentalResponseAdvanceService.new(rain, query, entities, [response])

	var result = advance.advance(1.0)
	# 0.5 base rate * 0.5 rain * 0.8 absorbency = +0.2 moisture.
	_expect_float(query.get_instance_property(cloth, moisture), 0.3, "rain magnitude and absorbency compose into cloth moisture")
	_expect_float(query.get_instance_property(stone, moisture), 0.1, "non-covering stone is unaffected without type branching")
	_expect_equal(result["transitions"].size(), 1, "only eligible semantic target changes")
	_expect_false(result["change_set"].is_empty(), "environmental property mutation emits semantic invalidation")
	if result["transitions"].size() == 1:
		_expect_equal(result["transitions"][0]["response_id"], &"absorbent_covering_gets_wet", "transition retains authored response provenance")
		_expect_equal(result["transitions"][0]["condition_id"], &"rain_intensity", "transition retains environmental condition provenance")

	_completed = true


func _expect_true(actual: bool, label: String) -> void:
	if not actual:
		_failures.append("Expected true: %s" % label)


func _expect_false(actual: bool, label: String) -> void:
	if actual:
		_failures.append("Expected false: %s" % label)


func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])


func _expect_float(actual: Variant, expected: float, label: String) -> void:
	if actual == null or not is_equal_approx(float(actual), expected):
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
