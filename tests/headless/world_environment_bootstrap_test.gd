extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const DynamicProcessInstance = preload("res://src/domain/world/dynamic_process_instance.gd")
const DynamicProcessBootstrapSeed = preload("res://src/application/bootstrap/dynamic_process_bootstrap_seed.gd")
const SimulationBootstrapDefinition = preload("res://src/application/bootstrap/simulation_bootstrap_definition.gd")
const SimulationOwnerBootstrapper = preload("res://src/application/bootstrap/simulation_owner_bootstrapper.gd")

var _failures: Array[String] = []
var _completed := false


func _init() -> void:
	_run()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS world_environment_bootstrap_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL world_environment_bootstrap_test: %d failure(s)" % _failures.size())
	quit(1)


func _run() -> void:
	var place_id = DomainId.place(&"storm_camp")
	var subject = RuntimeWorldRef.entity(DomainId.entity(&"storm_crate"))
	var seed = DynamicProcessBootstrapSeed.new(
		&"weaken_crate_1",
		&"storm_weakening_object",
		subject,
		DynamicProcessInstance.Lifecycle.PAUSED,
		12.5
	)
	var definition = SimulationBootstrapDefinition.new(
		place_id,
		[], [], [], null,
		1.0,
		{},
		[], [], [], [], null,
		&"storm",
		&"dusk",
		[seed]
	)
	var first = SimulationOwnerBootstrapper.new().bootstrap(definition)
	var second = SimulationOwnerBootstrapper.new().bootstrap(definition)

	_expect_true(first.ok and second.ok, "environment-bearing bootstrap succeeds")
	if not first.ok or not second.ok:
		_completed = true
		return

	_expect_equal(first.owners.environment.weather, &"storm", "bootstrap preserves weather")
	_expect_equal(first.owners.environment.daylight_phase, &"dusk", "bootstrap preserves daylight phase")
	var first_process = first.owners.dynamic_processes.get_process(&"weaken_crate_1")
	var second_process = second.owners.dynamic_processes.get_process(&"weaken_crate_1")
	_expect_true(first_process != null and second_process != null, "dynamic process seed reconstructs owner state")
	if first_process != null and second_process != null:
		_expect_equal(first_process.definition_id, &"storm_weakening_object", "dynamic process definition survives bootstrap")
		_expect_equal(first_process.subject.sort_key(), subject.sort_key(), "dynamic process subject survives bootstrap")
		_expect_equal(first_process.lifecycle, DynamicProcessInstance.Lifecycle.PAUSED, "dynamic process lifecycle survives bootstrap")
		_expect_true(is_equal_approx(first_process.elapsed, 12.5), "dynamic process elapsed survives bootstrap")
		_expect_true(first_process != second_process, "rebootstrap creates fresh dynamic process instance")

	_expect_true(first.owners.environment != second.owners.environment, "rebootstrap creates fresh environment owner")
	_expect_true(first.owners.dynamic_processes != second.owners.dynamic_processes, "rebootstrap creates fresh dynamic process store")
	first.owners.environment.set_weather(&"clear")
	first.owners.dynamic_processes.set_lifecycle(&"weaken_crate_1", DynamicProcessInstance.Lifecycle.ACTIVE)
	if first_process != null:
		first_process.elapsed = 20.0
	_expect_equal(second.owners.environment.weather, &"storm", "environment mutation is isolated between bootstraps")
	if second_process != null:
		_expect_equal(second_process.lifecycle, DynamicProcessInstance.Lifecycle.PAUSED, "process lifecycle mutation is isolated")
		_expect_true(is_equal_approx(second_process.elapsed, 12.5), "process elapsed mutation is isolated")
	_expect_equal(seed.lifecycle, DynamicProcessInstance.Lifecycle.PAUSED, "bootstrap does not mutate dynamic process seed")
	_expect_true(is_equal_approx(seed.elapsed, 12.5), "bootstrap preserves dynamic process seed elapsed")

	var defaults = SimulationOwnerBootstrapper.new().bootstrap(SimulationBootstrapDefinition.new(place_id))
	_expect_true(defaults.ok, "default environment bootstrap succeeds")
	if defaults.ok:
		_expect_equal(defaults.owners.environment.weather, &"clear", "new-run default weather is clear")
		_expect_equal(defaults.owners.environment.daylight_phase, &"day", "new-run default daylight phase is day")
		_expect_equal(defaults.owners.dynamic_processes.instances().size(), 0, "new-run default dynamic process store starts empty")

	_completed = true


func _expect_true(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _expect_equal(actual: Variant, expected: Variant, message: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [message, expected, actual])
