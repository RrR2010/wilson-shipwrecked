class_name ActionAttemptabilityService
extends RefCounted

const ActionAttemptabilityResult = preload("res://src/domain/actions/action_attemptability_result.gd")

var _predicate_evaluator


func _init(predicate_evaluator) -> void:
	assert(predicate_evaluator != null, "ActionAttemptabilityService requires predicate evaluator")
	_predicate_evaluator = predicate_evaluator


func query(action_definition, bindings):
	assert(action_definition != null, "query requires ActionDefinition")
	assert(bindings != null, "query requires RoleBinding")

	for role_name in action_definition.roles:
		if not bindings.has(role_name):
			return ActionAttemptabilityResult.rejected(
				&"missing_role",
				["Missing required role: %s" % String(role_name)]
			)

	var evaluation = _predicate_evaluator.evaluate(action_definition.requirements, bindings)
	if not evaluation.passed:
		return ActionAttemptabilityResult.rejected(&"requirements_failed", evaluation.diagnostics)
	return ActionAttemptabilityResult.allowed(evaluation.diagnostics)
