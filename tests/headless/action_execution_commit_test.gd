extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const ContentRegistry = preload("res://src/domain/content/content_registry.gd")
const EntityDefinition = preload("res://src/domain/content/entity_definition.gd")
const EntityInstance = preload("res://src/domain/world/entity_instance.gd")
const EntityStore = preload("res://src/domain/world/entity_store.gd")
const WorldRelationStore = preload("res://src/domain/world/world_relation_store.gd")
const DefaultWorldQuery = preload("res://src/domain/world/default_world_query.gd")
const DefaultWorldCommandPort = preload("res://src/domain/world/default_world_command_port.gd")
const PropertyDependencyGraph = preload("res://src/domain/physical/property_dependency_graph.gd")
const EffectivePhysicalProfileResolver = preload("res://src/domain/physical/effective_physical_profile_resolver.gd")
const RequirementPredicate = preload("res://src/domain/actions/requirement_predicate.gd")
const RequirementPredicateEvaluator = preload("res://src/domain/actions/requirement_predicate_evaluator.gd")
const RoleBinding = preload("res://src/domain/actions/role_binding.gd")
const ActionDefinition = preload("res://src/domain/actions/action_definition.gd")
const ActionAttemptabilityService = preload("res://src/domain/actions/action_attemptability_service.gd")
const ActionEffect = preload("res://src/domain/actions/action_effect.gd")
const ActionResolutionDefinition = preload("res://src/domain/actions/action_resolution_definition.gd")
const ActionExecutionService = preload("res://src/domain/actions/action_execution_service.gd")

var _failures: Array[String] = []
var _completed := false


func _init() -> void:
	_run_slice()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS action_execution_commit_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL action_execution_commit_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_slice() -> void:
	var stone_type = DomainId.entity_type(&"stone_small")
	var crate_type = DomainId.entity_type(&"crate")
	var integrity = DomainId.property(&"structural_integrity")
	var impact_surface = DomainId.capability(&"impact_surface")
	var receives_impact = DomainId.capability(&"receives_impact")
	var camp = DomainId.place(&"camp")

	var content = ContentRegistry.new()
	_expect_true(content.register_entity_definition(EntityDefinition.new(stone_type, [], {}, [impact_surface])).ok, "stone definition registers")
	_expect_true(content.register_entity_definition(EntityDefinition.new(crate_type, [], {integrity.key(): 5}, [receives_impact])).ok, "crate definition registers")
	_expect_true(content.seal().ok, "content seals")

	var entities = EntityStore.new()
	var stone_id = DomainId.entity(&"stone_42")
	var crate_id = DomainId.entity(&"crate_4")
	_expect_true(entities.add_entity(EntityInstance.new(stone_id, stone_type, camp)).ok, "stone instance added")
	_expect_true(entities.add_entity(EntityInstance.new(crate_id, crate_type, camp)).ok, "crate instance added")

	var stone = RuntimeWorldRef.entity(stone_id)
	var crate = RuntimeWorldRef.entity(crate_id)
	var wilson = RuntimeWorldRef.wilson()
	var relations = WorldRelationStore.new()
	var world_query = DefaultWorldQuery.new(entities, relations, content)
	var graph = PropertyDependencyGraph.new()
	_expect_true(graph.compile([]).ok, "empty property graph compiles")
	var profiles = EffectivePhysicalProfileResolver.new(world_query, graph)
	var evaluator = RequirementPredicateEvaluator.new(world_query, profiles)

	var requirements = RequirementPredicate.all_of([
		RequirementPredicate.has_capability(&"tool", impact_surface),
		RequirementPredicate.has_capability(&"target", receives_impact),
	])
	var hit = ActionDefinition.new(DomainId.action(&"hit"), [&"actor", &"tool", &"target"], requirements)
	var bindings = RoleBinding.new()
	bindings.bind(&"actor", wilson)
	bindings.bind(&"tool", stone)
	bindings.bind(&"target", crate)

	var effect = ActionEffect.new(ActionEffect.Kind.SET_PROPERTY, &"target", integrity, 3)
	var resolution = ActionResolutionDefinition.new(hit.id, 1.0, 0.5, [effect], &"impact_landed")
	var attemptability = ActionAttemptabilityService.new(evaluator)
	var execution = ActionExecutionService.new(attemptability)
	var world_commands = DefaultWorldCommandPort.new(entities, relations)

	var first = execution.start(&"hit_interruptible", hit, resolution, bindings)
	_expect_true(first != null, "attemptable action starts")
	var first_progress = execution.advance(&"hit_interruptible", 0.4)
	_expect_false(first_progress.committed, "action remains uncommitted before checkpoint")
	_expect_true(first_progress.new_outcome == null, "no outcome before checkpoint")
	_expect_true(execution.can_interrupt(&"hit_interruptible"), "uncommitted action can interrupt")
	_expect_true(execution.interrupt(&"hit_interruptible"), "interrupt succeeds before commit")
	_expect_equal(world_query.get_instance_property(crate, integrity), 5, "interrupt before commit leaves world unchanged")

	var second = execution.start(&"hit_committed", hit, resolution, bindings)
	_expect_true(second != null, "second action starts")
	var before_commit = execution.advance(&"hit_committed", 0.49)
	_expect_false(before_commit.committed, "checkpoint not crossed early")
	_expect_true(before_commit.new_outcome == null, "no premature outcome")
	_expect_equal(world_query.get_instance_property(crate, integrity), 5, "execution alone does not mutate world")

	var at_commit = execution.advance(&"hit_committed", 0.02)
	_expect_true(at_commit.committed, "checkpoint crossing commits execution")
	_expect_true(at_commit.new_outcome != null, "checkpoint emits outcome exactly once")
	_expect_false(execution.can_interrupt(&"hit_committed"), "committed action cannot interrupt")
	_expect_false(execution.interrupt(&"hit_committed"), "interrupt cannot undo committed action")
	_expect_equal(world_query.get_instance_property(crate, integrity), 5, "committed outcome still requires World owner application")

	var commit = world_commands.apply_outcome(at_commit.new_outcome)
	_expect_true(commit.ok, "World owner commits outcome")
	_expect_equal(commit.mutation_results.size(), 1, "one world mutation committed")
	_expect_equal(commit.events.size(), 1, "event published after successful commit")
	if commit.events.size() == 1:
		_expect_equal(commit.events[0].event_type.kind, DomainId.Kind.EVENT_DEFINITION, "committed event uses EventDefinitionId")
		_expect_equal(String(commit.events[0].event_type.value), "impact_landed", "committed event type")
	_expect_equal(world_query.get_instance_property(crate, integrity), 3, "World mutation visible after commit")

	var completed = execution.advance(&"hit_committed", 0.49)
	_expect_true(completed.completed, "action completes after duration")
	_expect_true(completed.new_outcome == null, "outcome is not emitted twice")
	_expect_equal(world_query.get_instance_property(crate, integrity), 3, "completion does not replay mutation")

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
