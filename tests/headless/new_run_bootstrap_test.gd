extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const ContentRegistry = preload("res://src/domain/content/content_registry.gd")
const SimulationBootstrapDefinition = preload("res://src/application/bootstrap/simulation_bootstrap_definition.gd")
const NewRunDefinition = preload("res://src/application/bootstrap/new_run_definition.gd")
const NewRunBootstrapService = preload("res://src/application/bootstrap/new_run_bootstrap_service.gd")
const DriveState = preload("res://src/domain/cognition/drive_state.gd")
const RunLifecycleState = preload("res://src/application/lifecycle/run_lifecycle_state.gd")

var _failures: Array[String] = []
var _completed := false


func _init() -> void:
	_run_slice()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS new_run_bootstrap_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL new_run_bootstrap_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_slice() -> void:
	var content = ContentRegistry.new()
	_expect_true(content.seal().ok, "empty authored content seals")

	var simulation = SimulationBootstrapDefinition.new(
		DomainId.place(&"new_run_island"),
		[],
		[],
		[],
		null,
		1.0,
		{DriveState.HUNGER: 0.35}
	)
	var definition = NewRunDefinition.new(
		&"run_new_001",
		73001,
		simulation,
		4.5,
		[&"move_small_object"]
	)
	var service = NewRunBootstrapService.new()
	var first = service.bootstrap(definition, content)
	var second = service.bootstrap(definition, content)

	_expect_true(first.ok, "first new run bootstraps")
	_expect_true(second.ok, "second equivalent new run bootstraps")
	if not first.ok or not second.ok:
		_completed = true
		return

	_expect_equal(first.code, &"new_run_bootstrapped", "new-run success code")
	_expect_equal(first.run_id, &"run_new_001", "run id is preserved")
	_expect_equal(first.gameplay_seed, 73001, "gameplay seed is preserved")
	_expect_true(first.owners != null, "authoritative simulation owners are returned")
	_expect_true(first.runtime != null, "reconstructible runtime is composed")
	_expect_true(first.run_lifecycle != null, "current-run lifecycle owner is created")
	_expect_true(first.director != null, "director owner is created")
	_expect_true(first.player != null, "player run owner is created")

	_expect_equal(first.run_lifecycle.run_id, &"run_new_001", "lifecycle belongs to requested run")
	_expect_equal(first.run_lifecycle.lifecycle, RunLifecycleState.Lifecycle.ACTIVE, "fresh run starts active")
	_expect_equal(first.run_lifecycle.death_count, 0, "fresh run has no admitted deaths")
	_expect_equal(first.director.states().size(), 0, "fresh director starts without active opportunities")
	_expect_equal(first.player.god_power, 4.5, "initial God Power is admitted")
	_expect_true(first.player.has_permission(&"move_small_object"), "initial permission is admitted")
	_expect_equal(first.player.non_intervention_seconds, 0.0, "fresh player run has no elapsed non-intervention")
	_expect_equal(first.owners.drives.value(DriveState.HUNGER), 0.35, "simulation bootstrap causes reach cognition owner")

	_expect_true(first.owners != second.owners, "equivalent new runs receive fresh owner carriers")
	_expect_true(first.owners.drives != second.owners.drives, "equivalent new runs do not alias DriveState")
	_expect_true(first.runtime != second.runtime, "equivalent new runs receive fresh runtime composition")
	_expect_true(first.runtime.action_execution != second.runtime.action_execution, "ActionExecution runtime is reconstructed per run")
	_expect_true(first.run_lifecycle != second.run_lifecycle, "run lifecycle does not alias across bootstraps")
	_expect_true(first.director != second.director, "director state does not alias across bootstraps")
	_expect_true(first.player != second.player, "player run state does not alias across bootstraps")
	_expect_equal(second.owners.drives.value(DriveState.HUNGER), 0.35, "equivalent durable causes reproduce initial hunger")
	_expect_equal(second.player.god_power, 4.5, "equivalent durable causes reproduce player run seed")

	first.owners.drives.set_value(DriveState.HUNGER, 0.9)
	first.player.spend(1.0)
	_expect_equal(second.owners.drives.value(DriveState.HUNGER), 0.35, "mutating one run does not affect another run's cognition")
	_expect_equal(second.player.god_power, 4.5, "mutating one run does not affect another player run owner")

	_completed = true


func _expect_true(actual: bool, label: String) -> void:
	if not actual:
		_failures.append("Expected true: %s" % label)


func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
