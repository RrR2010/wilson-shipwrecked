class_name RequirementPredicateEvaluator
extends RefCounted

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RequirementPredicate = preload("res://src/domain/actions/requirement_predicate.gd")
const PredicateEvaluationResult = preload("res://src/domain/actions/predicate_evaluation_result.gd")

var _world_query
var _physical_profiles


func _init(world_query, physical_profiles) -> void:
	assert(world_query != null, "RequirementPredicateEvaluator requires WorldQuery")
	assert(physical_profiles != null, "RequirementPredicateEvaluator requires physical profile resolver")
	_world_query = world_query
	_physical_profiles = physical_profiles


func evaluate(predicate, bindings):
	assert(predicate != null, "evaluate requires predicate")
	assert(bindings != null, "evaluate requires bindings")
	return _evaluate_node(predicate, bindings)


func _evaluate_node(predicate, bindings):
	match predicate.kind:
		RequirementPredicate.Kind.ALL_OF:
			var all_diagnostics: Array[String] = []
			for child in predicate.children:
				var child_result = _evaluate_node(child, bindings)
				all_diagnostics.append_array(child_result.diagnostics)
				if not child_result.passed:
					return PredicateEvaluationResult.failure(all_diagnostics)
			return PredicateEvaluationResult.success(all_diagnostics)

		RequirementPredicate.Kind.ANY_OF:
			var any_diagnostics: Array[String] = []
			for child in predicate.children:
				var child_result = _evaluate_node(child, bindings)
				any_diagnostics.append_array(child_result.diagnostics)
				if child_result.passed:
					return PredicateEvaluationResult.success(any_diagnostics)
			return PredicateEvaluationResult.failure(any_diagnostics)

		RequirementPredicate.Kind.NOT:
			assert(predicate.children.size() == 1, "NOT requires exactly one child")
			var negated = _evaluate_node(predicate.children[0], bindings)
			return PredicateEvaluationResult.new(
				not negated.passed,
				["NOT(%s) => %s" % [negated.diagnostics, not negated.passed]]
			)

		RequirementPredicate.Kind.HAS_CAPABILITY:
			predicate.semantic_id.assert_kind(DomainId.Kind.CAPABILITY)
			var capability_subject = _require_role(bindings, predicate.role_name)
			if capability_subject == null:
				return PredicateEvaluationResult.failure(["missing role %s" % String(predicate.role_name)])
			var has_capability: bool = _world_query.has_authored_capability(capability_subject, predicate.semantic_id)
			return PredicateEvaluationResult.new(
				has_capability,
				["%s has capability %s => %s" % [String(predicate.role_name), String(predicate.semantic_id.value), has_capability]]
			)

		RequirementPredicate.Kind.HAS_CATEGORY:
			predicate.semantic_id.assert_kind(DomainId.Kind.CATEGORY)
			var category_subject = _require_role(bindings, predicate.role_name)
			if category_subject == null:
				return PredicateEvaluationResult.failure(["missing role %s" % String(predicate.role_name)])
			var has_category: bool = _world_query.has_category(category_subject, predicate.semantic_id)
			return PredicateEvaluationResult.new(
				has_category,
				["%s has category %s => %s" % [String(predicate.role_name), String(predicate.semantic_id.value), has_category]]
			)

		RequirementPredicate.Kind.PROPERTY_COMPARE:
			predicate.semantic_id.assert_kind(DomainId.Kind.PROPERTY)
			var property_subject = _require_role(bindings, predicate.role_name)
			if property_subject == null:
				return PredicateEvaluationResult.failure(["missing role %s" % String(predicate.role_name)])
			var profile = _physical_profiles.resolve(property_subject)
			var actual = profile.get_property(predicate.semantic_id) if profile.has_property(predicate.semantic_id) else _world_query.get_instance_property(property_subject, predicate.semantic_id)
			if actual == null:
				return PredicateEvaluationResult.failure([
					"%s property %s absent" % [String(predicate.role_name), String(predicate.semantic_id.value)]
				])
			var comparison := _compare(actual, predicate.compare_op, predicate.expected_value)
			return PredicateEvaluationResult.new(
				comparison,
				["%s.%s %s %s => %s (actual=%s)" % [
					String(predicate.role_name),
					String(predicate.semantic_id.value),
					_compare_name(predicate.compare_op),
					predicate.expected_value,
					comparison,
					actual,
				]]
			)

		RequirementPredicate.Kind.HAS_RELATION:
			predicate.semantic_id.assert_kind(DomainId.Kind.RELATION_TYPE)
			var relation_subject = _require_role(bindings, predicate.role_name)
			var relation_object = _require_role(bindings, predicate.other_role_name)
			if relation_subject == null or relation_object == null:
				return PredicateEvaluationResult.failure(["missing relation role binding"])
			var relations: Array = _world_query.find_relations(predicate.semantic_id, relation_subject, relation_object)
			var exists := not relations.is_empty()
			return PredicateEvaluationResult.new(
				exists,
				["relation %s(%s,%s) => %s" % [
					String(predicate.semantic_id.value),
					String(predicate.role_name),
					String(predicate.other_role_name),
					exists,
				]]
			)

		_:
			assert(false, "Unsupported RequirementPredicate kind")
			return PredicateEvaluationResult.failure(["unsupported predicate"])


func _require_role(bindings, role_name: StringName):
	if not bindings.has(role_name):
		return null
	return bindings.get_subject(role_name)


func _compare(actual: Variant, compare_op: int, expected: Variant) -> bool:
	match compare_op:
		RequirementPredicate.CompareOp.EQ: return actual == expected
		RequirementPredicate.CompareOp.NE: return actual != expected
		RequirementPredicate.CompareOp.LT: return actual < expected
		RequirementPredicate.CompareOp.LTE: return actual <= expected
		RequirementPredicate.CompareOp.GT: return actual > expected
		RequirementPredicate.CompareOp.GTE: return actual >= expected
		_: return false


func _compare_name(compare_op: int) -> String:
	match compare_op:
		RequirementPredicate.CompareOp.EQ: return "=="
		RequirementPredicate.CompareOp.NE: return "!="
		RequirementPredicate.CompareOp.LT: return "<"
		RequirementPredicate.CompareOp.LTE: return "<="
		RequirementPredicate.CompareOp.GT: return ">"
		RequirementPredicate.CompareOp.GTE: return ">="
		_: return "?"
