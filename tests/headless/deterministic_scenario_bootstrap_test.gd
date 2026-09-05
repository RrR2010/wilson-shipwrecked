extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const EpistemicClaim = preload("res://src/domain/cognition/epistemic_claim.gd")
const BeliefProposition = preload("res://src/domain/cognition/belief_proposition.gd")
const RoleBinding = preload("res://src/domain/actions/role_binding.gd")
const ContentPackLoader = preload("res://src/infrastructure/content_loading/content_pack_loader.gd")
const EntityBootstrapSeed = preload("res://src/application/bootstrap/entity_bootstrap_seed.gd")
const BeliefBootstrapSeed = preload("res://src/application/bootstrap/belief_bootstrap_seed.gd")
const IntentionBootstrapSeed = preload("res://src/application/bootstrap/intention_bootstrap_seed.gd")
const SimulationBootstrapDefinition = preload("res://src/application/bootstrap/simulation_bootstrap_definition.gd")
const DeterministicScenarioDefinition = preload("res://src/application/bootstrap/deterministic_scenario_definition.gd")
const DeterministicScenarioBootstrapService = preload("res://src/application/bootstrap/deterministic_scenario_bootstrap_service.gd")

var _failures: Array[String] = []
var _completed := false

func _init() -> void:
	_run_tests()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS deterministic_scenario_bootstrap_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL deterministic_scenario_bootstrap_test: %d failure(s)" % _failures.size())
	quit(1)

func _run_tests() -> void:
	_test_named_scenario_builds_fresh_owners_and_runtime()
	_test_duplicate_authoritative_causes_fail_admission()
	_test_same_definition_rebootstrap_is_equivalent()
	_completed = true

func _test_named_scenario_builds_fresh_owners_and_runtime() -> void:
	var loaded = _load_content()
	_expect_true(loaded.ok, "scenario content loads")
	if not loaded.ok:
		return
	var definition = _scenario_definition()
	var result = DeterministicScenarioBootstrapService.new().bootstrap(definition, loaded.value)
	_expect_true(result.ok, "named deterministic scenario bootstraps")
	if not result.ok:
		return
	_expect_equal(result.scenario_name, &"hungry_wilson_near_food", "scenario name remains development metadata")
	_expect_equal(result.gameplay_seed, 424242, "explicit gameplay seed survives bootstrap metadata")
	_expect_equal(result.owners.entities.entities().size(), 1, "bootstrap constructs authoritative entity owner")
	_expect_equal(result.owners.beliefs.entry_count(), 1, "bootstrap reconstructs supplied cognition cause")
	_expect_true(result.owners.current_intention.has_current(), "bootstrap reconstructs supplied intention cause")
	_expect_true(result.runtime != null, "scenario proceeds through normal runtime composition")
	var food_ref = RuntimeWorldRef.entity(DomainId.entity(&"food_1"))
	_expect_equal(result.runtime.world_query.get_instance_property(food_ref, DomainId.property(&"freshness")), 0.75, "runtime query sees bootstrapped World truth")
	_expect_true(result.runtime.activity_query.current_intention().bindings.get_subject(&"target").equals(food_ref), "runtime sees bootstrapped cognition through normal owner")

	# Mutating the declarative seed after bootstrap must not mutate authoritative state.
	definition.simulation.entity_seeds[0].state_overrides[DomainId.property(&"freshness").key()] = 0.1
	_expect_equal(result.runtime.world_query.get_instance_property(food_ref, DomainId.property(&"freshness")), 0.75, "retained seed references cannot mutate bootstrapped World owner")

func _test_duplicate_authoritative_causes_fail_admission() -> void:
	var loaded = _load_content()
	if not loaded.ok:
		return
	var camp = DomainId.place(&"camp")
	var duplicate_id = DomainId.entity(&"food_duplicate")
	var duplicate_definition = SimulationBootstrapDefinition.new(camp, [
		EntityBootstrapSeed.new(duplicate_id, DomainId.entity_type(&"food"), camp),
		EntityBootstrapSeed.new(duplicate_id, DomainId.entity_type(&"food"), camp),
	])
	var scenario = DeterministicScenarioDefinition.new(&"invalid_duplicate_entity", 7, duplicate_definition)
	var result = DeterministicScenarioBootstrapService.new().bootstrap(scenario, loaded.value)
	_expect_false(result.ok, "duplicate authoritative entity cause fails admission")
	_expect_equal(result.code, &"duplicate_entity", "owner admission failure code is preserved")
	_expect_true(result.owners == null and result.runtime == null, "failed bootstrap exposes no partial owners/runtime")

func _test_same_definition_rebootstrap_is_equivalent() -> void:
	var loaded = _load_content()
	if not loaded.ok:
		return
	var definition = _scenario_definition()
	var first = DeterministicScenarioBootstrapService.new().bootstrap(definition, loaded.value)
	var second = DeterministicScenarioBootstrapService.new().bootstrap(definition, loaded.value)
	_expect_true(first.ok and second.ok, "same deterministic definition bootstraps twice")
	if not first.ok or not second.ok:
		return
	_expect_true(first.owners != second.owners, "rebootstrap creates distinct owner carriers")
	_expect_true(first.owners.entities != second.owners.entities, "rebootstrap creates fresh authoritative EntityStore")
	var food_ref = RuntimeWorldRef.entity(DomainId.entity(&"food_1"))
	var first_fingerprint = {
		"freshness": first.runtime.world_query.get_instance_property(food_ref, DomainId.property(&"freshness")),
		"belief_count": first.owners.beliefs.entry_count(),
		"intention": first.runtime.activity_query.current_intention().intention_id.sort_key(),
		"seed": first.gameplay_seed,
	}
	var second_fingerprint = {
		"freshness": second.runtime.world_query.get_instance_property(food_ref, DomainId.property(&"freshness")),
		"belief_count": second.owners.beliefs.entry_count(),
		"intention": second.runtime.activity_query.current_intention().intention_id.sort_key(),
		"seed": second.gameplay_seed,
	}
	_expect_equal(first_fingerprint, second_fingerprint, "same durable causes produce equivalent semantic bootstrap fingerprint")

func _scenario_definition():
	var camp = DomainId.place(&"camp")
	var food_id = DomainId.entity(&"food_1")
	var food_ref = RuntimeWorldRef.entity(food_id)
	var entity_seed = EntityBootstrapSeed.new(
		food_id,
		DomainId.entity_type(&"food"),
		camp,
		0,
		{DomainId.property(&"freshness").key(): 0.75}
	)
	var claim = EpistemicClaim.property_claim(food_ref, DomainId.property(&"freshness"), 0.75)
	var belief_seed = BeliefBootstrapSeed.new(BeliefProposition.new(claim), 0.8, 2, &"exec_observed_food", &"vision")
	var bindings = RoleBinding.new()
	bindings.bind(&"actor", RuntimeWorldRef.wilson())
	bindings.bind(&"target", food_ref)
	var intention_seed = IntentionBootstrapSeed.new(
		DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"seek_food"),
		bindings,
		&"step_fixture_1"
	)
	return DeterministicScenarioDefinition.new(
		&"hungry_wilson_near_food",
		424242,
		SimulationBootstrapDefinition.new(camp, [entity_seed], [], [belief_seed], intention_seed)
	)

func _load_content():
	return ContentPackLoader.new().load_dictionary({
		"schema_version": 1,
		"properties": [
			{"id": "freshness", "family": "number", "min": 0.0, "max": 1.0},
		],
		"entities": [
			{"id": "food", "base_properties": {"freshness": 0.75}, "capabilities": []},
		],
	})

func _expect_true(actual: bool, label: String) -> void:
	if not actual:
		_failures.append("Expected true: %s" % label)

func _expect_false(actual: bool, label: String) -> void:
	if actual:
		_failures.append("Expected false: %s" % label)

func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
