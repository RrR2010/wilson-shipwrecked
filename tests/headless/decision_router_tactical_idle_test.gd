extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RoleBinding = preload("res://src/domain/actions/role_binding.gd")
const DecisionCandidate = preload("res://src/domain/cognition/decision_candidate.gd")
const DecisionRouter = preload("res://src/domain/cognition/decision_router.gd")

var _failures: Array[String] = []


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var tactical_id = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"seek_cover_test")
	var ordinary_id = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"ordinary_test")
	var bindings = RoleBinding.new()
	var tactical = DecisionCandidate.new(
		tactical_id,
		bindings,
		DecisionCandidate.Scope.TACTICAL,
		0.2
	)
	var ordinary = DecisionCandidate.new(
		ordinary_id,
		bindings,
		DecisionCandidate.Scope.INTENTIONAL,
		1.0
	)
	var result = DecisionRouter.new().resolve([ordinary, tactical], null)
	if result == null or result.selected_candidate == null:
		_failures.append("Tactical candidate was not selectable from idle")
	elif not result.selected_candidate.intention_id.equals(tactical_id):
		_failures.append("Idle routing did not preserve tactical precedence over intentional candidates")
	if result != null and result.regime != &"tactical":
		_failures.append("Idle tactical selection did not report tactical regime")

	_finish()


func _finish() -> void:
	if _failures.is_empty():
		print("PASS decision_router_tactical_idle_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL decision_router_tactical_idle_test: %d failure(s)" % _failures.size())
	quit(1)
