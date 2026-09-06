class_name ProductNewRunGenerator
extends RefCounted

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const EntityBootstrapSeed = preload("res://src/application/bootstrap/entity_bootstrap_seed.gd")
const RelationBootstrapSeed = preload("res://src/application/bootstrap/relation_bootstrap_seed.gd")
const SimulationBootstrapDefinition = preload("res://src/application/bootstrap/simulation_bootstrap_definition.gd")
const NewRunDefinition = preload("res://src/application/bootstrap/new_run_definition.gd")
const ProductNewRunGenerationResult = preload("res://src/application/bootstrap/product_new_run_generation_result.gd")

## Deterministically converts product inputs plus authored generation content into the
## durable causes consumed by the ordinary NewRunBootstrapService boundary.
##
## This service owns no runtime state and never reads scene nodes or transforms.
## Stable semantic sorting occurs before seeded selection so equivalent authored
## sets do not change meaning merely because array insertion order changed.

func generate(parameters, profile, content):
	assert(parameters != null, "generate requires ProductNewRunParameters")
	assert(profile != null, "generate requires ProductWorldGenerationProfile")
	assert(content != null, "generate requires ContentRegistry")
	if not content.is_sealed():
		return ProductNewRunGenerationResult.failure(
			&"generation_content_not_sealed",
			["Product new-run generation requires sealed authored content"] as Array[String]
		)
	if parameters.generation_profile_id != profile.id:
		return ProductNewRunGenerationResult.failure(
			&"generation_profile_mismatch",
			["Requested profile '%s' but received '%s'" % [String(parameters.generation_profile_id), String(profile.id)]] as Array[String]
		)

	var rules: Array = profile.entity_rules.duplicate()
	rules.sort_custom(func(a, b): return String(a.id_prefix) < String(b.id_prefix))
	for rule in rules:
		if not content.has_entity_definition(rule.type_id):
			return ProductNewRunGenerationResult.failure(
				&"generation_missing_entity_definition",
				["Generation rule '%s' references missing authored type %s" % [String(rule.id_prefix), rule.type_id.sort_key()]] as Array[String]
			)

	var rng := RandomNumberGenerator.new()
	rng.seed = parameters.gameplay_seed
	var start_places := _sorted_places(profile.wilson_start_places)
	var wilson_place = start_places[rng.randi_range(0, start_places.size() - 1)]
	var entity_seeds: Array = []
	var entity_keys: Dictionary = {}
	var generated_by_prefix: Dictionary = {}

	for rule in rules:
		var count: int = rng.randi_range(rule.min_count, rule.max_count)
		var candidate_places := _sorted_places(rule.candidate_places)
		var generated_for_rule: Array = []
		for index in range(count):
			var entity_id = DomainId.entity(StringName("%s_%03d" % [String(rule.id_prefix), index + 1]))
			if entity_keys.has(entity_id.key()):
				return ProductNewRunGenerationResult.failure(
					&"duplicate_generated_entity_id",
					["Generated duplicate entity id: %s" % entity_id.sort_key()] as Array[String]
				)
			entity_keys[entity_id.key()] = true
			var place_id = candidate_places[rng.randi_range(0, candidate_places.size() - 1)]
			entity_seeds.append(EntityBootstrapSeed.new(
				entity_id,
				rule.type_id,
				place_id,
				rule.lifecycle,
				rule.state_overrides,
				rule.quantity
			))
			generated_for_rule.append(entity_id)
		generated_by_prefix[rule.id_prefix] = generated_for_rule

	var relation_seeds: Array = []
	var relation_rules: Array = profile.relation_rules.duplicate()
	relation_rules.sort_custom(func(a, b): return String(a.id) < String(b.id))
	for relation_rule in relation_rules:
		var subjects: Array = generated_by_prefix.get(relation_rule.subject_prefix, []).duplicate()
		var objects: Array = generated_by_prefix.get(relation_rule.object_prefix, []).duplicate()
		subjects.sort_custom(func(a, b): return a.sort_key() < b.sort_key())
		objects.sort_custom(func(a, b): return a.sort_key() < b.sort_key())
		var candidates: Array = []
		for subject_id in subjects:
			for object_id in objects:
				if subject_id.equals(object_id):
					continue
				candidates.append([subject_id, object_id])
		var relation_count: int = rng.randi_range(relation_rule.min_count, relation_rule.max_count)
		if relation_count > candidates.size():
			var diagnostics: Array[String] = [
				"Relation rule '%s' requests %d unique relation(s) but only %d candidate pair(s) exist" % [
					String(relation_rule.id),
					relation_count,
					candidates.size(),
				]
			]
			return ProductNewRunGenerationResult.failure(
				&"insufficient_generated_relation_candidates",
				diagnostics
			)
		for _index in range(relation_count):
			var selected_index: int = rng.randi_range(0, candidates.size() - 1)
			var selected: Array = candidates[selected_index]
			candidates.remove_at(selected_index)
			relation_seeds.append(RelationBootstrapSeed.new(
				relation_rule.relation_type,
				RuntimeWorldRef.entity(selected[0]),
				RuntimeWorldRef.entity(selected[1]),
				relation_rule.qualifier
			))

	var simulation = SimulationBootstrapDefinition.new(
		wilson_place,
		entity_seeds,
		relation_seeds,
		[],
		null,
		1.0,
		profile.initial_drive_values,
		[],
		[],
		[],
		[],
		null,
		profile.environment_weather,
		profile.environment_daylight_phase
	)
	return ProductNewRunGenerationResult.success(NewRunDefinition.new(
		parameters.run_id,
		parameters.gameplay_seed,
		simulation,
		parameters.initial_god_power,
		parameters.initial_permissions
	))


func _sorted_places(source: Array) -> Array:
	var result := source.duplicate()
	result.sort_custom(func(a, b): return a.sort_key() < b.sort_key())
	return result
