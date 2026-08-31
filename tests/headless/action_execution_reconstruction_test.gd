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
const PhysicalDerivationPolicyRegistry = preload("res://src/domain/physical/physical_derivation_policy_registry.gd")
const EffectivePhysicalProfileResolver = preload("res://src/domain/physical/effective_physical_profile_resolver.gd")
const RequirementPredicate = preload("res://src/domain/actions/requirement_predicate.gd")
const RequirementPredicateEvaluator = preload("res://src/domain/actions/requirement_predicate_evaluator.gd")
const ActionDefinition = preload("res://src/domain/actions/action_definition.gd")
const ActionAttemptabilityService = preload("res://src/domain/actions/action_attemptability_service.gd")
const ActionExecutionService = preload("res://src/domain/actions/action_execution_service.gd")
const ActionResolutionDefinition = preload("res://src/domain/actions/action_resolution_definition.gd")
const RoleBinding = preload("res://src/domain/actions/role_binding.gd")
const ActionExecutionSnapshotService = preload("res://src/infrastructure/persistence/action_execution_snapshot_service.gd")

var _failures: Array[String] = []
var _completed := false


func _init() -> void:
	_run_slice()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS action_execution_reconstruction_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL action_execution_reconstruction_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_slice() -> void:
	var crate_type = DomainId.entity_type(&"crate")
	var crate_id = DomainId.entity(&"crate_4")
	var camp = DomainId.place(&"camp")
	var action_id = DomainId.action(&"inspect")
	var action = ActionDefinition.new(action_id, [&"actor", &"target"], RequirementPredicate.all_of([]))
	var resolution = ActionResolutionDefinition.new(
		action_id,
		1.0,
		0.5,
		[],
		DomainId.event_definition(&"inspection_committed"),
		&"inspect_basic_v1"
	)

	var content = ContentRegistry.new()
	_expect_true(content.register_entity_definition(EntityDefinition.new(crate_type, [], {}, [])).ok, "entity definition registers")
	_expect_true(content.register_action_definition(action).ok, "action definition registers")
	_expect_true(content.register_action_resolution_definition(resolution).ok, "resolution definition registers")
	_expect_true(content.seal().ok, "content seals")

	var entities = EntityStore.new()
	_expect_true(entities.add_entity(EntityInstance.new(crate_id, crate_type, camp)).ok, "crate instance added")
	var world_query = DefaultWorldQuery.new(entities, WorldRelationStore.new(), content)
	var policies = PhysicalDerivationPolicyRegistry.new()
	var graph = PropertyDependencyGraph.new()
	_expect_true(graph.compile([], policies).ok, "empty property graph compiles")
	var profiles = EffectivePhysicalProfileResolver.new(world_query, graph, policies)
	var evaluator = RequirementPredicateEvaluator.new(world_query, profiles)
	var attemptability = ActionAttemptabilityService.new(evaluator)
	var execution = ActionExecutionService.new(attemptability)

	var bindings = RoleBinding.new()
	bindings.bind(&"actor", RuntimeWorldRef.wilson())
	bindings.bind(&"target", RuntimeWorldRef.entity(crate_id))
	_expect_true(execution.start(&"exec_pre", action, resolution, bindings) != null, "pre-commit execution starts")
	_expect_true(execution.start(&"exec_post", action, resolution, bindings) != null, "post-commit execution starts")

	var pre_progress = execution.advance(&"exec_pre", 0.25)
	_expect_true(not pre_progress.committed, "pre-commit execution remains interruptible")
	_expect_true(pre_progress.new_outcome == null, "pre-commit execution emitted no outcome")

	var post_progress = execution.advance(&"exec_post", 0.5)
	_expect_true(post_progress.committed, "post-commit execution crosses checkpoint")
	_expect_true(post_progress.new_outcome != null, "post-commit execution emits original outcome once")

	var persistence = ActionExecutionSnapshotService.new()
	var snapshot = persistence.capture(execution)
	var json_text = JSON.stringify(snapshot)
	_expect_true(not json_text.is_empty(), "action execution snapshot serializes")
	var parsed = JSON.parse_string(json_text)
	_expect_true(parsed is Dictionary, "action execution snapshot parses")
	if not (parsed is Dictionary):
		return

	var restored_execution = ActionExecutionService.new(attemptability)
	var restore_results = persistence.restore(parsed, restored_execution, content)
	_expect_equal(restore_results.size(), 2, "two action executions restore")
	for restore_result in restore_results:
		_expect_true(restore_result != null and restore_result.ok, "restored execution record is valid")

	var restored_pre = restored_execution.get_state(&"exec_pre")
	_expect_true(restored_pre != null, "pre-commit state restored")
	if restored_pre != null:
		_expect_equal(restored_pre.elapsed, 0.25, "pre-commit elapsed survives")
		_expect_true(not restored_pre.committed, "pre-commit state stays uncommitted")
		_expect_true(restored_execution.can_interrupt(&"exec_pre"), "pre-commit state remains interruptible")
	var crossed = restored_execution.advance(&"exec_pre", 0.25)
	_expect_true(crossed.committed, "restored pre-commit execution crosses checkpoint normally")
	_expect_true(crossed.new_outcome != null, "restored pre-commit execution emits outcome at checkpoint")
	var after_cross = restored_execution.advance(&"exec_pre", 0.1)
	_expect_true(after_cross.new_outcome == null, "restored execution does not duplicate emitted outcome")

	var restored_post = restored_execution.get_state(&"exec_post")
	_expect_true(restored_post != null, "post-commit state restored")
	if restored_post != null:
		_expect_equal(restored_post.elapsed, 0.5, "post-commit elapsed survives")
		_expect_true(restored_post.committed, "post-commit state stays committed")
		_expect_true(restored_post.outcome_emitted, "post-commit emitted marker survives")
		_expect_true(not restored_execution.can_interrupt(&"exec_post"), "post-commit state remains non-interruptible")
		_expect_true(not restored_execution.interrupt(&"exec_post"), "post-commit state cannot be rewound by interruption")
	var completed = restored_execution.advance(&"exec_post", 0.5)
	_expect_true(completed.completed, "post-commit execution can finish after restore")
	_expect_true(completed.new_outcome == null, "post-commit execution never reemits committed outcome")

	_completed = true


func _expect_true(actual: bool, label: String) -> void:
	if not actual:
		_failures.append("Expected true: %s" % label)


func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
