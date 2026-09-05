class_name RunProfileSnapshotService
extends RefCounted

const DomainValueCodec = preload("res://src/infrastructure/persistence/domain_value_codec.gd")
const RunLifecycleState = preload("res://src/application/lifecycle/run_lifecycle_state.gd")
const PlayerProfile = preload("res://src/domain/player/player_profile.gd")
const RestoredRunProfileState = preload("res://src/infrastructure/persistence/restored_run_profile_state.gd")

const SCHEMA_VERSION := 1

var _codec


func _init(codec = null) -> void:
	_codec = codec if codec != null else DomainValueCodec.new()


func capture(run_state, player_profile) -> Dictionary:
	assert(run_state != null, "capture requires RunLifecycleState")
	assert(player_profile != null, "capture requires PlayerProfile")
	var legacy: Array = []
	for knowledge_id in player_profile.legacy_knowledge():
		legacy.append(_codec.encode(knowledge_id))
	var diary: Array = []
	for entry in player_profile.diary_archive():
		diary.append({
			"run_id": String(entry["run_id"]),
			"entry_id": String(entry["entry_id"]),
			"text": String(entry["text"]),
			"wilson_accessible": bool(entry["wilson_accessible"]),
		})
	var statistics: Dictionary = {}
	for stat_id in player_profile.statistics().keys():
		statistics[String(stat_id)] = int(player_profile.statistics()[stat_id])
	var unlocks: Array[String] = []
	for unlock_id in player_profile.unlocks():
		unlocks.append(String(unlock_id))
	return {
		"schema_version": SCHEMA_VERSION,
		"run": {
			"run_id": String(run_state.run_id),
			"lifecycle": run_state.lifecycle,
			"death_count": run_state.death_count,
			"resurrection_count": run_state.resurrection_count,
			"last_death_cause": String(run_state.last_death_cause),
			"end_reason": String(run_state.end_reason),
		},
		"profile": {
			"legacy_knowledge": legacy,
			"diary_archive": diary,
			"lifetime_statistics": statistics,
			"global_unlocks": unlocks,
		},
	}


func restore(snapshot: Dictionary):
	return RestoredRunProfileState.new(
		restore_run_state(snapshot),
		restore_player_profile(snapshot)
	)


func restore_run_state(snapshot: Dictionary):
	_validate_snapshot(snapshot)
	var run_record = snapshot.get("run")
	assert(run_record is Dictionary, "Snapshot missing run lifecycle")
	var run_state = RunLifecycleState.new(
		StringName(run_record["run_id"]),
		int(run_record["lifecycle"])
	)
	run_state.death_count = int(run_record.get("death_count", 0))
	run_state.resurrection_count = int(run_record.get("resurrection_count", 0))
	run_state.last_death_cause = StringName(run_record.get("last_death_cause", ""))
	run_state.end_reason = StringName(run_record.get("end_reason", ""))
	return run_state


func restore_player_profile(snapshot: Dictionary):
	_validate_snapshot(snapshot)
	var profile_record = snapshot.get("profile")
	assert(profile_record is Dictionary, "Snapshot missing player profile")
	var profile = PlayerProfile.new()
	for encoded_knowledge in profile_record.get("legacy_knowledge", []):
		profile.add_legacy_knowledge(_codec.decode(encoded_knowledge))
	for entry in profile_record.get("diary_archive", []):
		profile.archive_diary_entry(
			StringName(entry["run_id"]),
			StringName(entry["entry_id"]),
			String(entry["text"]),
			bool(entry["wilson_accessible"])
		)
	for stat_id in profile_record.get("lifetime_statistics", {}).keys():
		profile.increment_stat(StringName(stat_id), int(profile_record["lifetime_statistics"][stat_id]))
	for unlock_id in profile_record.get("global_unlocks", []):
		profile.unlock(StringName(unlock_id))
	return profile


func _validate_snapshot(snapshot: Dictionary) -> void:
	assert(int(snapshot.get("schema_version", -1)) == SCHEMA_VERSION, "Unsupported run/profile snapshot schema")
