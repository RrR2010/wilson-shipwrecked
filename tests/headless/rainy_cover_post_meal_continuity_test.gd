extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const RoleBinding = preload("res://src/domain/actions/role_binding.gd")
const PerceivedHabitCandidateSource = preload("res://src/domain/cognition/perceived_habit_candidate_source.gd")
const PerceivedCueService = preload("res://src/domain/cognition/perceived_cue_service.gd")
const ObservablePropertyCueRule = preload("res://src/domain/cognition/observable_property_cue_rule.gd")
const ObservableAmbientWeatherSource = preload("res://src/application/simulation/observable_ambient_weather_source.gd")
const AlreadyProtectedCandidateFilter = preload("res://src/application/simulation/already_protected_candidate_filter.gd")
const DecisionCandidate = preload("res://src/domain/cognition/decision_candidate.gd")

var _failures: Array[String] = []


class WeatherStub:
	extends RefCounted
	var weather: StringName = &"rain"


class DistanceStub:
	extends RefCounted
	var distance := 5.0
	func metric_distance(_from, _to) -> float:
		return distance


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
	var rainy = DomainId.property(&"ambient_rain")
	var observer = RuntimeWorldRef.wilson()
	var shelter = RuntimeWorldRef.entity(DomainId.entity(&"shelter_001"))
	var weather = WeatherStub.new()
	var distance = DistanceStub.new()
	var observer_source = ObservableAmbientWeatherSource.new(weather, observer, rainy)
	var cues = PerceivedCueService.new([ObservablePropertyCueRule.new(rainy, true, &"dangerous_weather")])
	var habit = HabitStoreStub.new(cover)
	var filter = AlreadyProtectedCandidateFilter.new(distance, observer, shelter)
	var source = PerceivedHabitCandidateSource.new(cues, habit, 0.5, 0.2, DecisionCandidate.Scope.TACTICAL, filter)

	_expect(_contains(source.generate(observer_source.collect()), cover), "Ongoing perceived rain activates cover")
	# Meal completion does not require another weather-worsened transition.
	_expect(_contains(source.generate(observer_source.collect()), cover), "Persistent rain keeps cover eligible after a meal")
	# Fresh clear-weather observation invalidates the old motivation.
	weather.weather = &"clear"
	_expect(source.generate(observer_source.collect()).is_empty(), "Perceived clear weather invalidates cover")
	weather.weather = &"rain"
	distance.distance = 0.3
	_expect(source.generate(observer_source.collect()).is_empty(), "Already protected Wilson must not seek cover again")
	distance.distance = 5.0
	# Restore re-composes the observer and habit source from durable weather.
	for _interrupt in range(3):
		_expect(_contains(source.generate(observer_source.collect()), cover), "Repeated unrelated completions must preserve ongoing shelter need")
	var restored_source = ObservableAmbientWeatherSource.new(weather, observer, rainy)
	_expect(_contains(source.generate(restored_source.collect()), cover), "Restore recovers rain cue through legitimate observation")
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
