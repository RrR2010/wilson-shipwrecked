extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const RoleBinding = preload("res://src/domain/actions/role_binding.gd")
const DecisionCandidate = preload("res://src/domain/cognition/decision_candidate.gd")
const DecisionRouter = preload("res://src/domain/cognition/decision_router.gd")
const DirectedOpportunityDefinition = preload("res://src/domain/director/directed_opportunity_definition.gd")
const DirectorStateStore = preload("res://src/domain/director/director_state_store.gd")
const DirectorOpportunityState = preload("res://src/domain/director/director_opportunity_state.gd")
const DirectorOpportunityService = preload("res://src/domain/director/director_opportunity_service.gd")
const DirectorCandidateSource = preload("res://src/domain/director/director_candidate_source.gd")
const PlayerRunState = preload("res://src/domain/player/player_run_state.gd")
const PlayerSuggestionService = preload("res://src/domain/player/player_suggestion_service.gd")
const PlayerSuggestionCandidateSource = preload("res://src/domain/player/player_suggestion_candidate_source.gd")
const DirectorPlayerSnapshotService = preload("res://src/infrastructure/persistence/director_player_snapshot_service.gd")

var _failures: Array[String] = []

func _init() -> void:
	_run()
	if _failures.is_empty():
		print("PASS director_player_state_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL director_player_state_test: %d failure(s)" % _failures.size())
	quit(1)

func _run() -> void:
	var inspect = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"inspect_shell")
	var rest = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"rest")
	var shell = RuntimeWorldRef.entity(DomainId.entity(&"shell_1"))
	var binding = RoleBinding.new()
	binding.bind(&"target", shell)

	var definition = DirectedOpportunityDefinition.new(&"shell_scene", inspect, binding, 0.15, 5.0, 2)
	var director_store = DirectorStateStore.new()
	var director_service = DirectorOpportunityService.new(director_store, [definition])
	var director_source = DirectorCandidateSource.new(director_store, [definition])
	_expect_true(director_service.activate(&"shell_scene"), "eligible opportunity activates")
	_expect_equal(director_source.generate().size(), 1, "active opportunity produces one bounded candidate")
	var director_candidate = director_source.generate()[0]
	_expect_equal(director_candidate.external_bias, 0.15, "Director bias remains bounded external bias")
	_expect_equal(director_candidate.provenance["source"], "director", "Director provenance is explicit")

	var router = DecisionRouter.new()
	var rest_candidate = DecisionCandidate.new(rest, RoleBinding.new(), DecisionCandidate.Scope.INTENTIONAL, 0.4)
	var decision = router.resolve([director_candidate, rest_candidate])
	_expect_equal(decision.selected.intention_id.key(), rest.key(), "Director opportunity does not force Wilson over stronger ordinary candidate")

	_expect_true(director_service.resolve(&"shell_scene"), "active opportunity resolves")
	var state = director_store.get_state(&"shell_scene")
	_expect_equal(state.lifecycle, DirectorOpportunityState.Lifecycle.COOLDOWN, "first resolution enters cooldown")
	director_service.advance(5.0)
	_expect_equal(state.lifecycle, DirectorOpportunityState.Lifecycle.ELIGIBLE, "cooldown returns opportunity to eligible")
	_expect_true(director_service.activate(&"shell_scene"), "opportunity can activate second authored time")
	_expect_true(director_service.resolve(&"shell_scene"), "second activation resolves")
	_expect_equal(state.lifecycle, DirectorOpportunityState.Lifecycle.EXHAUSTED, "max activations exhaust opportunity")

	var player = PlayerRunState.new(10.0, [&"move_small_object"])
	var suggestion_service = PlayerSuggestionService.new(player, 2)
	var suggestion_source = PlayerSuggestionCandidateSource.new(player)
	_expect_true(suggestion_service.suggest(inspect, binding, 0.2), "player can create bounded suggestion")
	_expect_equal(suggestion_source.generate().size(), 1, "active suggestion produces one candidate")
	var suggestion_candidate = suggestion_source.generate()[0]
	_expect_equal(suggestion_candidate.external_bias, 0.2, "suggestion contributes bounded bias")
	decision = router.resolve([suggestion_candidate, rest_candidate])
	_expect_equal(decision.selected.intention_id.key(), rest.key(), "suggestion remains a signal rather than a command")
	_expect_true(suggestion_service.insist(), "first insistence is available")
	_expect_true(suggestion_service.insist(), "second insistence is available")
	_expect_false(suggestion_service.insist(), "insistence is bounded")

	player.record_non_intervention(12.0)
	var snapshots = DirectorPlayerSnapshotService.new()
	var snapshot = snapshots.capture(director_store, player)
	_expect_equal(snapshot["schema_version"], 1, "Director/player snapshot schema")
	var restored = snapshots.restore(JSON.parse_string(JSON.stringify(snapshot)))
	var restored_state = restored.director.get_state(&"shell_scene")
	_expect_equal(restored_state.lifecycle, DirectorOpportunityState.Lifecycle.EXHAUSTED, "Director lifecycle survives round-trip")
	_expect_equal(restored_state.activation_count, 2, "Director activation count survives round-trip")
	_expect_equal(restored.player.god_power, 10.0, "God Power survives round-trip")
	_expect_true(restored.player.has_permission(&"move_small_object"), "player permission survives round-trip")
	_expect_equal(restored.player.non_intervention_seconds, 12.0, "non-intervention progress survives round-trip")
	_expect_true(restored.player.active_suggestion != null, "active suggestion survives round-trip")
	if restored.player.active_suggestion != null:
		_expect_equal(restored.player.active_suggestion.remaining_insistence, 0, "suggestion insistence state survives round-trip")
		_expect_equal(restored.player.active_suggestion.bindings.get_subject(&"target").sort_key(), shell.sort_key(), "suggestion bindings survive round-trip")

func _expect_true(actual: bool, label: String) -> void:
	if not actual: _failures.append("Expected true: %s" % label)

func _expect_false(actual: bool, label: String) -> void:
	if actual: _failures.append("Expected false: %s" % label)

func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected: _failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
