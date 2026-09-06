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
			["Product new-run generation requires sealed authored content"]
		)
	if parameters.generation_profile_id != profile.id:
		return ProductNewRunGenerationResult.failure(
			&"generation_profile_mismatch",
			["Requested profile '%s' but received '%s'" % [String(parameters.generation_profile_id), String(profile.id)]]
		)

	var rules: Array = profile.entity_rules.duplicate()
	rules.sort_custom(func(a, b): return String(a.id_prefix) < String(b.id_prefix))
	for rule in rules:
		if not content.has_entity_definition(rule.type_id):
			return ProductNewRunGenerationResult.failure(
				&"generation_missing_entity_definition",
				["Generation rule '%s' references missing authored type %s" % [String(rule.id_prefix), rule.type_id.sort_key()]]
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
		var generated_ids: Array = []
		for index in range(count):
			var entity_id = DomainId.entity(StringName("%s_%03d" % [String(rule.id_prefix), index + 1]))
			if entity_keys.has(entity_id.key()):
				return ProductNewRunGenerationResult.failure(
					&"duplicate_generated_entity_id",
					["Generated duplicate entity id: %s" % entity_id.sort_key()]
				)
			entity_keys[entity_id.key()] = true
			generated_ids.append(entity_id)
			var place_id = candidate_places[rng.randi_range(0, candidate_places.size() - 1)]
			entity_seeds.append(EntityBootstrapSeed.new(
				entity_id,
				rule.type_id,
				place_id,
				rule.lifecycle,
				rule.state_overrides,
				rule.quantity
			))
		generated_by_prefix[rule.id_prefix] = generated_ids

	var relation_result := _generate_relations(profile.relation_rules, generated_by_prefix, rng)
	if not relation_result.ok:
		return ProductNewRunGenerationResult.failure(relation_result.code, relation_result.diagnostics)

	var simulation = SimulationBootstrapDefinition.new(
		wilson_place,
		entity_seeds,
		relation_result.seeds,
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


func _generate_relations(source_rules: Array, generated_by_prefix: Dictionary, rng: RandomNumberGenerator) -> Dictionary:
	var rules := source_rules.duplicate()
	rules.sort_custom(func(a, b): return a.sort_key() < b.sort_key())
	var seeds: Array = []
	for rule in rules:
		if not generated_by_prefix.has(rule.subject_prefix) or not generated_by_prefix.has(rule.object_prefix):
			return _relation_failure(
				&"generation_relation_unknown_entity_family",
				["Relation rule '%s' references an unknown generated entity family" % String(rule.id)]
			)
		var subjects: Array = generated_by_prefix[rule.subject_prefix]
		var objects: Array = generated_by_prefix[rule.object_prefix]
		var pairs: Array = []
		for subject_id in subjects:
			for object_id in objects:
				if subject_id.equals(object_id):
					continue
				pairs.append([subject_id, object_id])
		pairs.sort_custom(func(a, b): return "%s|%s" % [a[0].sort_key(), a[1].sort_key()] < "%s|%s" % [b[0].sort_key(), b[1].sort_key()])
		if rule.max_count > pairs.size():
			return _relation_failure(
				&"generation_relation_insufficient_candidates",
				["Relation rule '%s' allows %d relations but only %d unique pairs exist" % [String(rule.id), rule.max_count, pairs.size()]]
			)
		var count := rng.randi_range(rule.min_count, rule.max_count)
		_shuffle(pairs, rng)
		for index in range(count):
			var pair: Array = pairs[index]
			seeds.append(RelationBootstrapSeed.new(
				rule.relation_type,
				RuntimeWorldRef.entity(pair[0]),
				RuntimeWorldRef.entity(pair[1]),
				rule.qualifier
			))
	return {"ok": true, "code": &"generated_relations_valid", "diagnostics": [], "seeds": seeds}


func _relation_failure(code: StringName, diagnostics: Array) -> Dictionary:
	return {"ok": false, "code": code, "diagnostics": diagnostics, "seeds": []}


func _shuffle(values: Array, rng: RandomNumberGenerator) -> void:
	for index in range(values.size() - 1, 0, -1):
		var swap_index := rng.randi_range(0, index)
		var value = values[index]
		values[index] = values[swap_index]
		values[swap_index] = value


func _sorted_places(source: Array) -> Array:
	var result := source.duplicate()
	result.sort_custom(func(a, b): return a.sort_key() < b.sort_key())
	return result
