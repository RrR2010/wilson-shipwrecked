class_name EndRunService
extends RefCounted

const MutationResult = preload("res://src/domain/core/mutation_result.gd")
const RunLifecycleState = preload("res://src/application/lifecycle/run_lifecycle_state.gd")

## Deterministic cross-owner lifecycle transaction. The run ends first; only the
## explicit RunProfileProjection is then admitted into PlayerProfile.

var _run_state
var _player_profile


func _init(run_state, player_profile) -> void:
	assert(run_state != null, "EndRunService requires RunLifecycleState")
	assert(player_profile != null, "EndRunService requires PlayerProfile")
	_run_state = run_state
	_player_profile = player_profile


func end_run(reason: StringName, projection):
	if projection == null:
		return MutationResult.failure(&"missing_profile_projection", ["EndRun requires explicit admitted profile projection"])
	var end_result = _run_state.end_run(reason)
	if not end_result.ok:
		return end_result

	for knowledge_id in projection.legacy_knowledge:
		_player_profile.add_legacy_knowledge(knowledge_id)
	for entry in projection.diary_entries:
		_player_profile.archive_diary_entry(
			_run_state.run_id,
			StringName(entry["entry_id"]),
			String(entry["text"]),
			bool(entry.get("wilson_accessible", false))
		)
	for stat_id in projection.statistic_deltas.keys():
		_player_profile.increment_stat(StringName(stat_id), int(projection.statistic_deltas[stat_id]))
	for unlock_id in projection.unlocks:
		_player_profile.unlock(unlock_id)
	return MutationResult.success(&"run_ended_profile_admitted")
