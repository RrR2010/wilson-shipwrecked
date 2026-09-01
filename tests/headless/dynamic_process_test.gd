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
const DynamicProcessDefinition = preload("res://src/domain/world/dynamic_process_definition.gd")
const DynamicProcessInstance = preload("res://src/domain/world/dynamic_process_instance.gd")
const DynamicProcessStore = preload("res://src/domain/world/dynamic_process_store.gd")
const DynamicProcessAdvanceService = preload("res://src/domain/world/dynamic_process_advance_service.gd")

var _failures: Array[String] = []
var _completed := false


func _init() -> void:
	_run_slice()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS dynamic_process_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL dynamic_process_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_slice() -> void:
	var wetness = DomainId.property(&"wetness")
	var cloth_type = DomainId.entity_type(&"cloth")
	var camp = DomainId.place(&"camp")
	var content = ContentRegistry.new()
	_expect_true(content.register_property_definition(PropertyDefinition.new(wetness, PropertyDefinition.ValueFamily.NUMBER, 0.0, 1.0)).ok, "wetness property registers")
	_expect_true(content.register_entity_definition(EntityDefinition.new(cloth_type, [], {wetness.key(): 1.0}, [])).ok, "cloth definition registers")
	_expect_true(content.seal().ok, "content seals")

	var entities = EntityStore.new()
	var cloth_id = DomainId.entity(&"cloth_1")
	_expect_true(entities.add_entity(EntityInstance.new(cloth_id, cloth_type, camp)).ok, "cloth instance added")
	var cloth = RuntimeWorldRef.entity(cloth_id)
	var query = DefaultWorldQuery.new(entities, WorldRelationStore.new(), content)
	var drying = DynamicProcessDefinition.new(&"wet_item_drying", wetness, -0.25, 0.0, 1.0)
	var processes = DynamicProcessStore.new()
	var process = DynamicProcessInstance.new(&"drying_cloth_1", drying.id, cloth)
	_expect_true(processes.add(process), "dynamic process added")
	var advance = DynamicProcessAdvanceService.new(processes, [drying], query, entities)

	var first: Dictionary = advance.advance(1.0)
	_expect_float(query.get_instance_property(cloth, wetness), 0.75, "process advances property from authoritative state")
	_expect_equal(first["progressed"].size(), 1, "progress reports changed process")
	_expect_equal(first["completed"].size(), 0, "non-terminal process remains active")
	_expect_false(first["change_set"].is_empty(), "process emits semantic invalidation change")
	_expect_equal(process.lifecycle, DynamicProcessInstance.Lifecycle.ACTIVE, "process remains active before bound")

	process.lifecycle = DynamicProcessInstance.Lifecycle.PAUSED
	advance.advance(4.0)
	_expect_float(query.get_instance_property(cloth, wetness), 0.75, "paused process does not mutate World")
	_expect_float(process.elapsed, 1.0, "paused process does not advance elapsed cause")

	process.lifecycle = DynamicProcessInstance.Lifecycle.ACTIVE
	var final: Dictionary = advance.advance(4.0)
	_expect_float(query.get_instance_property(cloth, wetness), 0.0, "process clamps at authored bound")
	_expect_equal(process.lifecycle, DynamicProcessInstance.Lifecycle.COMPLETED, "process completes at terminal bound")
	_expect_equal(final["completed"].size(), 1, "completion is reported")
	_expect_float(process.elapsed, 5.0, "active elapsed is durable progression state")

	advance.advance(10.0)
	_expect_float(query.get_instance_property(cloth, wetness), 0.0, "completed process cannot overshoot terminal bound")
	_expect_float(process.elapsed, 5.0, "completed process no longer advances")

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
