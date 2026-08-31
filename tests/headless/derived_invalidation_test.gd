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
const PropertyDerivationDefinition = preload("res://src/domain/physical/property_derivation_definition.gd")
const PropertyDependencyGraph = preload("res://src/domain/physical/property_dependency_graph.gd")
const PhysicalDerivationPolicyRegistry = preload("res://src/domain/physical/physical_derivation_policy_registry.gd")
const EffectivePhysicalProfileResolver = preload("res://src/domain/physical/effective_physical_profile_resolver.gd")
const ActionEffect = preload("res://src/domain/actions/action_effect.gd")
const ActionOutcome = preload("res://src/domain/actions/action_outcome.gd")
const RoleBinding = preload("res://src/domain/actions/role_binding.gd")
const DerivedStateInvalidator = preload("res://src/application/simulation/derived_state_invalidator.gd")

var _failures: Array[String] = []
var _completed := false

func _init() -> void:
	_run_slice()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS derived_invalidation_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL derived_invalidation_test: %d failure(s)" % _failures.size())
	quit(1)

func _run_slice() -> void:
	var tool_type = DomainId.entity_type(&"tool")
	var tool_id = DomainId.entity(&"tool_1")
	var camp = DomainId.place(&"camp")
	var hardness = DomainId.property(&"hardness")
	var integrity = DomainId.property(&"structural_integrity")
	var resistance = DomainId.property(&"effective_resistance")

	var content = ContentRegistry.new()
	_expect_true(content.register_entity_definition(EntityDefinition.new(
		tool_type, [], {hardness.key(): 4, integrity.key(): 3}, []
	)).ok, "tool definition registers")
	_expect_true(content.seal().ok, "content seals")

	var entities = EntityStore.new()
	_expect_true(entities.add_entity(EntityInstance.new(tool_id, tool_type, camp)).ok, "tool instance added")
	var subject = RuntimeWorldRef.entity(tool_id)
	var relations = WorldRelationStore.new()
	var query = DefaultWorldQuery.new(entities, relations, content)
	var policies = PhysicalDerivationPolicyRegistry.new()
	var graph = PropertyDependencyGraph.new()
	var rule = PropertyDerivationDefinition.new(&"resistance_v1", [hardness, integrity], resistance, &"min_numeric")
	_expect_true(graph.compile([rule], policies).ok, "property graph compiles")
	var resolver = EffectivePhysicalProfileResolver.new(query, graph, policies)
	var invalidator = DerivedStateInvalidator.new(resolver)

	_expect_equal(resolver.resolve(subject).get_property(resistance), 3, "initial derived value cached")
	_expect_equal(resolver.cached_subject_count(), 1, "subject cache populated")

	var bindings = RoleBinding.new()
	bindings.bind(&"target", subject)
	var outcome = ActionOutcome.new(
		&"exec_change_1",
		DomainId.action(&"damage"),
		bindings,
		[ActionEffect.new(ActionEffect.Kind.SET_PROPERTY, &"target", integrity, 1)],
		DomainId.event_definition(&"damage_committed")
	)
	var commit = DefaultWorldCommandPort.new(entities, relations).apply_outcome(outcome)
	_expect_true(commit.ok, "World commit succeeds")
	_expect_equal(commit.change_set.changes.size(), 1, "World reports one semantic change")
	_expect_equal(resolver.resolve(subject).get_property(resistance), 3, "cached derived value remains stale before invalidation")

	var invalidation = invalidator.apply(commit.change_set)
	_expect_equal(invalidation.size(), 1, "one change invalidated")
	_expect_equal(resolver.cached_subject_count(), 0, "derived cache discarded")
	_expect_equal(resolver.resolve(subject).get_property(resistance), 1, "derived value recomputes from new World truth")

	_completed = true

func _expect_true(actual: bool, label: String) -> void:
	if not actual:
		_failures.append("Expected true: %s" % label)

func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
