extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const DriveState = preload("res://src/domain/cognition/drive_state.gd")
const DriveCandidateDefinition = preload("res://src/domain/cognition/drive_candidate_definition.gd")
const DriveCandidateSource = preload("res://src/domain/cognition/drive_candidate_source.gd")
const DecisionCandidate = preload("res://src/domain/cognition/decision_candidate.gd")
const DecisionRouter = preload("res://src/domain/cognition/decision_router.gd")
const RoleBinding = preload("res://src/domain/actions/role_binding.gd")

var _failures: Array[String] = []
var _completed := false


func _init() -> void:
	_run_slice()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS drive_state_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL drive_state_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_slice() -> void:
	var drives = DriveState.new({
		DriveState.HUNGER: 0.50,
		DriveState.ENERGY: 0.10,
		DriveState.COMFORT: 0.20,
		DriveState.STIMULATION: 0.30,
	})

	var first = drives.advance(1.0, {DriveState.HUNGER: 0.04})
	_expect_equal(drives.band(DriveState.HUNGER), DriveState.UrgencyBand.CALM, "small change below enter threshold stays calm")
	_expect_false(first.requires_reconsideration(), "small change does not request reconsideration")

	var crossing = drives.advance(1.0, {DriveState.HUNGER: 0.02})
	_expect_equal(drives.band(DriveState.HUNGER), DriveState.UrgencyBand.PRESSING, "crossing enter threshold becomes pressing")
	_expect_true(crossing.requires_reconsideration(), "upward urgency crossing requests reconsideration once")
	_expect_equal(crossing.upward_band_crossings.size(), 1, "one drive crosses one urgency band")

	var stable_pressing = drives.advance(1.0, {DriveState.HUNGER: -0.05})
	_expect_equal(drives.band(DriveState.HUNGER), DriveState.UrgencyBand.PRESSING, "hysteresis prevents threshold chatter")
	_expect_false(stable_pressing.requires_reconsideration(), "remaining in band does not spam reconsideration")

	drives.advance(1000.0, {DriveState.HUNGER: 1.0, DriveState.ENERGY: -1.0})
	_expect_equal(drives.value(DriveState.HUNGER), 1.0, "drive progression saturates at upper bound")
	_expect_equal(drives.value(DriveState.ENERGY), 0.0, "drive progression saturates at lower bound")

	var eat_id = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"seek_food")
	var explore_id = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"explore")
	var evade_id = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"evade_threat")
	var definition = DriveCandidateDefinition.new(DriveState.HUNGER, eat_id, 0.1)
	var source = DriveCandidateSource.new(drives, [definition])
	var candidates = source.generate()
	_expect_equal(candidates.size(), 1, "urgent hunger produces one semantic candidate")
	if candidates.size() != 1:
		return
	_expect_equal(candidates[0].intention_id.key(), eat_id.key(), "drive candidate keeps semantic intention")
	_expect_true(candidates[0].urgency_score > 0.0 and candidates[0].urgency_score <= 1.0, "drive urgency contribution remains bounded")
	_expect_equal(candidates[0].provenance["source"], "drive", "candidate exposes drive provenance")

	var explore = DecisionCandidate.new(explore_id, RoleBinding.new(), DecisionCandidate.Scope.INTENTIONAL, 0.95)
	var router = DecisionRouter.new()
	var ordinary_competition = router.resolve([candidates[0], explore], null)
	_expect_equal(ordinary_competition.selected_candidate.intention_id.key(), explore_id.key(), "drive candidate can lose ordinary competition")

	var threat = DecisionCandidate.new(evade_id, RoleBinding.new(), DecisionCandidate.Scope.IMMEDIATE_THREAT, -1.0)
	var threat_result = router.resolve([candidates[0], explore, threat], null)
	_expect_equal(String(threat_result.regime), "immediate_threat", "immediate threat still wins by routing regime")
	_expect_equal(threat_result.selected_candidate.intention_id.key(), evade_id.key(), "threat regime is not emulated with giant urgency score")

	var snapshot := drives.snapshot_values()
	var restored = DriveState.new()
	restored.restore_values(snapshot)
	_expect_equal(restored.snapshot_values(), snapshot, "drive values support deterministic artificial snapshot restore")

	_completed = true


func _expect_true(actual: bool, label: String) -> void:
	if not actual:
		_failures.append("Expected true: %s" % label)


func _expect_false(actual: bool, label: String) -> void:
	if actual:
		_failures.append("Expected false: %s" % label)


func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
