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
const PerceptionResult = preload("res://src/domain/cognition/perception_result.gd")
const EnvironmentWorldAdvanceService = preload("res://src/application/simulation/environment_world_advance_service.gd")
const SimulationOrchestrator = preload("res://src/application/simulation/simulation_orchestrator.gd")
const SimulationStepContext = preload("res://src/application/simulation/simulation_step_context.gd")

var _failures: Array[String] = []
var _completed := false

class NoActionExecution:
	extends RefCounted
	func advance(_execution_id: StringName, _elapsed: float): return null

class NoWorldCommands:
	extends RefCounted
	func apply_outcome(_outcome): return null

class InvalidationSpy:
	extends RefCounted
	var calls: int = 0
	var last_change_count: int = 0
	func apply(change_set):
		calls += 1
		last_change_count = change_set.changes.size()
		return {"count": last_change_count}

class ActivityQueryStub:
	extends RefCounted
	func active_execution_id() -> StringName: return &""
	func current_intention(): return null

class PerceptionAccessStub:
	extends RefCounted
	func resolve(_events: Array, _step) -> Dictionary: return {}

class PerceptionStub:
	extends RefCounted
	func perceive(_events: Array, _access: Dictionary): return PerceptionResult.new()

class LearningStub:
	extends RefCounted
	func process(_perception): return {}

class OpportunityStub:
	extends RefCounted
	func generate(_perception, _beliefs, _definitions: Array) -> Array: return []

class DecisionRouterStub:
	extends RefCounted
	func resolve(_candidates: Array, _current): return null

class DecisionCommitStub:
	extends RefCounted
	func apply(_decision, _step_id: StringName): return null

class TraceSinkStub:
	extends RefCounted
	var traces: Array = []
	func record(trace) -> void: traces.append(trace)


func _init() -> void:
	_run_slice()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS environment_simulation_integration_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL environment_simulation_integration_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_slice() -> void:
	var freshness = DomainId.property(&"freshness")
	var food_type = DomainId.entity_type(&"fruit")
	var camp = DomainId.place(&"camp")
	var content = ContentRegistry.new()
	_expect_true(content.register_property_definition(PropertyDefinition.new(freshness, PropertyDefinition.ValueFamily.NUMBER, 0.0, 1.0)).ok, "freshness schema registers")
	_expect_true(content.register_entity_definition(EntityDefinition.new(food_type, [], {freshness.key(): 1.0}, [])).ok, "food definition registers")
	_expect_true(content.seal().ok, "content seals")
	var entities = EntityStore.new()
	var fruit_id = DomainId.entity(&"fruit_1")
	_expect_true(entities.add_entity(EntityInstance.new(fruit_id, food_type, camp)).ok, "fruit added")
	var fruit = RuntimeWorldRef.entity(fruit_id)
	var relations = WorldRelationStore.new()
	var query = DefaultWorldQuery.new(entities, relations, content)
	var spoilage = DynamicProcessDefinition.new(&"food_spoilage", freshness, -0.1, 0.0, 1.0)
	var processes = DynamicProcessStore.new()
	_expect_true(processes.add(DynamicProcessInstance.new(&"spoil_fruit_1", spoilage.id, fruit)), "spoilage process added")
	var world_advance = EnvironmentWorldAdvanceService.new(DynamicProcessAdvanceService.new(processes, [spoilage], query, entities))
	var invalidator = InvalidationSpy.new()
	var trace_sink = TraceSinkStub.new()
	var orchestrator = SimulationOrchestrator.new(
		world_advance,
		NoActionExecution.new(),
		NoWorldCommands.new(),
		invalidator,
		ActivityQueryStub.new(),
		PerceptionAccessStub.new(),
		PerceptionStub.new(),
		LearningStub.new(),
		OpportunityStub.new(),
		RefCounted.new(),
		[],
		DecisionRouterStub.new(),
		DecisionCommitStub.new(),
		trace_sink
	)

	orchestrator.advance(SimulationStepContext.new(&"environment_step_1", 2.0, 2.0, null, []))
	_expect_float(query.get_instance_property(fruit, freshness), 0.8, "world progression mutates environmental property before cognition")
	_expect_equal(invalidator.calls, 1, "world progression invalidates derived state")
	_expect_equal(invalidator.last_change_count, 1, "world invalidation receives semantic property change")
	_expect_equal(trace_sink.traces.size(), 1, "environment-integrated step remains traceable")
	if trace_sink.traces.size() == 1:
		_expect_true(trace_sink.traces[0].stage_results.has(&"world_derived_invalidation"), "trace records world-process invalidation")

	_completed = true


func _expect_true(actual: bool, label: String) -> void:
	if not actual: _failures.append("Expected true: %s" % label)

func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected: _failures.append("%s | expected=%s actual=%s" % [label, expected, actual])

func _expect_float(actual: Variant, expected: float, label: String) -> void:
	if actual == null or not is_equal_approx(float(actual), expected):
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
