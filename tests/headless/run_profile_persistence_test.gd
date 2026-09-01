extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RunLifecycleState = preload("res://src/application/lifecycle/run_lifecycle_state.gd")
const PlayerProfile = preload("res://src/domain/player/player_profile.gd")
const RunProfileSnapshotService = preload("res://src/infrastructure/persistence/run_profile_snapshot_service.gd")

var _failures: Array[String] = []


func _init() -> void:
	_run()
	if _failures.is_empty():
		print("PASS run_profile_persistence_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL run_profile_persistence_test: %d failure(s)" % _failures.size())
	quit(1)


func _run() -> void:
	var run = RunLifecycleState.new(&"run_042")
	_expect_true(run.mark_dead(&"storm_exposure").ok, "death state prepared")
	run.resurrection_count = 2

	var profile = PlayerProfile.new()
	var knot_knowledge = DomainId.new(DomainId.Kind.KNOWLEDGE, &"secure_knot")
	profile.add_legacy_knowledge(knot_knowledge)
	profile.archive_diary_entry(&"run_010", &"shelter_note", "A reinforced shelter survived the storm.", true)
	profile.increment_stat(&"runs_completed", 3)
	profile.increment_stat(&"deaths", 4)
	profile.unlock(&"storm_archive")

	var snapshots = RunProfileSnapshotService.new()
	var snapshot = snapshots.capture(run, profile)
	_expect_equal(snapshot["schema_version"], 1, "run/profile snapshot schema")
	var restored = snapshots.restore(JSON.parse_string(JSON.stringify(snapshot)))

	_expect_equal(restored.run_state.run_id, &"run_042", "run id survives round-trip")
	_expect_equal(restored.run_state.lifecycle, RunLifecycleState.Lifecycle.DEAD, "run lifecycle survives round-trip")
	_expect_equal(restored.run_state.death_count, 1, "death count survives round-trip")
	_expect_equal(restored.run_state.resurrection_count, 2, "resurrection count survives round-trip")
	_expect_equal(restored.run_state.last_death_cause, &"storm_exposure", "death cause survives round-trip")
	_expect_true(restored.player_profile.has_legacy_knowledge(knot_knowledge), "legacy knowledge survives round-trip")
	_expect_equal(restored.player_profile.diary_archive().size(), 1, "diary archive survives round-trip")
	_expect_equal(restored.player_profile.stat(&"runs_completed"), 3, "lifetime run statistic survives round-trip")
	_expect_equal(restored.player_profile.stat(&"deaths"), 4, "lifetime death statistic survives round-trip")
	_expect_true(restored.player_profile.is_unlocked(&"storm_archive"), "global unlock survives round-trip")


func _expect_true(actual: bool, label: String) -> void:
	if not actual:
		_failures.append("Expected true: %s" % label)


func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
