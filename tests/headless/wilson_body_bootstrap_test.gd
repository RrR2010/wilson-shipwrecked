extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const SimulationBootstrapDefinition = preload("res://src/application/bootstrap/simulation_bootstrap_definition.gd")
const SimulationOwnerBootstrapper = preload("res://src/application/bootstrap/simulation_owner_bootstrapper.gd")

var _failures: Array[String] = []


func _init() -> void:
	_run()
	if _failures.is_empty():
		print("PASS wilson_body_bootstrap_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL wilson_body_bootstrap_test: %d failure(s)" % _failures.size())
	quit(1)


func _run() -> void:
	var place_id = DomainId.place(&"body_bootstrap_island")
	var definition = SimulationBootstrapDefinition.new(place_id, [], [], [], null, 0.35)
	var first = SimulationOwnerBootstrapper.new().bootstrap(definition)
	var second = SimulationOwnerBootstrapper.new().bootstrap(definition)

	_expect_true(first.ok and second.ok, "body-bearing bootstrap succeeds")
	if not first.ok or not second.ok:
		return
	_expect_true(first.owners.wilson_body_state != null, "bootstrap exposes Wilson body authority")
	_expect_true(is_equal_approx(first.owners.wilson_body_state.vitality, 0.35), "bootstrap preserves declared vitality")
	_expect_true(first.owners.wilson_body_state.alive, "positive vitality reconstructs alive body truth")
	_expect_true(first.owners.wilson_body_state != second.owners.wilson_body_state, "rebootstrap creates fresh body owner")
	_expect_true(is_equal_approx(second.owners.wilson_body_state.vitality, 0.35), "fresh body owner has equivalent durable cause")

	first.owners.wilson_body_state.apply_damage(0.35)
	_expect_true(not first.owners.wilson_body_state.alive, "body mutation changes only first owner instance")
	_expect_true(second.owners.wilson_body_state.alive, "rebootstrap owner remains independent")
	_expect_true(is_equal_approx(second.owners.wilson_body_state.vitality, 0.35), "rebootstrap owner is not mutated through shared definition state")

	var default_result = SimulationOwnerBootstrapper.new().bootstrap(SimulationBootstrapDefinition.new(place_id))
	_expect_true(default_result.ok, "default body bootstrap succeeds")
	if default_result.ok:
		_expect_true(is_equal_approx(default_result.owners.wilson_body_state.vitality, 1.0), "new-run default body starts at full vitality")
		_expect_true(default_result.owners.wilson_body_state.alive, "new-run default body starts alive")


func _expect_true(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)
