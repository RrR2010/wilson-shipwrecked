extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const ContentRegistry = preload("res://src/domain/content/content_registry.gd")
const EntityDefinition = preload("res://src/domain/content/entity_definition.gd")
const EntityInstance = preload("res://src/domain/world/entity_instance.gd")
const EntityStore = preload("res://src/domain/world/entity_store.gd")
const WorldRelationStore = preload("res://src/domain/world/world_relation_store.gd")
const DefaultWorldQuery = preload("res://src/domain/world/default_world_query.gd")
const PropertyDependencyGraph = preload("res://src/domain/physical/property_dependency_graph.gd")
const EffectivePhysicalProfileResolver = preload("res://src/domain/physical/effective_physical_profile_resolver.gd")
const RequirementPredicate = preload("res://src/domain/actions/requirement_predicate.gd")
const RequirementPredicateEvaluator = preload("res://src/domain/actions/requirement_predicate_evaluator.gd")
const ActionDefinition = preload("res://src/domain/actions/action_definition.gd")
const ActionAttemptabilityService = preload("res://src/domain/actions/action_attemptability_service.gd")
const ActionExecutionService = preload("res://src/domain/actions/action_execution_service.gd")
const ActionResolutionDefinition = preload("res://src/domain/actions/action_resolution_definition.gd")
const RoleBinding = preload("res://src/domain/actions/role_binding.gd")
const CurrentIntentionStore = preload("res://src/domain/cognition/current_intention_store.gd")
const DefaultSimulationActivityQuery = preload("res://src/application/simulation/default_simulation_activity_query.gd")

var _failures: Array[String] = []
var _completed := false


func _init() -> void:
	_run_slice()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS action_lifecycle_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL action_lifecycle_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_slice() -> void:
	var camp = DomainId.place(&"camp")
	var crate_type = DomainId.entity_type(&"crate")
	var crate_id = DomainId.entity(&"crate_1")
	var content = ContentRegistry.new()
	_expect_true(content.register_entity_definition(EntityDefinition.new(crate_type)).ok, "crate definition registers")
	_expect_true(content.seal().ok, "content seals")
	var entities = EntityStore.new()
	_expect_true(entities.add_entity(EntityInstance.new(crate_id, crate_type, camp)).ok, "crate added")
	var query = DefaultWorldQuery.new(entities, WorldRelationStore.new(), content)
	var graph = PropertyDependencyGraph.new()
	_expect_true(graph.compile([]).ok, "empty property graph compiles")
	var evaluator = RequirementPredicateEvaluator.new(query, EffectivePhysicalProfileResolver.new(query, graph))
	var execution = ActionExecutionService.new(ActionAttemptabilityService.new(evaluator))
	var intention_store = CurrentIntentionStore.new()
	var activity = DefaultSimulationActivityQuery.new(execution, intention_store)

	var bindings = RoleBinding.new()
	bindings.bind(&"actor", RuntimeWorldRef.wilson())
	bindings.bind(&"target", RuntimeWorldRef.entity(crate_id))
	var resolution_event = DomainId.event_definition(&"action_committed")
	var requirements = RequirementPredicate.all_of([])

	var pre_only = ActionDefinition.new(DomainId.action(&"inspect"), [&"actor", &"target"], requirements)
	var pre_resolution = ActionResolutionDefinition.new(pre_only.id, 1.0, 0.5, [], resolution_event)
	_expect_true(execution.start(&"exec_pre", pre_only, pre_resolution, bindings) != null, "pre-commit-only action starts")
	_expect_equal(String(activity.active_execution_id()), "exec_pre", "activity query reads actual active execution")
	_expect_true(execution.interrupt(&"exec_pre"), "pre-commit interruption succeeds")
	var interrupted_pre = execution.get_state(&"exec_pre")
	_expect_true(interrupted_pre != null and interrupted_pre.interrupted, "interrupted state retained as terminal history")
	_expect_equal(String(activity.active_execution_id()), "", "interrupted execution is no longer active")
	_expect_true(execution.start(&"exec_pre", pre_only, pre_resolution, bindings) == null, "terminal id cannot be reused before cleanup")
	var prune_pre = execution.prune_terminal()
	_expect_equal(prune_pre.value.size(), 1, "cleanup prunes terminal execution")
	_expect_true(execution.get_state(&"exec_pre") == null, "pruned execution removed")

	var never = ActionDefinition.new(
		DomainId.action(&"brace"),
		[&"actor", &"target"],
		requirements,
		ActionDefinition.InterruptionClass.NEVER
	)
	var never_resolution = ActionResolutionDefinition.new(never.id, 1.0, 0.5, [], resolution_event)
	_expect_true(execution.start(&"exec_never", never, never_resolution, bindings) != null, "never-interrupt action starts")
	_expect_false(execution.can_interrupt(&"exec_never"), "NEVER action cannot interrupt before commit")
	_expect_false(execution.interrupt(&"exec_never"), "NEVER interruption rejected")
	_expect_true(execution.advance(&"exec_never", 1.0).completed, "NEVER action completes normally")
	_expect_equal(String(activity.active_execution_id()), "", "completed execution no longer active")
	_expect_equal(execution.prune_terminal().value.size(), 1, "completed execution prunes")

	var anytime = ActionDefinition.new(
		DomainId.action(&"pour"),
		[&"actor", &"target"],
		requirements,
		ActionDefinition.InterruptionClass.ANYTIME
	)
	var anytime_resolution = ActionResolutionDefinition.new(anytime.id, 2.0, 0.5, [], resolution_event)
	_expect_true(execution.start(&"exec_any", anytime, anytime_resolution, bindings) != null, "ANYTIME action starts")
	var committed = execution.advance(&"exec_any", 1.0)
	_expect_true(committed.committed and committed.new_outcome != null, "ANYTIME action emits commit outcome")
	_expect_true(execution.can_interrupt(&"exec_any"), "ANYTIME action remains interruptible after commit")
	_expect_true(execution.interrupt(&"exec_any"), "post-commit interruption succeeds without rewind")
	var interrupted_post = execution.get_state(&"exec_any")
	_expect_true(interrupted_post.committed and interrupted_post.interrupted, "post-commit terminal state retains committed history")
	var after_interrupt = execution.advance(&"exec_any", 1.0)
	_expect_true(after_interrupt.interrupted, "advance reports terminal interruption")
	_expect_true(after_interrupt.new_outcome == null, "post-commit interruption never re-emits outcome")
	_expect_equal(execution.prune_terminal().value.size(), 1, "post-commit interrupted execution prunes")

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
