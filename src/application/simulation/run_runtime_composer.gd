class_name RunRuntimeComposer
extends RefCounted

const DefaultWorldQuery = preload("res://src/domain/world/default_world_query.gd")
const DefaultWorldCommandPort = preload("res://src/domain/world/default_world_command_port.gd")
const PropertyDependencyGraph = preload("res://src/domain/physical/property_dependency_graph.gd")
const PhysicalDerivationPolicyRegistry = preload("res://src/domain/physical/physical_derivation_policy_registry.gd")
const EffectivePhysicalProfileResolver = preload("res://src/domain/physical/effective_physical_profile_resolver.gd")
const RequirementPredicateEvaluator = preload("res://src/domain/actions/requirement_predicate_evaluator.gd")
const ActionAttemptabilityService = preload("res://src/domain/actions/action_attemptability_service.gd")
const ActionExecutionService = preload("res://src/domain/actions/action_execution_service.gd")
const PerceptionService = preload("res://src/domain/cognition/perception_service.gd")
const BeliefLearningService = preload("res://src/domain/cognition/belief_learning_service.gd")
const BeliefLearningCoordinator = preload("res://src/application/simulation/belief_learning_coordinator.gd")
const CoarsePerceptionAccessResolver = preload("res://src/application/simulation/coarse_perception_access_resolver.gd")
const DefaultSimulationActivityQuery = preload("res://src/application/simulation/default_simulation_activity_query.gd")
const DerivedStateInvalidator = preload("res://src/application/simulation/derived_state_invalidator.gd")
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
	content
):
	assert(entities != null, "compose requires EntityStore")
	assert(relations != null, "compose requires WorldRelationStore")
	assert(wilson_world_state != null, "compose requires WilsonWorldState")
	assert(beliefs != null, "compose requires BeliefStore")
	assert(current_intention != null, "compose requires CurrentIntentionStore")
	assert(content != null, "compose requires ContentRegistry")

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
		activity_query
	))
