class_name DirectorPlayerSnapshotService
extends RefCounted

const RoleBinding = preload("res://src/domain/actions/role_binding.gd")
const DirectorOpportunityState = preload("res://src/domain/director/director_opportunity_state.gd")
const DirectorStateStore = preload("res://src/domain/director/director_state_store.gd")
const PlayerSuggestion = preload("res://src/domain/player/player_suggestion.gd")
const PlayerRunState = preload("res://src/domain/player/player_run_state.gd")
const DomainValueCodec = preload("res://src/infrastructure/persistence/domain_value_codec.gd")
const RestoredDirectorPlayerState = preload("res://src/infrastructure/persistence/restored_director_player_state.gd")

const SCHEMA_VERSION := 1

var _codec

func _init(codec = null) -> void:
	_codec = codec if codec != null else DomainValueCodec.new()

func capture(director_store, player_state) -> Dictionary:
	assert(director_store != null, "capture requires DirectorStateStore")
	assert(player_state != null, "capture requires PlayerRunState")
	var director_records: Array = []
	for state in director_store.states():
		director_records.append({
			"definition_id": String(state.definition_id),
			"lifecycle": state.lifecycle,
			"cooldown_remaining": state.cooldown_remaining,
			"activation_count": state.activation_count,
		})
	var permission_keys: Array[String] = []
	for permission in player_state.permissions.keys():
		permission_keys.append(String(permission))
	permission_keys.sort()
	return {
		"schema_version": SCHEMA_VERSION,
		"director": director_records,
		"player": {
			"god_power": player_state.god_power,
			"permissions": permission_keys,
			"non_intervention_seconds": player_state.non_intervention_seconds,
			"active_suggestion": _capture_suggestion(player_state.active_suggestion),
		},
	}

func restore(snapshot: Dictionary):
	assert(int(snapshot.get("schema_version", -1)) == SCHEMA_VERSION, "Unsupported Director/player snapshot schema")
	var director = DirectorStateStore.new()
	for record in snapshot.get("director", []):
		assert(director.add(DirectorOpportunityState.new(
			StringName(record["definition_id"]),
			int(record["lifecycle"]),
			float(record["cooldown_remaining"]),
			int(record["activation_count"])
		)), "Duplicate restored Director opportunity")
	var player_record = snapshot.get("player", {})
	var player = PlayerRunState.new(float(player_record.get("god_power", 0.0)), player_record.get("permissions", []))
	player.non_intervention_seconds = float(player_record.get("non_intervention_seconds", 0.0))
	var suggestion_record = player_record.get("active_suggestion")
	if suggestion_record != null:
		player.set_suggestion(PlayerSuggestion.new(
			_codec.decode(suggestion_record["intention_id"]),
			_decode_binding(suggestion_record["bindings"]),
			float(suggestion_record["bias"]),
			int(suggestion_record["remaining_insistence"])
		))
	return RestoredDirectorPlayerState.new(director, player)

func _capture_suggestion(suggestion):
	if suggestion == null:
		return null
	return {
		"intention_id": _codec.encode(suggestion.intention_id),
		"bindings": _encode_binding(suggestion.bindings),
		"bias": suggestion.bias,
		"remaining_insistence": suggestion.remaining_insistence,
	}

func _encode_binding(binding) -> Array:
	var result: Array = []
	for role_name in binding.role_names():
		result.append({"role": String(role_name), "subject": _codec.encode(binding.get_subject(role_name))})
	return result

func _decode_binding(records: Array):
	var binding = RoleBinding.new()
	for record in records:
		binding.bind(StringName(record["role"]), _codec.decode(record["subject"]))
	return binding
