class_name GroundedDriveConsequenceService
extends RefCounted

const MutationResult = preload("res://src/domain/core/mutation_result.gd")

## Cross-owner application boundary for drive consequences caused by grounded actions.
##
## ActionExecution proposes an ActionOutcome. World remains authoritative for accepting
## that outcome. Only a successful WorldCommitResult may cause this service to mutate
## the supplied DriveState owner. Execution ids are remembered to make repeated
## coordinator delivery idempotent within a runtime; restored executions whose outcome
## was already emitted never re-emit that outcome.

var _drive_state
var _resource_query
var _definitions: Array
var _applied_execution_ids: Dictionary = {}


func _init(drive_state, definitions: Array, resource_query = null) -> void:
	assert(drive_state != null, "GroundedDriveConsequenceService requires DriveState")
	_drive_state = drive_state
	_resource_query = resource_query
	_definitions = definitions.duplicate()
	_definitions.sort_custom(func(a, b): return a.stable_key() < b.stable_key())
	var seen: Dictionary = {}
	for definition in _definitions:
		assert(definition != null and definition.has_method("matches"), "Drive consequences require valid definitions")
		var key: String = definition.stable_key()
		assert(not seen.has(key), "Duplicate drive consequence definition: %s" % key)
		seen[key] = true


func apply_grounded(outcome, world_commit_result):
	assert(outcome != null, "apply_grounded requires ActionOutcome")
	assert(world_commit_result != null, "apply_grounded requires WorldCommitResult")
	if not world_commit_result.ok:
		return MutationResult.success(&"drive_consequence_not_grounded", [])
	if _applied_execution_ids.has(outcome.execution_id):
		return MutationResult.success(&"drive_consequence_already_applied", [])

	var matches: Array = []
	for definition in _definitions:
		if definition.matches(outcome):
			matches.append(definition)
	if matches.is_empty():
		return MutationResult.success(&"drive_consequence_no_match", [])

	# Resolve every resource benefit before mutating any drive.
	var resolved: Array = []
	for definition in matches:
		var delta: float = definition.delta
		if definition.relief_property_id != null:
			if _resource_query == null or not outcome.bindings.has(definition.target_role):
				return MutationResult.failure(&"drive_consequence_invalid_resource", ["Missing resource query or target binding"])
			var target = outcome.bindings.get_subject(definition.target_role)
			var relief: Variant = _resource_query.get_instance_property(target, definition.relief_property_id)
			if not (relief is int or relief is float) or not is_finite(float(relief)) or float(relief) <= 0.0 or float(relief) > 1.0:
				return MutationResult.failure(&"drive_consequence_invalid_resource", ["Resource relief must be finite within (0,1]"])
			delta = -float(relief)
		resolved.append({"definition": definition, "delta": delta})

	var applied: Array = []
	for resolved_entry in resolved:
		var definition = resolved_entry["definition"]
		var delta: float = resolved_entry["delta"]
		var previous: float = _drive_state.value(definition.drive_id)
		var next_value: float = clampf(previous + delta, 0.0, 1.0)
		_drive_state.set_value(definition.drive_id, next_value)
		applied.append({
			"drive_id": definition.drive_id,
			"previous": previous,
			"current": next_value,
			"delta": next_value - previous,
		})
	_applied_execution_ids[outcome.execution_id] = true
	return MutationResult.success(&"drive_consequence_applied", applied)
