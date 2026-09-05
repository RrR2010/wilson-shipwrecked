extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const DriveState = preload("res://src/domain/cognition/drive_state.gd")
const SimulationBootstrapDefinition = preload("res://src/application/bootstrap/simulation_bootstrap_definition.gd")
const SimulationOwnerBootstrapper = preload("res://src/application/bootstrap/simulation_owner_bootstrapper.gd")

var _failures: Array[String] = []


func _init() -> void:
	_run()
	if _failures.is_empty():
		print("PASS drive_bootstrap_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL drive_bootstrap_test: %d failure(s)" % _failures.size())
	quit(1)


func _run() -> void:
	var place_id = DomainId.place(&"drive_bootstrap_island")
	var drive_values = {
		DriveState.HUNGER: 0.82,
		DriveState.ENERGY: 0.31,
		DriveState.COMFORT: 0.44,
		DriveState.STIMULATION: 0.63,
	}
	var definition = SimulationBootstrapDefinition.new(place_id, [], [], [], null, 1.0, drive_values)
	var first = SimulationOwnerBootstrapper.new().bootstrap(definition)
	var second = SimulationOwnerBootstrapper.new().bootstrap(definition)

	_expect_true(first.ok and second.ok, "drive-bearing bootstrap succeeds")
	if not first.ok or not second.ok:
		return
	_expect_equal(first.owners.drives.snapshot_values(), drive_values, "bootstrap preserves declared drive values")
	_expect_equal(first.owners.drives.band(DriveState.HUNGER), DriveState.UrgencyBand.URGENT, "derived drive band reconstructs from durable value")
	_expect_true(first.owners.drives != second.owners.drives, "rebootstrap creates fresh DriveState owner")

	first.owners.drives.set_value(DriveState.HUNGER, 0.1)
	_expect_true(is_equal_approx(second.owners.drives.value(DriveState.HUNGER), 0.82), "rebootstrap DriveState remains independent")
	_expect_true(is_equal_approx(float(definition.drive_values[DriveState.HUNGER]), 0.82), "bootstrap does not mutate declarative drive values")

	var default_result = SimulationOwnerBootstrapper.new().bootstrap(SimulationBootstrapDefinition.new(place_id))
	_expect_true(default_result.ok, "default drive bootstrap succeeds")
	if default_result.ok:
		for drive_id in DriveState.DRIVE_IDS:
			_expect_true(is_zero_approx(default_result.owners.drives.value(drive_id)), "new-run default drive starts at zero: %s" % String(drive_id))


func _expect_true(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
