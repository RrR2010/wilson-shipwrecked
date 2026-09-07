extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RoleBinding = preload("res://src/domain/actions/role_binding.gd")
const CurrentIntentionStore = preload("res://src/domain/cognition/current_intention_store.gd")
const DecisionCandidate = preload("res://src/domain/cognition/decision_candidate.gd")
const DecisionSelectionResult = preload("res://src/domain/cognition/decision_selection_result.gd")
const DecisionCommitCoordinator = preload("res://src/application/simulation/decision_commit_coordinator.gd")
const InterruptedIntentionResumeCoordinator = preload("res://src/application/simulation/interrupted_intention_resume_coordinator.gd")

var _failures: Array[String] = []
var _completed := false


class ExecutorStub:
	extends RefCounted
	var calls: int = 0
	var last_intention = null
	func apply(intention_state) -> Dictionary:
		calls += 1
		last_intention = intention_state
		return {"handled": true, "moving": true, "reason": &"resumed_move"}


func _init() -> void:
	_run_slice()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS intention_interruption_resume_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL intention_interruption_resume_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_slice() -> void:
	var forage = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"forage_coconuts")
	var dodge = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"dodge_threat")
	var bindings = RoleBinding.new()
	var store = CurrentIntentionStore.new()
	store.select(forage, bindings, &"step_forage")

	var commit = DecisionCommitCoordinator.new(store)
	var threat_candidate = DecisionCandidate.new(
		dodge,
		bindings,
		DecisionCandidate.Scope.IMMEDIATE_THREAT,
		1.0
	)
	var threat_decision = DecisionSelectionResult.new(threat_candidate, &"immediate_threat")
	var interrupt_result = commit.apply(threat_decision, &"step_threat")
	_expect_true(interrupt_result != null and interrupt_result.ok, "immediate threat commitment succeeds")
	_expect_true(store.has_current(), "defensive intention becomes current")
	_expect_equal(store.current().intention_id.sort_key(), dodge.sort_key(), "current intention is defensive")
	_expect_true(store.has_suspended(), "prior autonomous intention is suspended")
	_expect_equal(store.suspended().intention_id.sort_key(), forage.sort_key(), "suspended intention preserves original routine")
	_expect_equal(store.suspended().selected_step_id, &"step_forage", "suspension preserves original selection provenance")

	var repeated_result = commit.apply(threat_decision, &"step_threat_repeat")
	_expect_true(repeated_result != null and repeated_result.ok, "repeated immediate threat may refresh defensive commitment")
	_expect_true(store.has_suspended(), "repeated threat does not erase suspended routine")
	_expect_equal(store.suspended().intention_id.sort_key(), forage.sort_key(), "repeated threat does not replace suspended routine")

	var executor = ExecutorStub.new()
	var resume = InterruptedIntentionResumeCoordinator.new(store, executor, [dodge])
	var resume_result: Dictionary = resume.complete_and_resume()
	_expect_true(bool(resume_result.get("handled", false)), "authored defensive intention completion is handled")
	_expect_true(bool(resume_result.get("resumed", false)), "suspended routine is physically re-applied")
	_expect_true(store.has_current(), "routine becomes current again")
	_expect_equal(store.current().intention_id.sort_key(), forage.sort_key(), "original autonomous intention resumes")
	_expect_false(store.has_suspended(), "suspended slot clears after resume")
	_expect_equal(executor.calls, 1, "resume re-applies execution exactly once")
	_expect_true(executor.last_intention != null, "executor receives resumed intention")
	if executor.last_intention != null:
		_expect_equal(executor.last_intention.intention_id.sort_key(), forage.sort_key(), "executor receives original routine")

	var guarded = resume.complete_and_resume()
	_expect_false(bool(guarded.get("handled", false)), "non-interrupting current intention cannot be cleared by resume coordinator")
	_expect_equal(store.current().intention_id.sort_key(), forage.sort_key(), "guard leaves resumed routine intact")
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
