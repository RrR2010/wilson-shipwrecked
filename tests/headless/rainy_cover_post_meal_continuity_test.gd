extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RoleBinding = preload("res://src/domain/actions/role_binding.gd")
const PerceivedHabitCandidateSource = preload("res://src/domain/cognition/perceived_habit_candidate_source.gd")
const PerceptionResult = preload("res://src/domain/cognition/perception_result.gd")
const DecisionCandidate = preload("res://src/domain/cognition/decision_candidate.gd")

var _failures: Array[String] = []


class EventOnlyWeatherCue:
	extends RefCounted
	var rain_transition_present := true
	func derive(_perception_result) -> Array[StringName]:
		var cues: Array[StringName] = []
		if rain_transition_present:
			cues.append(&"dangerous_weather")
		return cues


class HabitStoreStub:
	extends RefCounted
	var cover_intention
	func _init(intention_id) -> void:
		cover_intention = intention_id
	func entries() -> Array:
		return [{
			"cue_id": &"dangerous_weather",
			"intention_id": cover_intention,
			"bindings": RoleBinding.new(),
			"strength": 0.95,
		}]


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var cover = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"seek_safer_cover")
	var cue = EventOnlyWeatherCue.new()
	var source = PerceivedHabitCandidateSource.new(
		cue, HabitStoreStub.new(cover), 0.5, 0.2, DecisionCandidate.Scope.TACTICAL
	)
	_expect(_contains(source.generate(PerceptionResult.new()), cover), "Rain transition initially activates cover habit")

	# No new weather event is emitted when hunger interrupts shelter for eating.
	# The rain remains active, but event-only cue derivation forgets the context.
	cue.rain_transition_present = false
	_expect(
		_contains(source.generate(PerceptionResult.new()), cover),
		"RED: grounded meal completion during persistent rain should make cover eligible for reconsideration"
	)
	_finish()


func _contains(candidates: Array, intention_id) -> bool:
	for candidate in candidates:
		if candidate.intention_id.equals(intention_id):
			return true
	return false


func _expect(condition: bool, label: String) -> void:
	if not condition:
		_failures.append(label)


func _finish() -> void:
	if _failures.is_empty():
		print("PASS rainy_cover_post_meal_continuity_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL rainy_cover_post_meal_continuity_test: %d failure(s)" % _failures.size())
	quit(1)
