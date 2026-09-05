class_name SimulationSnapshotBootstrapDecoder
extends RefCounted

const RoleBinding = preload("res://src/domain/actions/role_binding.gd")
const BeliefProposition = preload("res://src/domain/cognition/belief_proposition.gd")
const DriveState = preload("res://src/domain/cognition/drive_state.gd")
const DomainValueCodec = preload("res://src/infrastructure/persistence/domain_value_codec.gd")
const SimulationBootstrapDefinition = preload("res://src/application/bootstrap/simulation_bootstrap_definition.gd")
const EntityBootstrapSeed = preload("res://src/application/bootstrap/entity_bootstrap_seed.gd")
const RelationBootstrapSeed = preload("res://src/application/bootstrap/relation_bootstrap_seed.gd")
const BeliefBootstrapSeed = preload("res://src/application/bootstrap/belief_bootstrap_seed.gd")
const IntentionBootstrapSeed = preload("res://src/application/bootstrap/intention_bootstrap_seed.gd")
const ProjectBootstrapSeed = preload("res://src/application/bootstrap/project_bootstrap_seed.gd")

## Persistence-facing decoder from schema DTOs into the application bootstrap
## contract. Snapshot schema/codec concerns stay here; owner construction stays in
## SimulationOwnerBootstrapper.

var _codec


func _init(codec = null) -> void:
	_codec = codec if codec != null else DomainValueCodec.new()


func decode(snapshot: Dictionary) -> SimulationBootstrapDefinition:
	var wilson_record = snapshot.get("wilson_world")
	assert(wilson_record is Dictionary and wilson_record.has("place_id"), "Snapshot missing Wilson world state")
	var body_record = snapshot.get("wilson_body")
	assert(body_record is Dictionary and body_record.has("vitality"), "Snapshot missing Wilson body state")
	var drive_record = snapshot.get("drives")
	assert(drive_record is Dictionary, "Snapshot missing Wilson drive state")

	var entity_seeds: Array = []
	for record in snapshot.get("entities", []):
		entity_seeds.append(EntityBootstrapSeed.new(
			_codec.decode(record["id"]),
			_codec.decode(record["type_id"]),
			_codec.decode(record["place_id"]),
			int(record["lifecycle"]),
			_codec.decode(record["state_overrides"]),
			_codec.decode(record["quantity"])
		))

	var relation_seeds: Array = []
	for record in snapshot.get("relations", []):
		relation_seeds.append(RelationBootstrapSeed.new(
			_codec.decode(record["relation_type"]),
			_codec.decode(record["subject"]),
			_codec.decode(record["object"]),
			_codec.decode(record["qualifier"])
		))

	var belief_seeds: Array = []
	for record in snapshot.get("beliefs", []):
		belief_seeds.append(BeliefBootstrapSeed.new(
			BeliefProposition.new(_codec.decode(record["claim"])),
			float(record["confidence"]),
			int(record["evidence_count"]),
			StringName(record.get("last_source_execution_id", "")),
			StringName(record.get("last_modality", ""))
		))

	var intention_seed = null
	var intention_record = snapshot.get("current_intention")
	if intention_record != null:
		intention_seed = IntentionBootstrapSeed.new(
			_codec.decode(intention_record["intention_id"]),
			_decode_binding(intention_record["bindings"]),
			StringName(intention_record["selected_step_id"])
		)

	var project_seeds: Array = []
	for record in snapshot.get("projects", []):
		project_seeds.append(ProjectBootstrapSeed.new(
			_codec.decode(record["id"]),
			_codec.decode(record["definition_id"]),
			_decode_binding(record["subject_bindings"]),
			int(record["lifecycle"]),
			int(record["contribution_count"])
		))

	return SimulationBootstrapDefinition.new(
		_codec.decode(wilson_record["place_id"]),
		entity_seeds,
		relation_seeds,
		belief_seeds,
		intention_seed,
		float(body_record["vitality"]),
		_decode_drives(drive_record),
		project_seeds
	)


func _decode_drives(record: Dictionary) -> Dictionary:
	var result: Dictionary = {}
	for drive_id in DriveState.DRIVE_IDS:
		var key: String = String(drive_id)
		assert(record.has(key), "Drive snapshot missing %s" % key)
		result[drive_id] = float(record[key])
	return result


func _decode_binding(records: Array):
	var binding = RoleBinding.new()
	for record in records:
		binding.bind(StringName(record["role"]), _codec.decode(record["subject"]))
	return binding
