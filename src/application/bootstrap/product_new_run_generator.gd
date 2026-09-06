class_name ProductNewRunGenerator
extends RefCounted

const DomainId = preload("res://src/domain/core/domain_id.gd")
const EntityBootstrapSeed = preload("res://src/application/bootstrap/entity_bootstrap_seed.gd")
const SimulationBootstrapDefinition = preload("res://src/application/bootstrap/simulation_bootstrap_definition.gd")
const NewRunDefinition = preload("res://src/application/bootstrap/new_run_definition.gd")
const ProductNewRunGenerationResult = preload("res://src/application/bootstrap/product_new_run_generation_result.gd")

## Deterministically converts product inputs plus authored generation content into the
## durable causes consumed by the ordinary NewRunBootstrapService boundary.
##
## This service owns no runtime state and never reads scene nodes or transforms.

func generate(parameters, profile):
	assert(parameters != null, "generate requires ProductNewRunParameters")
	assert(profile != null, "generate requires ProductWorldGenerationProfile")
	if parameters.generation_profile_id != profile.id:
		return ProductNewRunGenerationResult.failure(
			&"generation_profile_mismatch",
			["Requested profile '%s' but received '%s'" % [String(parameters.generation_profile_id), String(profile.id)]]
		)

	var rng := RandomNumberGenerator.new()
	rng.seed = parameters.gameplay_seed
	var wilson_place = profile.wilson_start_places[rng.randi_range(0, profile.wilson_start_places.size() - 1)]
	var entity_seeds: Array = []
	var entity_keys: Dictionary = {}

	for rule in profile.entity_rules:
		var count: int = rng.randi_range(rule.min_count, rule.max_count)
		for index in range(count):
			var entity_id = DomainId.entity(StringName("%s_%03d" % [String(rule.id_prefix), index + 1]))
			if entity_keys.has(entity_id.key()):
				return ProductNewRunGenerationResult.failure(
					&"duplicate_generated_entity_id",
					["Generated duplicate entity id: %s" % entity_id.sort_key()]
				)
			entity_keys[entity_id.key()] = true
			var place_id = rule.candidate_places[rng.randi_range(0, rule.candidate_places.size() - 1)]
			entity_seeds.append(EntityBootstrapSeed.new(
				entity_id,
				rule.type_id,
				place_id,
				rule.lifecycle,
				rule.state_overrides,
				rule.quantity
			))

	var simulation = SimulationBootstrapDefinition.new(
		wilson_place,
		entity_seeds,
		[],
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
