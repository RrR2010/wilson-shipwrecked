class_name AssemblyValidityService
extends RefCounted

const RoleBinding = preload("res://src/domain/actions/role_binding.gd")
const AssemblyValidityResult = preload("res://src/domain/physical/assembly_validity_result.gd")

var _world_query
var _predicate_evaluator


func _init(world_query, predicate_evaluator) -> void:
	assert(world_query != null, "AssemblyValidityService requires WorldQuery")
	assert(predicate_evaluator != null, "AssemblyValidityService requires RequirementPredicateEvaluator")
	_world_query = world_query
	_predicate_evaluator = predicate_evaluator


func evaluate(definition, host, bindings: Array):
	assert(definition != null, "evaluate requires AssemblyDefinition")
	assert(host != null, "evaluate requires host")
	var diagnostics: Array[String] = []
	var slot_results: Dictionary = {}
	var bindings_by_slot: Dictionary = {}

	for binding in bindings:
		if binding == null:
			return AssemblyValidityResult.new(
				AssemblyValidityResult.Status.INVALID_CONFIGURATION,
				["Assembly bindings cannot contain null"]
			)
		if not binding.host.equals(host):
			return AssemblyValidityResult.new(
				AssemblyValidityResult.Status.INVALID_CONFIGURATION,
				["Binding host mismatch for slot %s" % binding.slot_id.sort_key()]
			)
		var slot = definition.get_slot(binding.slot_id)
		if slot == null:
			return AssemblyValidityResult.new(
				AssemblyValidityResult.Status.INVALID_CONFIGURATION,
				["Binding references unknown slot %s" % binding.slot_id.sort_key()]
			)
		if not bindings_by_slot.has(binding.slot_id.key()):
			bindings_by_slot[binding.slot_id.key()] = []
		bindings_by_slot[binding.slot_id.key()].append(binding)

	for slot in definition.slots:
		var slot_bindings: Array = bindings_by_slot.get(slot.id.key(), [])
		if slot_bindings.size() < slot.min_count:
			slot_results[slot.id.key()] = {"status": "incomplete", "count": slot_bindings.size()}
			diagnostics.append("Required slot %s incomplete: %d/%d" % [slot.id.sort_key(), slot_bindings.size(), slot.min_count])
			return AssemblyValidityResult.new(AssemblyValidityResult.Status.INCOMPLETE, diagnostics, slot_results)
		if slot_bindings.size() > slot.max_count:
			slot_results[slot.id.key()] = {"status": "invalid_cardinality", "count": slot_bindings.size()}
			diagnostics.append("Slot %s exceeds max cardinality: %d/%d" % [slot.id.sort_key(), slot_bindings.size(), slot.max_count])
			return AssemblyValidityResult.new(AssemblyValidityResult.Status.INVALID_CONFIGURATION, diagnostics, slot_results)

		for binding in slot_bindings:
			if not _world_query.is_live_subject(binding.component):
				slot_results[slot.id.key()] = {"status": "broken_binding", "component": binding.component.sort_key()}
				diagnostics.append("Slot %s references non-live component %s" % [slot.id.sort_key(), binding.component.sort_key()])
				return AssemblyValidityResult.new(AssemblyValidityResult.Status.BROKEN_BINDING, diagnostics, slot_results)
			var component_binding = RoleBinding.new()
			component_binding.bind(&"component", binding.component)
			var predicate_result = _predicate_evaluator.evaluate(slot.accepted_component_predicate, component_binding)
			if not predicate_result.passed:
				slot_results[slot.id.key()] = {
					"status": "incompatible_component",
					"component": binding.component.sort_key(),
					"diagnostics": predicate_result.diagnostics,
				}
				diagnostics.append("Slot %s rejects component %s" % [slot.id.sort_key(), binding.component.sort_key()])
				diagnostics.append_array(predicate_result.diagnostics)
				return AssemblyValidityResult.new(AssemblyValidityResult.Status.INCOMPATIBLE_COMPONENT, diagnostics, slot_results)

		slot_results[slot.id.key()] = {"status": "valid", "count": slot_bindings.size()}

	return AssemblyValidityResult.new(AssemblyValidityResult.Status.VALID, diagnostics, slot_results)
