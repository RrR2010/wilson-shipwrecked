extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const PhysicalObservation = preload("res://src/application/simulation/physical_observation.gd")
const PhysicalObservationConsequenceRule = preload("res://src/application/simulation/physical_observation_consequence_rule.gd")
const PhysicalObservationConsequenceResolver = preload("res://src/application/simulation/physical_observation_consequence_resolver.gd")
const PerceptionService = preload("res://src/domain/cognition/perception_service.gd")
const PerceptionAccess = preload("res://src/domain/cognition/perception_access.gd")
const ThreatInterpretationRule = preload("res://src/domain/cognition/threat_interpretation_rule.gd")
const PerceivedThreatService = preload("res://src/domain/cognition/perceived_threat_service.gd")
const GodotSceneSpatialRegistry = preload("res://src/infrastructure/spatial/godot_scene_spatial_registry.gd")
const GodotPhysicalObservationBuffer = preload("res://src/infrastructure/spatial/godot_physical_observation_buffer.gd")
const GodotDynamicFallObserver = preload("res://src/infrastructure/spatial/godot_dynamic_fall_observer.gd")

var _failures: Array[String] = []

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var root_node := Node3D.new()
	root.add_child(root_node)

	var palm := RigidBody3D.new()
	palm.gravity_scale = 0.0
	root_node.add_child(palm)

	var registry = GodotSceneSpatialRegistry.new()
	var buffer = GodotPhysicalObservationBuffer.new()
	var palm_ref = RuntimeWorldRef.entity(DomainId.entity(&"falling_palm_threat"))
	_expect_true(registry.bind(palm_ref, palm), "falling palm binds to explicit semantic identity")

	var fall_observer = GodotDynamicFallObserver.new(registry, buffer, 0.5)
	palm.linear_velocity = Vector3(0.0, -2.0, 0.0)
	_expect_true(fall_observer.sample_body(palm), "real rigid-body fall transition is observed")
	_expect_equal(buffer.pending_count(), 1, "fall observer enqueues exactly one physical fact")

	var observations = buffer.drain_observations()
	_expect_equal(observations.size(), 1, "one fall observation drains at semantic boundary")
	if observations.size() != 1:
		_finish(root_node)
		return
	var observation = observations[0]
	_expect_equal(observation.kind, PhysicalObservation.Kind.FALL, "engine fact remains typed as FALL")
	_expect_true(observation.subject.equals(palm_ref), "fall observation subject is the falling palm")

	var falling_event = DomainId.event_definition(&"palm_started_falling")
	var admission = PhysicalObservationConsequenceResolver.new([
		PhysicalObservationConsequenceRule.new(
			PhysicalObservation.Kind.FALL,
			falling_event,
			0.5,
			&"source",
			&"other",
			false
		)
	])
	var events = admission.resolve(observations, &"fall_threat_step")
	_expect_equal(events.size(), 1, "authored fall rule admits one semantic WorldEvent")
	if events.size() != 1:
		_finish(root_node)
		return
	var event = events[0]
	_expect_true(event.event_type.equals(falling_event), "admitted event is palm_started_falling")
	_expect_true(event.bindings.get_subject(&"source").equals(palm_ref), "admitted event binds palm as source")

	var access := PerceptionAccess.new(true, [&"vision"], [&"source"], 0.8)
	var perception = PerceptionService.new().perceive(
		events,
		{event.execution_id: access}
	)
	_expect_equal(perception.evidence.size(), 1, "observable admitted fall creates one perceptual evidence item")

	var threat_service = PerceivedThreatService.new([
		ThreatInterpretationRule.new(falling_event, &"source", 0.9, 0.95, 0.5)
	])
	var threats = threat_service.derive(perception)
	_expect_equal(threats.size(), 1, "accessible fall evidence derives one perceived threat")
	if threats.size() == 1:
		_expect_true(threats[0].source_subject.equals(palm_ref), "perceived threat remains grounded in perceived palm")
		_expect_true(is_equal_approx(threats[0].confidence, 0.8), "perceived threat preserves accessibility confidence")

	_finish(root_node)

func _finish(root_node: Node) -> void:
	root_node.queue_free()
	if _failures.is_empty():
		print("PASS physical_fall_threat_perception_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL physical_fall_threat_perception_test: %d failure(s)" % _failures.size())
	quit(1)

func _expect_true(actual: bool, label: String) -> void:
	if not actual:
		_failures.append("Expected true: %s" % label)

func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
