class_name SimulationSnapshotBootstrapDecoder
extends RefCounted

const RoleBinding = preload("res://src/domain/actions/role_binding.gd")
const BeliefProposition = preload("res://src/domain/cognition/belief_proposition.gd")
const DomainValueCodec = preload("res://src/infrastructure/persistence/domain_value_codec.gd")
const SimulationBootstrapDefinition = preload("res://src/application/bootstrap/simulation_bootstrap_definition.gd")
const EntityBootstrapSeed = preload("res://src/application/bootstrap/entity_bootstrap_seed.gd")
const RelationBootstrapSeed = preload("res://src/application/bootstrap/relation_bootstrap_seed.gd")
const BeliefBootstrapSeed = preload("res://src/application/bootstrap/belief_bootstrap_seed.gd")
const IntentionBootstrapSeed = preload("res://src/application/bootstrap/intention_bootstrap_seed.gd")

## Persistence-facing decoder from schema DTOs into the application bootstrap
## contract. Snapshot schema/codec concerns stay here; owner construction stays in
## SimulationOwnerBootstrapper.

var _codec


func _init(codec = null) -> void:
	_codec = codec if codec != null else DomainValueCodec.new()


func decode(snapshot: Dictionary) -> SimulationBootstrapDefinition:
	var wilson_record = snapshot.get("wilson_world")
	assert(wilson_record is Dictionary and wilson_record.has("place_id"), "Snapshot missing Wilson world state")

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

	return SimulationBootstrapDefinition.new(
		_codec.decode(wilson_record["place_id"]),
		entity_seeds,
		relation_seeds,
		belief_seeds,
		intention_seed
	)


func _decode_binding(records: Array):
	var binding = RoleBinding.new()
	for record in records:
		binding.bind(StringName(record["role"]), _codec.decode(record["subject"]))
	return binding
