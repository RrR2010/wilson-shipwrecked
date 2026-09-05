extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const ActorStateBootstrapSeed = preload("res://src/application/bootstrap/actor_state_bootstrap_seed.gd")
const SimulationBootstrapDefinition = preload("res://src/application/bootstrap/simulation_bootstrap_definition.gd")
const SimulationOwnerBootstrapper = preload("res://src/application/bootstrap/simulation_owner_bootstrapper.gd")

var _failures: Array[String] = []
var _completed := false


func _init() -> void:
	_run()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS actor_state_bootstrap_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL actor_state_bootstrap_test: %d failure(s)" % _failures.size())
	quit(1)


func _run() -> void:
	var place_id = DomainId.place(&"actor_bootstrap_beach")
	var actor = RuntimeWorldRef.entity(DomainId.entity(&"gerald"))
	var seed = ActorStateBootstrapSeed.new(actor, &"shore_crab", &"fleeing", 1.75, &"flee_wilson")
	var definition = SimulationBootstrapDefinition.new(
		place_id, [], [], [], null, 1.0, {}, [], [], [], [], null, &"clear", &"day", [], [seed]
	)
	var first = SimulationOwnerBootstrapper.new().bootstrap(definition)
	var second = SimulationOwnerBootstrapper.new().bootstrap(definition)
	_expect_true(first.ok and second.ok, "actor-bearing bootstrap succeeds")
	if not first.ok or not second.ok:
		_completed = true
		return

	var first_state = first.owners.actors.get_state(actor)
	var second_state = second.owners.actors.get_state(actor)
	_expect_true(first_state != null and second_state != null, "actor seed reconstructs owner state")
	if first_state == null or second_state == null:
		_completed = true
		return
	_expect_equal(first_state.profile_id, &"shore_crab", "actor profile survives bootstrap")
	_expect_equal(first_state.mode, &"fleeing", "actor mode survives bootstrap")
	_expect_float(first_state.decision_cooldown, 1.75, "actor cooldown survives bootstrap")
	_expect_equal(first_state.last_rule_id, &"flee_wilson", "actor rule provenance survives bootstrap")
	_expect_true(first.owners.actors != second.owners.actors, "rebootstrap creates fresh actor store")
	_expect_true(first_state != second_state, "rebootstrap creates fresh actor state")

	first_state.mode = &"idle"
	first_state.decision_cooldown = 0.25
	_expect_equal(second_state.mode, &"fleeing", "second actor state is isolated from first mutation")
	_expect_float(second_state.decision_cooldown, 1.75, "second actor cooldown is isolated from first mutation")
	_expect_equal(seed.mode, &"fleeing", "bootstrap does not mutate actor seed mode")
	_expect_float(seed.decision_cooldown, 1.75, "bootstrap does not mutate actor seed cooldown")

	var empty = SimulationOwnerBootstrapper.new().bootstrap(SimulationBootstrapDefinition.new(place_id))
	_expect_true(empty.ok, "default actor bootstrap succeeds")
	if empty.ok:
		_expect_equal(empty.owners.actors.states().size(), 0, "new-run default actor store starts empty")

	_completed = true


func _expect_true(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _expect_equal(actual: Variant, expected: Variant, message: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [message, expected, actual])


func _expect_float(actual: Variant, expected: float, message: String) -> void:
	if actual == null or not is_equal_approx(float(actual), expected):
		_failures.append("%s | expected=%s actual=%s" % [message, expected, actual])
