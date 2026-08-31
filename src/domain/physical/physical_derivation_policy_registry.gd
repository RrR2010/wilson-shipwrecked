class_name PhysicalDerivationPolicyRegistry
extends RefCounted

## Closed set of deterministic derivation policies.
## Content references policy IDs; authored content cannot inject executable callbacks.

const SUPPORTED := {
	&"min_numeric": true,
	&"max_numeric": true,
	&"average_numeric": true,
}


func supports(policy_id: StringName) -> bool:
	return SUPPORTED.has(policy_id)


func evaluate(policy_id: StringName, inputs: Array) -> Variant:
	assert(supports(policy_id), "Unsupported physical derivation policy: %s" % String(policy_id))
	assert(not inputs.is_empty(), "Physical derivation policy requires at least one input")
	match policy_id:
		&"min_numeric":
			var result = inputs[0]
			for value in inputs:
				assert(value is int or value is float, "min_numeric requires numeric inputs")
				result = min(result, value)
			return result
		&"max_numeric":
			var result = inputs[0]
			for value in inputs:
				assert(value is int or value is float, "max_numeric requires numeric inputs")
				result = max(result, value)
			return result
		&"average_numeric":
			var total := 0.0
			for value in inputs:
				assert(value is int or value is float, "average_numeric requires numeric inputs")
				total += float(value)
			return total / inputs.size()
	return null
