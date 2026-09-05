extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const ContentRegistry = preload("res://src/domain/content/content_registry.gd")
const EntityDefinition = preload("res://src/domain/content/entity_definition.gd")
const EventDefinition = preload("res://src/domain/content/event_definition.gd")
const EntityInstance = preload("res://src/domain/world/entity_instance.gd")
const EntityStore = preload("res://src/domain/world/entity_store.gd")
const WorldRelationStore = preload("res://src/domain/world/world_relation_store.gd")
const WilsonWorldState = preload("res://src/domain/world/wilson_world_state.gd")
const BeliefStore = preload("res://src/domain/cognition/belief_store.gd")
const CurrentIntentionStore = preload("res://src/domain/cognition/current_intention_store.gd")
const RequirementPredicate = preload("res://src/domain/actions/requirement_predicate.gd")
const ActionDefinition = preload("res://src/domain/actions/action_definition.gd")
const ActionResolutionDefinition = preload("res://src/domain/actions/action_resolution_definition.gd")
const RoleBinding = preload("res://src/domain/actions/role_binding.gd")
const RunRuntimeComposer = preload("res://src/application/simulation/run_runtime_composer.gd")
const SimulationSnapshotService = preload("res://src/infrastructure/persistence/simulation_snapshot_service.gd")
const ActionExecutionSnapshotService = preload("res://src/infrastructure/persistence/action_execution_snapshot_service.gd")
const RunRuntimeRestoreService = preload("res://src/infrastructure/persistence/run_runtime_restore_service.gd")

var _failures: Array[String] = []
var _completed := false


func _init() -> void:
	_run()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS run_runtime_restore_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL run_runtime_restore_test: %d failure(s)" % _failures.size())
	quit(1)


func _run() -> void:
	var camp = DomainId.place(&"restore_camp")
	var crate_type = DomainId.entity_type(&"restore_crate")
	var crate_id = DomainId.entity(&"restore_crate_1")
	var action_id = DomainId.action(&"inspect_restore_crate")
	var event_id = DomainId.event_definition(&"restore_inspection_committed")
	var action = ActionDefinition.new(
		action_id,
		[&"actor", &"target"],
		RequirementPredicate.all_of([])
	)
	var resolution = ActionResolutionDefinition.new(
		action_id,
		1.0,
		0.5,
		[],
		event_id,
		&"inspect_restore_basic_v1"
	)

	var content = ContentRegistry.new()
	_expect_true(content.register_entity_definition(EntityDefinition.new(crate_type, [], {}, [])).ok, "entity definition registers")
	_expect_true(content.register_event_definition(EventDefinition.new(event_id, [&"target"], [&"vision"])).ok, "event definition registers")
	_expect_true(content.register_action_definition(action).ok, "action definition registers")
	_expect_true(content.register_action_resolution_definition(resolution).ok, "resolution definition registers")
	_expect_true(content.seal().ok, "content seals")

	var entities = EntityStore.new()
	_expect_true(entities.add_entity(EntityInstance.new(crate_id, crate_type, camp)).ok, "crate entity admitted")
	var relations = WorldRelationStore.new()
	var wilson_world = WilsonWorldState.new(camp)
	var beliefs = BeliefStore.new()
	var intentions = CurrentIntentionStore.new()

	var original_composition_result = RunRuntimeComposer.new().compose(
		entities,
		relations,
		wilson_world,
		beliefs,
		intentions,
		content
	)
	_expect_true(original_composition_result.ok, "original runtime composes")
	if not original_composition_result.ok:
		_completed = true
		return
	var original_runtime = original_composition_result.composition

	var bindings = RoleBinding.new()
	bindings.bind(&"actor", RuntimeWorldRef.wilson())
	bindings.bind(&"target", RuntimeWorldRef.entity(crate_id))
	_expect_true(original_runtime.action_execution.start(&"restore_pre", action, resolution, bindings) != null, "pre-commit execution starts")
	_expect_true(original_runtime.action_execution.start(&"restore_post", action, resolution, bindings) != null, "post-commit execution starts")
	var pre_progress = original_runtime.action_execution.advance(&"restore_pre", 0.25)
	_expect_true(not pre_progress.committed, "pre-commit fixture remains before checkpoint")
	var post_progress = original_runtime.action_execution.advance(&"restore_post", 0.5)
	_expect_true(post_progress.committed and post_progress.new_outcome != null, "post-commit fixture emits original outcome")

	var simulation_snapshot = SimulationSnapshotService.new().capture(
		entities,
		relations,
		wilson_world,
		beliefs,
		intentions
	)
	var action_snapshot = ActionExecutionSnapshotService.new().capture(original_runtime.action_execution)
	var parsed_simulation = JSON.parse_string(JSON.stringify(simulation_snapshot))
	var parsed_actions = JSON.parse_string(JSON.stringify(action_snapshot))
	_expect_true(parsed_simulation is Dictionary, "simulation snapshot survives JSON boundary")
	_expect_true(parsed_actions is Dictionary, "action snapshot survives JSON boundary")
	if not (parsed_simulation is Dictionary) or not (parsed_actions is Dictionary):
		_completed = true
		return

	var restore_result = RunRuntimeRestoreService.new().restore(
		parsed_simulation,
		parsed_actions,
		content
	)
	_expect_true(restore_result.ok, "composed runtime restore succeeds")
	if not restore_result.ok:
		_completed = true
		return

	_expect_true(restore_result.simulation.entities != entities, "simulation owners are freshly reconstructed")
	_expect_true(restore_result.runtime != original_runtime, "runtime composition is freshly reconstructed")
	_expect_true(restore_result.runtime.action_execution != original_runtime.action_execution, "ActionExecutionService is freshly reconstructed")
	_expect_equal(restore_result.action_restore_results.size(), 2, "both action executions restore into composed runtime")

	var restored_pre = restore_result.runtime.action_execution.get_state(&"restore_pre")
	var restored_post = restore_result.runtime.action_execution.get_state(&"restore_post")
	_expect_true(restored_pre != null and restored_post != null, "restored action states belong to composed runtime")
	if restored_pre == null or restored_post == null:
		_completed = true
		return
	_expect_float(restored_pre.elapsed, 0.25, "pre-commit elapsed survives composed restore")
	_expect_true(not restored_pre.committed and not restored_pre.outcome_emitted, "pre-commit causal markers survive")
	_expect_float(restored_post.elapsed, 0.5, "post-commit elapsed survives composed restore")
	_expect_true(restored_post.committed and restored_post.outcome_emitted, "post-commit causal markers survive")

	var crossed = restore_result.runtime.action_execution.advance(&"restore_pre", 0.25)
	_expect_true(crossed.committed and crossed.new_outcome != null, "restored pre-commit execution can cross checkpoint once")
	var finished = restore_result.runtime.action_execution.advance(&"restore_post", 0.5)
	_expect_true(finished.completed, "restored post-commit execution can finish")
	_expect_true(finished.new_outcome == null, "restored post-commit execution does not duplicate committed outcome")

	_expect_float(original_runtime.action_execution.get_state(&"restore_pre").elapsed, 0.25, "restored runtime progression does not mutate original runtime")
	_expect_float(original_runtime.action_execution.get_state(&"restore_post").elapsed, 0.5, "restored completion does not mutate original runtime")

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
