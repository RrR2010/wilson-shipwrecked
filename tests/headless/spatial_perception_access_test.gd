extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const ContentRegistry = preload("res://src/domain/content/content_registry.gd")
const EntityDefinition = preload("res://src/domain/content/entity_definition.gd")
const EventDefinition = preload("res://src/domain/content/event_definition.gd")
const EntityInstance = preload("res://src/domain/world/entity_instance.gd")
const EntityStore = preload("res://src/domain/world/entity_store.gd")
const WilsonWorldState = preload("res://src/domain/world/wilson_world_state.gd")
const WorldRelationStore = preload("res://src/domain/world/world_relation_store.gd")
const DefaultWorldQuery = preload("res://src/domain/world/default_world_query.gd")
const RoleBinding = preload("res://src/domain/actions/role_binding.gd")
const WorldEvent = preload("res://src/domain/actions/world_event.gd")
const CoarsePerceptionAccessResolver = preload("res://src/application/simulation/coarse_perception_access_resolver.gd")

var _failures: Array[String] = []
var _completed := false


func _init() -> void:
	_run_slice()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS spatial_perception_access_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL spatial_perception_access_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_slice() -> void:
	var camp = DomainId.place(&"camp")
	var beach = DomainId.place(&"beach")
	var crate_type = DomainId.entity_type(&"crate")
	var coconut_type = DomainId.entity_type(&"coconut")
	var bird_type = DomainId.entity_type(&"bird")
	var food = DomainId.category(&"food")
	var graspable = DomainId.capability(&"graspable")
	var impact_event = DomainId.event_definition(&"impact_committed")

	var content = ContentRegistry.new()
	_expect_true(content.register_entity_definition(EntityDefinition.new(crate_type)).ok, "crate definition registers")
	_expect_true(content.register_entity_definition(EntityDefinition.new(coconut_type, [food], {}, [graspable])).ok, "coconut definition registers")
	_expect_true(content.register_entity_definition(EntityDefinition.new(bird_type)).ok, "bird definition registers")
	_expect_true(content.register_event_definition(EventDefinition.new(impact_event, [&"target"], [&"hearing", &"vision"], 0.8)).ok, "event definition registers")
	_expect_true(content.seal().ok, "content seals")

	var entities = EntityStore.new()
	var crate_id = DomainId.entity(&"crate_1")
	var coconut_id = DomainId.entity(&"coconut_1")
	var bird_id = DomainId.entity(&"bird_1")
	_expect_true(entities.add_entity(EntityInstance.new(crate_id, crate_type, camp)).ok, "crate added")
	_expect_true(entities.add_entity(EntityInstance.new(coconut_id, coconut_type, camp)).ok, "coconut added")
	_expect_true(entities.add_entity(EntityInstance.new(bird_id, bird_type, beach)).ok, "bird added")

	var wilson_state = WilsonWorldState.new(camp)
	var query = DefaultWorldQuery.new(entities, WorldRelationStore.new(), content, wilson_state)
	var wilson = RuntimeWorldRef.wilson()
	var crate = RuntimeWorldRef.entity(crate_id)
	var coconut = RuntimeWorldRef.entity(coconut_id)
	var bird = RuntimeWorldRef.entity(bird_id)

	_expect_true(query.are_co_located(wilson, crate), "Wilson co-located with camp crate")
	_expect_false(query.are_co_located(wilson, bird), "Wilson not co-located with beach bird")
	var nearby = query.query_nearby(wilson)
	_expect_equal(nearby.size(), 2, "nearby returns active entities in Wilson place")
	_expect_equal(nearby[0].sort_key(), coconut.sort_key(), "nearby is deterministic")
	_expect_equal(nearby[1].sort_key(), crate.sort_key(), "nearby deterministic second item")
	_expect_equal(query.query_nearby(wilson, {"category_id": food}).size(), 1, "category-filtered nearby query")
	_expect_equal(query.query_nearby(wilson, {"capability_id": graspable}).size(), 1, "capability-filtered nearby query")

	var camp_bindings = RoleBinding.new()
	camp_bindings.bind(&"target", crate)
	var beach_bindings = RoleBinding.new()
	beach_bindings.bind(&"target", bird)
	var camp_event = WorldEvent.new(impact_event, DomainId.action(&"hit"), camp_bindings, &"exec_camp")
	var beach_event = WorldEvent.new(impact_event, DomainId.action(&"hit"), beach_bindings, &"exec_beach")
	var resolver = CoarsePerceptionAccessResolver.new(query)
	var access = resolver.resolve([camp_event, beach_event], null)
	_expect_true(access[&"exec_camp"].observable, "co-located event observable")
	_expect_equal(access[&"exec_camp"].accessible_roles, [&"target"], "only authored perceptible role exposed")
	_expect_equal(access[&"exec_camp"].modalities, [&"hearing", &"vision"], "authored modalities retained deterministically")
	_expect_equal(access[&"exec_camp"].confidence, 0.8, "authored confidence retained")
	_expect_false(access[&"exec_beach"].observable, "remote event not observable in coarse model")

	_expect_true(wilson_state.move_to(beach).ok, "Wilson movement mutates World-owned coarse location")
	_expect_false(query.are_co_located(wilson, crate), "crate becomes remote after move")
	_expect_true(query.are_co_located(wilson, bird), "bird becomes co-located after move")
	var moved_access = resolver.resolve([camp_event, beach_event], null)
	_expect_false(moved_access[&"exec_camp"].observable, "old-place event becomes inaccessible")
	_expect_true(moved_access[&"exec_beach"].observable, "new-place event becomes accessible")

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
