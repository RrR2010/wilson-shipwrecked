extends SceneTree

const InterventionDefinition = preload("res://src/domain/player/intervention_definition.gd")
const PhysicalInterventionRequest = preload("res://src/domain/player/physical_intervention_request.gd")
const PlayerRunState = preload("res://src/domain/player/player_run_state.gd")
const PlayerInterventionService = preload("res://src/application/simulation/player_intervention_service.gd")
const WorldInterventionStub = preload("res://tests/headless/fixtures/world_intervention_stub.gd")

var _failures: Array[String] = []

func _init() -> void:
	_run()
	if _failures.is_empty():
		print("PASS player_intervention_integration_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL player_intervention_integration_test: %d failure(s)" % _failures.size())
	quit(1)

func _run() -> void:
	var definition = InterventionDefinition.new(&"move_small_object", &"move_small_object", 3.0)
	var request = PhysicalInterventionRequest.new(&"move_small_object", {"entity": "coconut_1", "destination": "camp"})

	var no_permission = PlayerRunState.new(10.0)
	var world = WorldInterventionStub.new(true)
	var service = PlayerInterventionService.new(no_permission, world, [definition])
	var result = service.apply(request)
	_expect_false(result.ok, "missing permission rejects intervention")
	_expect_equal(no_permission.god_power, 10.0, "permission rejection does not spend God Power")
	_expect_equal(world.calls, 0, "permission rejection never reaches World")

	var insufficient = PlayerRunState.new(2.0, [&"move_small_object"])
	world = WorldInterventionStub.new(true)
	service = PlayerInterventionService.new(insufficient, world, [definition])
	result = service.apply(request)
	_expect_false(result.ok, "insufficient God Power rejects intervention")
	_expect_equal(insufficient.god_power, 2.0, "insufficient balance remains unchanged")
	_expect_equal(world.calls, 0, "insufficient balance never reaches World")

	var rejected = PlayerRunState.new(10.0, [&"move_small_object"])
	rejected.non_intervention_seconds = 20.0
	world = WorldInterventionStub.new(false)
	service = PlayerInterventionService.new(rejected, world, [definition])
	result = service.apply(request)
	_expect_false(result.ok, "World may reject otherwise affordable intervention")
	_expect_equal(rejected.god_power, 10.0, "World rejection does not spend God Power")
	_expect_equal(rejected.non_intervention_seconds, 20.0, "World rejection does not break non-intervention progress")
	_expect_equal(world.calls, 1, "validated request reaches World exactly once")

	var accepted = PlayerRunState.new(10.0, [&"move_small_object"])
	accepted.non_intervention_seconds = 20.0
	world = WorldInterventionStub.new(true)
	service = PlayerInterventionService.new(accepted, world, [definition])
	result = service.apply(request)
	_expect_true(result.ok, "World-accepted intervention commits")
	_expect_equal(accepted.god_power, 7.0, "successful intervention spends authored cost")
	_expect_equal(accepted.non_intervention_seconds, 0.0, "successful intervention breaks non-intervention streak")
	_expect_equal(world.calls, 1, "successful intervention reaches World exactly once")

func _expect_true(actual: bool, label: String) -> void:
	if not actual: _failures.append("Expected true: %s" % label)

func _expect_false(actual: bool, label: String) -> void:
	if actual: _failures.append("Expected false: %s" % label)

func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected: _failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
