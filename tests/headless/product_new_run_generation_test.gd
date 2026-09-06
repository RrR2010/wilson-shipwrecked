extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const ContentRegistry = preload("res://src/domain/content/content_registry.gd")
const DriveState = preload("res://src/domain/cognition/drive_state.gd")
const ProductNewRunParameters = preload("res://src/application/bootstrap/product_new_run_parameters.gd")
const ProductEntityGenerationRule = preload("res://src/application/bootstrap/product_entity_generation_rule.gd")
const ProductWorldGenerationProfile = preload("res://src/application/bootstrap/product_world_generation_profile.gd")
const ProductNewRunGenerator = preload("res://src/application/bootstrap/product_new_run_generator.gd")
const NewRunBootstrapService = preload("res://src/application/bootstrap/new_run_bootstrap_service.gd")

var _failures: Array[String] = []
var _completed := false


func _init() -> void:
	_run_slice()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS product_new_run_generation_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL product_new_run_generation_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_slice() -> void:
	var beach_a = DomainId.place(&"beach_a")
	var beach_b = DomainId.place(&"beach_b")
	var grove = DomainId.place(&"grove")
	var food_rule = ProductEntityGenerationRule.new(
		&"food",
		DomainId.entity_type(&"coconut"),
		[beach_a, beach_b, grove],
		2,
		4
	)
	var stone_rule = ProductEntityGenerationRule.new(
		&"stone",
		DomainId.entity_type(&"stone"),
		[beach_a, beach_b],
		1,
		3
	)
	var profile = ProductWorldGenerationProfile.new(
		&"tropical_baseline",
		[beach_a, beach_b],
		[food_rule, stone_rule],
		{DriveState.HUNGER: 0.4},
		&"clear",
		&"day"
	)
	var parameters = ProductNewRunParameters.new(
		&"run_product_001",
		48151623,
		&"tropical_baseline",
		2.5,
		[&"move_small_object"]
	)
	var generator = ProductNewRunGenerator.new()
	var first = generator.generate(parameters, profile)
	var second = generator.generate(parameters, profile)

	_expect_true(first.ok, "first product generation succeeds")
	_expect_true(second.ok, "equivalent product generation succeeds")
	if not first.ok or not second.ok:
		_completed = true
		return

	_expect_equal(first.code, &"product_new_run_generated", "generation success code")
	_expect_equal(first.definition.run_id, parameters.run_id, "run id reaches NewRunDefinition")
	_expect_equal(first.definition.gameplay_seed, parameters.gameplay_seed, "gameplay seed reaches NewRunDefinition")
	_expect_equal(first.definition.initial_god_power, 2.5, "God Power reaches NewRunDefinition")
	_expect_equal(first.definition.initial_permissions, [&"move_small_object"], "permissions reach NewRunDefinition")
	_expect_true(
		first.definition.simulation.wilson_place_id.equals(second.definition.simulation.wilson_place_id),
		"same inputs and seed reproduce Wilson start place"
	)
	_expect_equal(
		_entity_signature(first.definition.simulation.entity_seeds),
		_entity_signature(second.definition.simulation.entity_seeds),
		"same inputs and seed reproduce generated entity causes"
	)
	_expect_true(
		first.definition.simulation.entity_seeds.size() >= 3 and first.definition.simulation.entity_seeds.size() <= 7,
		"generated entity count remains within authored bounds"
	)

	var variation_seen := false
	var baseline_signature = _definition_signature(first.definition)
	for seed in [48151624, 48151625, 48151626, 48151627, 48151628, 48151629, 48151630, 48151631]:
		var variant_parameters = ProductNewRunParameters.new(&"run_variant", seed, &"tropical_baseline")
		var variant = generator.generate(variant_parameters, profile)
		_expect_true(variant.ok, "seed population generates valid definition for seed %d" % seed)
		if not variant.ok:
			continue
		var count = variant.definition.simulation.entity_seeds.size()
		_expect_true(count >= 3 and count <= 7, "seed %d respects entity-count bounds" % seed)
		if _definition_signature(variant.definition) != baseline_signature:
			variation_seen = true
	_expect_true(variation_seen, "nearby deterministic seeds produce bounded semantic variation")

	var content = ContentRegistry.new()
	_expect_true(content.seal().ok, "empty authored runtime content seals")
	var bootstrap = NewRunBootstrapService.new().bootstrap(first.definition, content)
	_expect_true(bootstrap.ok, "generated NewRunDefinition passes ordinary new-run bootstrap")
	if bootstrap.ok:
		_expect_equal(bootstrap.run_id, &"run_product_001", "bootstrap preserves generated run identity")
		_expect_equal(bootstrap.owners.entities.all_entities().size(), first.definition.simulation.entity_seeds.size(), "bootstrap admits every generated entity cause")
		_expect_equal(bootstrap.owners.drives.value(DriveState.HUNGER), 0.4, "generated drive causes reach cognition owner")

	var mismatched = generator.generate(
		ProductNewRunParameters.new(&"run_bad_profile", 1, &"other_profile"),
		profile
	)
	_expect_true(not mismatched.ok, "profile mismatch fails explicitly")
	_expect_equal(mismatched.code, &"generation_profile_mismatch", "profile mismatch reports stable code")

	var duplicate_profile = ProductWorldGenerationProfile.new(
		&"duplicate_ids",
		[beach_a],
		[
			ProductEntityGenerationRule.new(&"same", DomainId.entity_type(&"coconut"), [beach_a], 1, 1),
			ProductEntityGenerationRule.new(&"same", DomainId.entity_type(&"stone"), [beach_a], 1, 1),
		]
	)
	var duplicate = generator.generate(
		ProductNewRunParameters.new(&"run_duplicate", 12, &"duplicate_ids"),
		duplicate_profile
	)
	_expect_true(not duplicate.ok, "invalid generated duplicate identity fails explicitly")
	_expect_equal(duplicate.code, &"duplicate_generated_entity_id", "duplicate generation reports stable code")

	_completed = true


func _entity_signature(seeds: Array) -> Array[String]:
	var signature: Array[String] = []
	for seed in seeds:
		signature.append("%s|%s|%s" % [seed.id.sort_key(), seed.type_id.sort_key(), seed.place_id.sort_key()])
	return signature


func _definition_signature(definition) -> String:
	return "%s::%s" % [definition.simulation.wilson_place_id.sort_key(), ",".join(_entity_signature(definition.simulation.entity_seeds))]


func _expect_true(actual: bool, label: String) -> void:
	if not actual:
		_failures.append("Expected true: %s" % label)


func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
