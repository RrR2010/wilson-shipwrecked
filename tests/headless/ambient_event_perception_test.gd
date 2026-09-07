extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RoleBinding = preload("res://src/domain/actions/role_binding.gd")
const WorldEvent = preload("res://src/domain/actions/world_event.gd")
const EventDefinition = preload("res://src/domain/content/event_definition.gd")
const CoarsePerceptionAccessResolver = preload("res://src/application/simulation/coarse_perception_access_resolver.gd")
const PerceptionService = preload("res://src/domain/cognition/perception_service.gd")

var _failures: Array[String] = []
var _completed := false


class WorldQueryStub:
	extends RefCounted

	var definition

	func _init(p_definition) -> void:
		definition = p_definition

	func get_event_definition(_event_type):
		return definition

	func are_co_located(_first, _second) -> bool:
		return false


func _init() -> void:
	_run_slice()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS ambient_event_perception_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL ambient_event_perception_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_slice() -> void:
	var weather_changed = DomainId.event_definition(&"weather_changed")
	var definition = EventDefinition.new(
		weather_changed,
		[],
		[&"vision", &"hearing"],
		1.0,
		EventDefinition.AccessScope.AMBIENT
	)
	var event = WorldEvent.new(weather_changed, null, RoleBinding.new(), &"weather:step:1")
	var resolver = CoarsePerceptionAccessResolver.new(WorldQueryStub.new(definition))
	var access = resolver.resolve([event], null)
	_expect_true(access[event.execution_id].observable, "ambient event is perceptible without a fabricated subject binding")
	_expect_equal(access[event.execution_id].accessible_roles.size(), 0, "ambient access exposes no synthetic roles")
	_expect_equal(access[event.execution_id].modalities.size(), 2, "ambient access preserves authored modalities")

	var perception = PerceptionService.new().perceive([event], access)
	_expect_equal(perception.observed_events.size(), 1, "ambient environmental fact becomes an ObservedEvent")
	_expect_equal(perception.evidence.size(), 0, "ambient event does not invent subject-scoped epistemic evidence")
	if perception.observed_events.size() == 1:
		_expect_equal(perception.observed_events[0].event_type.key(), weather_changed.key(), "observed event retains semantic weather event type")

	_completed = true


func _expect_true(actual: bool, label: String) -> void:
	if not actual:
		_failures.append("Expected true: %s" % label)


func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
