extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RunLifecycleState = preload("res://src/application/lifecycle/run_lifecycle_state.gd")
const ResurrectionService = preload("res://src/application/lifecycle/resurrection_service.gd")
const EndRunService = preload("res://src/application/lifecycle/end_run_service.gd")
const RunProfileProjection = preload("res://src/application/lifecycle/run_profile_projection.gd")
const PlayerProfile = preload("res://src/domain/player/player_profile.gd")
const BodyResurrectionStub = preload("res://tests/headless/fixtures/body_resurrection_stub.gd")

var _failures: Array[String] = []


func _init() -> void:
	_run()
	if _failures.is_empty():
		print("PASS run_lifecycle_profile_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL run_lifecycle_profile_test: %d failure(s)" % _failures.size())
	quit(1)


func _run() -> void:
	var run = RunLifecycleState.new(&"run_001")
	_expect_equal(run.lifecycle, RunLifecycleState.Lifecycle.ACTIVE, "new run starts active")
	_expect_true(run.mark_dead(&"falling_palm").ok, "grounded death transitions active run to dead")
	_expect_equal(run.lifecycle, RunLifecycleState.Lifecycle.DEAD, "death lifecycle")
	_expect_equal(run.death_count, 1, "death count increments once")
	_expect_false(run.mark_dead(&"second_death").ok, "dead run cannot admit duplicate death")

	var body_port = BodyResurrectionStub.new()
	body_port.should_accept = false
	var resurrection = ResurrectionService.new(run, body_port)
	_expect_false(resurrection.resurrect().ok, "rejected physical resurrection does not change lifecycle")
	_expect_equal(run.lifecycle, RunLifecycleState.Lifecycle.DEAD, "failed physical resurrection leaves run dead")
	_expect_equal(run.resurrection_count, 0, "failed resurrection does not increment count")

	body_port.should_accept = true
	_expect_true(resurrection.resurrect().ok, "accepted physical resurrection revives current run")
	_expect_equal(run.lifecycle, RunLifecycleState.Lifecycle.ACTIVE, "successful resurrection restores active lifecycle")
	_expect_equal(run.resurrection_count, 1, "successful resurrection increments count")
	_expect_equal(body_port.last_run_id, &"run_001", "resurrection port receives current run id")

	var profile = PlayerProfile.new()
	var fire_knowledge = DomainId.new(DomainId.Kind.KNOWLEDGE, &"fire_safety")
	var projection = RunProfileProjection.new(
		[fire_knowledge],
		[{
			"entry_id": &"first_fire",
			"text": "Wilson discovered a safer way to handle fire.",
			"wilson_accessible": true,
		}],
		{&"runs_completed": 1, &"resurrections": 1},
		[&"fire_diary_page"]
	)
	var end_run = EndRunService.new(run, profile)
	_expect_true(end_run.end_run(&"player_ended", projection).ok, "EndRun admits explicit cross-run projection")
	_expect_equal(run.lifecycle, RunLifecycleState.Lifecycle.ENDED, "EndRun closes current run")
	_expect_true(profile.has_legacy_knowledge(fire_knowledge), "explicit legacy knowledge reaches player profile")
	_expect_equal(profile.diary_archive().size(), 1, "explicit diary projection is archived")
	_expect_equal(profile.stat(&"runs_completed"), 1, "lifetime statistics receive admitted delta")
	_expect_equal(profile.stat(&"resurrections"), 1, "resurrection statistic receives admitted delta")
	_expect_true(profile.is_unlocked(&"fire_diary_page"), "explicit global unlock reaches profile")
	_expect_false(resurrection.resurrect().ok, "ended run cannot be resurrected")
	_expect_false(end_run.end_run(&"again", projection).ok, "ended run cannot be admitted twice")


func _expect_true(actual: bool, label: String) -> void:
	if not actual:
		_failures.append("Expected true: %s" % label)


func _expect_false(actual: bool, label: String) -> void:
	if actual:
		_failures.append("Expected false: %s" % label)


func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
