class_name RunRuntimeComposition
extends RefCounted

## Reconstructible application runtime assembled from authoritative run owners.
##
## This object is not a gameplay state owner. It groups deterministic queries,
## derived services and coordinators that can be rebuilt from durable causes.

var world_query
var property_dependency_graph
var physical_policy_registry
var effective_physical_profiles
var requirement_evaluator
var action_attemptability
var action_execution
var world_commands
var derived_invalidator
var perception_access
var perception
var learning
var activity_query


func _init(
	p_world_query,
	p_property_dependency_graph,
	p_physical_policy_registry,
	p_effective_physical_profiles,
	p_requirement_evaluator,
	p_action_attemptability,
	p_action_execution,
	p_world_commands,
	p_derived_invalidator,
	p_perception_access,
	p_perception,
	p_learning,
	p_activity_query
) -> void:
	assert(p_world_query != null, "RunRuntimeComposition requires WorldQuery")
	assert(p_property_dependency_graph != null, "RunRuntimeComposition requires PropertyDependencyGraph")
	assert(p_physical_policy_registry != null, "RunRuntimeComposition requires PhysicalDerivationPolicyRegistry")
	assert(p_effective_physical_profiles != null, "RunRuntimeComposition requires EffectivePhysicalProfileResolver")
	assert(p_requirement_evaluator != null, "RunRuntimeComposition requires RequirementPredicateEvaluator")
	assert(p_action_attemptability != null, "RunRuntimeComposition requires ActionAttemptabilityService")
	assert(p_action_execution != null, "RunRuntimeComposition requires ActionExecutionService")
	assert(p_world_commands != null, "RunRuntimeComposition requires World command port")
	assert(p_derived_invalidator != null, "RunRuntimeComposition requires DerivedStateInvalidator")
	assert(p_perception_access != null, "RunRuntimeComposition requires PerceptionAccess resolver")
	assert(p_perception != null, "RunRuntimeComposition requires PerceptionService")
	assert(p_learning != null, "RunRuntimeComposition requires learning coordinator")
	assert(p_activity_query != null, "RunRuntimeComposition requires activity query")
	world_query = p_world_query
	property_dependency_graph = p_property_dependency_graph
	physical_policy_registry = p_physical_policy_registry
	effective_physical_profiles = p_effective_physical_profiles
	requirement_evaluator = p_requirement_evaluator
	action_attemptability = p_action_attemptability
	action_execution = p_action_execution
	world_commands = p_world_commands
	derived_invalidator = p_derived_invalidator
	perception_access = p_perception_access
	perception = p_perception
	learning = p_learning
	activity_query = p_activity_query
