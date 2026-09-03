extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const SemanticDueScheduler = preload("res://src/application/simulation/semantic_due_scheduler.gd")
const ReconsiderationGate = preload("res://src/application/simulation/reconsideration_gate.gd")
const GodotSceneSpatialRegistry = preload("res://src/infrastructure/spatial/godot_scene_spatial_registry.gd")
const GodotMotionAdapter = preload("res://src/infrastructure/spatial/godot_motion_adapter.gd")
const GodotSimulationHost = preload("res://src/infrastructure/spatial/godot_simulation_host.gd")

class RecordingOrchestrator:
	extends RefCounted
	var steps: Array = []

	func advance(step):
		steps.append(step)
		return null

class RecordingMotion:
	extends RefCounted
	var ticks: Array[float] = []

	func physics_tick(delta_seconds: float) -> void:
		ticks.append(delta_seconds)

var _failures: Array[String] = []
var _completed := false


func _init() -> void:
	_run_slice()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS simulation_timing_runtime_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL simulation_timing_runtime_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_slice() -> void:
	_test_shared_due_scheduler_uses_authoritative_time()
	_test_reconsideration_gate_coalesces_semantic_triggers()
	_test_godot_host_separates_physics_from_semantic_steps()
	_test_motion_adapter_fails_closed_without_live_navigation_tree()
	_completed = true


func _test_shared_due_scheduler_uses_authoritative_time() -> void:
	var scheduler = SemanticDueScheduler.new()
	scheduler.register(&"drives", 1.0, 0.0)
	scheduler.register(&"maintenance", 5.0, 0.0)
	_expect_equal(scheduler.collect_due(0.9), [], "nothing is due before first authoritative deadline")
	_expect_equal(scheduler.collect_due(1.0), [&"drives"], "drive work becomes due at one authoritative second")
	_expect_equal(scheduler.collect_due(4.9), [&"drives"], "missed drive periods coalesce into one due invocation")
	_expect_equal(scheduler.collect_due(5.0), [&"drives", &"maintenance"], "all work due at the same authoritative boundary is returned")
	_expect_true(is_equal_approx(scheduler.next_due_time(&"drives"), 6.0), "drive next-due boundary advances deterministically")


func _test_reconsideration_gate_coalesces_semantic_triggers() -> void:
	var gate = ReconsiderationGate.new()
	var triggers = gate.coalesce([
		ReconsiderationGate.Trigger.PLAYER_SIGNAL,
		ReconsiderationGate.Trigger.THREAT,
		ReconsiderationGate.Trigger.PLAYER_SIGNAL,
	])
	_expect_equal(triggers.size(), 2, "duplicate triggers coalesce")
	_expect_equal(triggers[0], ReconsiderationGate.Trigger.THREAT, "coalesced triggers have stable priority ordering")
	_expect_true(gate.should_reconsider(triggers), "meaningful trigger admits cognition")
	_expect_true(gate.has_immediate_threat(triggers), "threat trigger remains explicit")
	_expect_true(not gate.should_reconsider([]), "quiet semantic step does not admit cognition")


func _test_godot_host_separates_physics_from_semantic_steps() -> void:
	var orchestrator = RecordingOrchestrator.new()
	var motion = RecordingMotion.new()
	var host = GodotSimulationHost.new()
	host.configure(orchestrator, motion, 0.1, 0.0)
	_expect_true(host.enqueue_reconsideration_trigger(ReconsiderationGate.Trigger.PLAYER_SIGNAL), "host accepts semantic trigger between boundaries")
	var due_steps := host.advance_engine_time_for_test(0.35)
	_expect_equal(due_steps, 3, "350 ms engine delta produces three fixed semantic steps")
	_expect_equal(motion.ticks.size(), 1, "fine motion progresses once for the engine delta, not once per semantic step")
	_expect_equal(orchestrator.steps.size(), 3, "orchestrator receives every due semantic step")
	_expect_true(is_equal_approx(host.simulation_time(), 0.3), "host advances one authoritative semantic time")
	_expect_equal(orchestrator.steps[0].trigger_set, [ReconsiderationGate.Trigger.PLAYER_SIGNAL], "pending trigger is consumed at next semantic boundary")
	_expect_equal(orchestrator.steps[1].trigger_set, [], "following quiet boundary does not replay consumed trigger")
	_expect_equal(orchestrator.steps[2].trigger_set, [], "trigger remains exactly-once across coarse engine delta")
	host.free()


func _test_motion_adapter_fails_closed_without_live_navigation_tree() -> void:
	var registry = GodotSceneSpatialRegistry.new()
	var wilson_ref: RuntimeWorldRef = RuntimeWorldRef.wilson()
	var target_ref: RuntimeWorldRef = RuntimeWorldRef.entity(DomainId.entity(&"target_tree"))
	var body := CharacterBody3D.new()
	var agent := NavigationAgent3D.new()
	var target := Node3D.new()
	_expect_true(registry.bind(wilson_ref, body), "motion actor has explicit semantic scene mapping")
	_expect_true(registry.bind(target_ref, target), "motion target has explicit semantic scene mapping")
	var motion: Variant = GodotMotionAdapter.new(registry)
	_expect_true(motion.bind_actor(wilson_ref, body, agent, 2.5), "motion adapter binds explicit body/navigation pair")
	_expect_true(not motion.request_move(wilson_ref, target_ref), "detached navigation actor fails closed instead of inventing a route")
	_expect_equal(motion.get_status(wilson_ref), GodotMotionAdapter.MotionStatus.ROUTE_INVALID, "failed live navigation request reports semantic route invalidity")
	motion.unbind_actor(wilson_ref)
	agent.free()
	body.free()
	target.free()


func _expect_true(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _expect_equal(actual: Variant, expected: Variant, message: String) -> void:
	if actual != expected:
		_failures.append("%s (expected=%s actual=%s)" % [message, expected, actual])
