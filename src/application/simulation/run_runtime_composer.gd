class_name RunRuntimeComposer
extends RefCounted

const DefaultWorldQuery = preload("res://src/domain/world/default_world_query.gd")
const DefaultWorldCommandPort = preload("res://src/domain/world/default_world_command_port.gd")
const DynamicProcessAdvanceService = preload("res://src/domain/world/dynamic_process_advance_service.gd")
const WeatherProgressionService = preload("res://src/domain/world/weather_progression_service.gd")
const EnvironmentalResponseAdvanceService = preload("res://src/domain/world/environmental_response_advance_service.gd")
const PropertyDependencyGraph = preload("res://src/domain/physical/property_dependency_graph.gd")
const PhysicalDerivationPolicyRegistry = preload("res://src/domain/physical/physical_derivation_policy_registry.gd")
const EffectivePhysicalProfileResolver = preload("res://src/domain/physical/effective_physical_profile_resolver.gd")
const ProtectionProjectionService = preload("res://src/domain/physical/protection_projection_service.gd")
const ExposureResolver = preload("res://src/domain/physical/exposure_resolver.gd")
const RequirementPredicateEvaluator = preload("res://src/domain/actions/requirement_predicate_evaluator.gd")
const ActionAttemptabilityService = preload("res://src/domain/actions/action_attemptability_service.gd")
const ActionExecutionService = preload("res://src/domain/actions/action_execution_service.gd")
const PerceptionService = preload("res://src/domain/cognition/perception_service.gd")
const BeliefLearningService = preload("res://src/domain/cognition/belief_learning_service.gd")
const BeliefLearningCoordinator = preload("res://src/application/simulation/belief_learning_coordinator.gd")
const CoarsePerceptionAccessResolver = preload("res://src/application/simulation/coarse_perception_access_resolver.gd")
const DefaultSimulationActivityQuery = preload("res://src/application/simulation/default_simulation_activity_query.gd")
const DerivedStateInvalidator = preload("res://src/application/simulation/derived_state_invalidator.gd")
const EnvironmentWorldAdvanceService = preload("res://src/application/simulation/environment_world_advance_service.gd")
const WeatherTransitionEventProjector = preload("res://src/application/simulation/weather_transition_event_projector.gd")
const RunRuntimeComposition = preload("res://src/application/simulation/run_runtime_composition.gd")
const RunRuntimeCompositionResult = preload("res://src/application/simulation/run_runtime_composition_result.gd")

## Application composition root for the reconstructible core runtime.
##
## Callers provide authoritative owner state and sealed authored content. This
## service rebuilds only queries, derived infrastructure and application/domain
## services. It never mutates owner state to manufacture a scenario.


func compose(
	entities,
	relations,
	wilson_world_state,
	beliefs,
	current_intention,
	content,
	environment = null,
	dynamic_processes = null
):
	assert(entities != null, "compose requires EntityStore")
	assert(relations != null, "compose requires WorldRelationStore")
	assert(wilson_world_state != null, "compose requires WilsonWorldState")
	assert(beliefs != null, "compose requires BeliefStore")
	assert(current_intention != null, "compose requires CurrentIntentionStore")
	assert(content != null, "compose requires ContentRegistry")
	assert((environment == null) == (dynamic_processes == null), "EnvironmentState and DynamicProcessStore must be provided together")

	var policies = PhysicalDerivationPolicyRegistry.new()
	var graph = PropertyDependencyGraph.new()
	var graph_result = graph.compile(content.property_derivation_definitions(), policies)
	if not graph_result.ok:
		return RunRuntimeCompositionResult.failure(graph_result.code, graph_result.diagnostics)

	var query = DefaultWorldQuery.new(entities, relations, content, wilson_world_state)
	var profiles = EffectivePhysicalProfileResolver.new(query, graph, policies)
	var evaluator = RequirementPredicateEvaluator.new(query, profiles)
	var attemptability = ActionAttemptabilityService.new(evaluator)
	var execution = ActionExecutionService.new(attemptability)
	var commands = DefaultWorldCommandPort.new(entities, relations, query)
	var invalidator = DerivedStateInvalidator.new(profiles)
	var perception_access = CoarsePerceptionAccessResolver.new(query)
	var perception = PerceptionService.new()
	var learning = BeliefLearningCoordinator.new(BeliefLearningService.new(), beliefs)
	var activity_query = DefaultSimulationActivityQuery.new(execution, current_intention)
	var world_advance = null

	if environment != null:
		var dynamic_process_advance = DynamicProcessAdvanceService.new(
			dynamic_processes,
			content.dynamic_process_definitions(),
			query,
			entities
		)
		var weather_progression = null
		var weather_event_projector = null
		var environmental_response_advance = null
		var weather_definitions: Array = content.weather_definitions()
		var weather_transitions: Array = content.weather_transition_definitions()
		var environmental_responses: Array = content.environmental_response_definitions()

		if not weather_definitions.is_empty():
			var weather_validation = _validate_weather_graph(environment, weather_definitions, weather_transitions)
			if not weather_validation.is_empty():
				return RunRuntimeCompositionResult.failure(&"invalid_weather_content", weather_validation)
			weather_progression = WeatherProgressionService.new(
				environment,
				weather_definitions,
				weather_transitions
			)
			weather_event_projector = WeatherTransitionEventProjector.new()
		elif not environmental_responses.is_empty():
			return RunRuntimeCompositionResult.failure(
				&"environmental_response_requires_weather_content",
				["Environmental responses require authored weather conditions in the current runtime"] as Array[String]
			)

		if not environmental_responses.is_empty():
			var exposure_resolver = null
			var requires_exposure := false
			for response_definition in environmental_responses:
				if response_definition.exposure_kind != &"":
					requires_exposure = true
					break
			if requires_exposure:
				exposure_resolver = ExposureResolver.new(
					ProtectionProjectionService.new(query, content.protection_rule_definitions())
				)
			environmental_response_advance = EnvironmentalResponseAdvanceService.new(
				weather_progression,
				query,
				entities,
				environmental_responses,
				exposure_resolver
			)

		world_advance = EnvironmentWorldAdvanceService.new(
			dynamic_process_advance,
			null,
			null,
			null,
			null,
			weather_progression,
			weather_event_projector,
			environmental_response_advance
		)

	return RunRuntimeCompositionResult.success(RunRuntimeComposition.new(
		query,
		graph,
		policies,
		profiles,
		evaluator,
		attemptability,
		execution,
		commands,
		invalidator,
		perception_access,
		perception,
		learning,
		activity_query,
		world_advance
	))


func _validate_weather_graph(environment, definitions: Array, transitions: Array) -> Array[String]:
	var diagnostics: Array[String] = []
	var weather_ids: Dictionary = {}
	var outgoing: Dictionary = {}
	for definition in definitions:
		weather_ids[definition.id] = true
	if not weather_ids.has(environment.weather):
		diagnostics.append("Environment weather has no authored definition: %s" % String(environment.weather))
	for transition in transitions:
		if not weather_ids.has(transition.from_weather):
			diagnostics.append("Weather transition has unknown source: %s" % String(transition.from_weather))
		if not weather_ids.has(transition.to_weather):
			diagnostics.append("Weather transition has unknown target: %s" % String(transition.to_weather))
		outgoing[transition.from_weather] = true
	for weather_id in weather_ids.keys():
		if not outgoing.has(weather_id):
			diagnostics.append("Weather definition has no outgoing transition: %s" % String(weather_id))
	return diagnostics
