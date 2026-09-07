extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const MutationResult = preload("res://src/domain/core/mutation_result.gd")
const RoleBinding = preload("res://src/domain/actions/role_binding.gd")
const WorldEvent = preload("res://src/domain/actions/world_event.gd")
const InterventionDefinition = preload("res://src/domain/player/intervention_definition.gd")
const PhysicalInterventionRequest = preload("res://src/domain/player/physical_intervention_request.gd")
const PlayerRunState = preload("res://src/domain/player/player_run_state.gd")
const PlayerInterventionService = preload("res://src/application/simulation/player_intervention_service.gd")
const PerceptionAccess = preload("res://src/domain/cognition/perception_access.gd")
const PerceptionService = preload("res://src/domain/cognition/perception_service.gd")
const PresenceAttributionRule = preload("res://src/domain/cognition/presence_attribution_rule.gd")
const PresenceAttributionService = preload("res://src/domain/cognition/presence_attribution_service.gd")
const PresenceRelationship = preload("res://src/domain/cognition/presence_relationship.gd")
const PresenceLearningService = preload("res://src/domain/cognition/presence_learning_service.gd")
const PresenceLearningCoordinator = preload("res://src/application/simulation/presence_learning_coordinator.gd")

class FixtureWorldInterventionPort:
	extends RefCounted

	var committed_events: Array = []
	var calls: int = 0

	func apply_intervention(request):
		calls += 1
		var object_ref = request.payload.get("object_ref")
		if object_ref == null:
			return MutationResult.failure(&"missing_object", [])
		var bindings = RoleBinding.new()
		bindings.bind(&"object", object_ref)
		committed_events.append(WorldEvent.new(
			DomainId.event_definition(&"object_moved_unexplained"),
			null,
			bindings,
			&"exec_player_move_1"
		))
		return MutationResult.success(&"world_committed")

var _failures: Array[String] = []
var _completed := false


func _init() -> void:
	_run_slice()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS player_intervention_presence_attribution_integration_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL player_intervention_presence_attribution_integration_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_slice() -> void:
	var coconut = RuntimeWorldRef.entity(DomainId.entity(&"coconut_1"))
	var player_state = PlayerRunState.new(10.0, [&"move_small_object"])
	var world_port = FixtureWorldInterventionPort.new()
	var intervention = PlayerInterventionService.new(
		player_state,
		world_port,
		[InterventionDefinition.new(&"move_small_object", &"move_small_object", 2.0)]
	)
	var request = PhysicalInterventionRequest.new(
		&"move_small_object",
		{
			"object_ref": coconut,
			"destination": "near_wilson",
			"private_intent": "help_wilson"
		}
	)

	var result = intervention.apply(request)
	_expect_true(result.ok, "player intervention commits through the World boundary")
	_expect_equal(world_port.calls, 1, "World receives the intervention exactly once")
	_expect_equal(player_state.god_power, 8.0, "successful intervention spends authored God Power")
	_expect_equal(world_port.committed_events.size(), 1, "World emits one authoritative consequence event")

	var perception = PerceptionService.new()
	var perceived = perception.perceive(
		world_port.committed_events,
		{&"exec_player_move_1": PerceptionAccess.new(true, [&"vision"], [&"object"], 0.85)}
	)
	_expect_equal(perceived.evidence.size(), 1, "Wilson receives evidence from the world consequence only")

	var attribution = PresenceAttributionService.new([
		PresenceAttributionRule.new(
			DomainId.event_definition(&"object_moved_unexplained"),
			&"object",
			0.7,
			0.5,
			0.25,
			0.5,
			&"vision"
		)
	])
	var proposals: Array = attribution.derive(perceived)
	_expect_equal(proposals.size(), 1, "visible unexplained intervention consequence becomes one Presence attribution")

	var presence = PresenceRelationship.new()
	var learning = PresenceLearningCoordinator.new(PresenceLearningService.new(), presence)
	if proposals.size() == 1:
		_expect_equal(proposals[0].source_execution_id, &"exec_player_move_1", "Presence attribution preserves world-event provenance")
		_expect_true(is_equal_approx(proposals[0].confidence, 0.85), "Presence attribution confidence comes from perception")
		learning.process(proposals[0])

	_expect_equal(presence.evidence_count, 1, "Presence changes only after perceived attributed evidence")
	_expect_true(presence.presence_belief > 0.0, "unexplained visible effect increases Presence belief")
	_expect_true(presence.trust > 0.0, "authored helpful effect increases Presence trust")
	_expect_true(presence.dependency > 0.0, "authored helpful effect can increase dependency")
	_completed = true


func _expect_true(actual: bool, label: String) -> void:
	if not actual:
		_failures.append("Expected true: %s" % label)


func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
