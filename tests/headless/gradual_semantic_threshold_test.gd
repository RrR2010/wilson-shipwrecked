extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const SemanticChangeSet = preload("res://src/domain/world/semantic_change_set.gd")
const GradualSemanticBoundaryRule = preload("res://src/domain/world/gradual_semantic_boundary_rule.gd")
const GradualSemanticEventProjector = preload("res://src/application/simulation/gradual_semantic_event_projector.gd")
const EnvironmentWorldAdvanceService = preload("res://src/application/simulation/environment_world_advance_service.gd")
const SimulationStepContext = preload("res://src/application/simulation/simulation_step_context.gd")

var _failures: Array[String] = []
var _completed := false


class ProcessStub:
	extends RefCounted
	var transitions: Array

	func _init(p_transitions: Array) -> void:
		transitions = p_transitions.duplicate(true)

	func advance(_elapsed: float) -> Dictionary:
		return {
			"diagnostics": [],
			"change_set": SemanticChangeSet.new(),
			"transitions": transitions.duplicate(true),
		}


func _init() -> void:
	_run_slice()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS gradual_semantic_threshold_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL gradual_semantic_threshold_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_slice() -> void:
	var wind_force = DomainId.property(&"wind_force")
	var dangerous_wind = DomainId.event_definition(&"wind_became_dangerous")
	var weather_ref: RuntimeWorldRef = RuntimeWorldRef.entity(DomainId.entity(&"weather_cell_1"))
	var rule = GradualSemanticBoundaryRule.new(
		&"dangerous_wind_rising",
		wind_force,
		0.70,
		GradualSemanticBoundaryRule.Direction.RISING,
		dangerous_wind,
		&"weather"
	)
	var projector = GradualSemanticEventProjector.new([rule])

	var quiet_events: Array = projector.project([
		_transition(weather_ref, wind_force, 0.40, 0.60),
	], &"quiet_step")
	_expect_equal(quiet_events.size(), 0, "microchange below threshold emits no semantic event")

	var crossing_events: Array = projector.project([
		_transition(weather_ref, wind_force, 0.60, 0.75),
	], &"crossing_step")
	_expect_equal(crossing_events.size(), 1, "threshold crossing emits one semantic event")
	if crossing_events.size() == 1:
		var event = crossing_events[0]
		_expect_equal(event.event_type.key(), dangerous_wind.key(), "projected event retains authored semantic type")
		_expect_true(event.action_id == null, "gradual environment event is not fabricated as an action outcome")
		_expect_equal(event.bindings.get_subject(&"weather").sort_key(), weather_ref.sort_key(), "projected event binds the authored subject role")

	var duplicate_events: Array = projector.project([
		_transition(weather_ref, wind_force, 0.60, 0.75),
		_transition(weather_ref, wind_force, 0.65, 0.80),
	], &"duplicate_step")
	_expect_equal(duplicate_events.size(), 1, "same rule/subject crossing coalesces within one semantic step")

	var world_advance = EnvironmentWorldAdvanceService.new(
		ProcessStub.new([
			_transition(weather_ref, wind_force, 0.60, 0.75),
			_transition(weather_ref, wind_force, 0.65, 0.80),
		]),
		null,
		null,
		null,
		projector
	)
	var result = world_advance.advance(1.0, SimulationStepContext.new(&"environment_threshold_step", 1.0, 1.0, null, []))
	_expect_equal(result.events.size(), 1, "environment world advance exposes only the coalesced semantic boundary fact")

	_completed = true


func _transition(subject, property, previous: float, current: float) -> Dictionary:
	return {
		"subject": subject,
		"property": property,
		"previous": previous,
		"current": current,
		"process_id": &"test_process",
	}


func _expect_true(actual: bool, label: String) -> void:
	if not actual:
		_failures.append("Expected true: %s" % label)


func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
