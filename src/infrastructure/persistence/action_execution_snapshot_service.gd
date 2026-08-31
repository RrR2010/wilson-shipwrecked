class_name ActionExecutionSnapshotService
extends RefCounted

const RoleBinding = preload("res://src/domain/actions/role_binding.gd")
const DomainValueCodec = preload("res://src/infrastructure/persistence/domain_value_codec.gd")

const SCHEMA_VERSION := 2

var _codec


func _init(codec = null) -> void:
	_codec = codec if codec != null else DomainValueCodec.new()


func capture(action_execution) -> Dictionary:
	assert(action_execution != null, "capture requires ActionExecutionService")
	var records: Array = []
	for state in action_execution.states():
		records.append({
			"execution_id": String(state.execution_id),
			"action_id": _codec.encode(state.action_definition.id),
			"resolution_definition_id": String(state.resolution_definition.definition_id),
			"bindings": _encode_binding(state.bindings),
			"elapsed": state.elapsed,
			"committed": state.committed,
			"completed": state.completed,
			"interrupted": state.interrupted,
			"outcome_emitted": state.outcome_emitted,
		})
	return {
		"schema_version": SCHEMA_VERSION,
		"executions": records,
	}


func restore(snapshot: Dictionary, action_execution, content_registry) -> Array:
	assert(action_execution != null, "restore requires ActionExecutionService")
	assert(content_registry != null, "restore requires ContentRegistry")
	assert(int(snapshot.get("schema_version", -1)) == SCHEMA_VERSION, "Unsupported action execution snapshot schema")
	var results: Array = []
	for record in snapshot.get("executions", []):
		var action_id = _codec.decode(record["action_id"])
		var action_definition = content_registry.get_action_definition(action_id)
		var resolution_id = StringName(record["resolution_definition_id"])
		var resolution_definition = content_registry.get_action_resolution_definition(resolution_id)
		assert(action_definition != null, "Missing authored ActionDefinition during execution restore: %s" % action_id.sort_key())
		assert(resolution_definition != null, "Missing authored ActionResolutionDefinition during execution restore: %s" % String(resolution_id))
		assert(resolution_definition.action_id.equals(action_id), "Restored action/resolution definition mismatch")
		results.append(action_execution.restore_state(
			StringName(record["execution_id"]),
			action_definition,
			resolution_definition,
			_decode_binding(record["bindings"]),
			float(record["elapsed"]),
			bool(record["committed"]),
			bool(record["completed"]),
			bool(record["outcome_emitted"]),
			bool(record.get("interrupted", false))
		))
	return results


func _encode_binding(binding) -> Array:
	var result: Array = []
	for role_name in binding.role_names():
		result.append({
			"role": String(role_name),
			"subject": _codec.encode(binding.get_subject(role_name)),
		})
	return result


func _decode_binding(records: Array):
	var binding = RoleBinding.new()
	for record in records:
		binding.bind(StringName(record["role"]), _codec.decode(record["subject"]))
	return binding
