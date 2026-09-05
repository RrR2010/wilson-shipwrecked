extends Node

const EngineScenarioHarness = preload("res://tests/support/engine_scenario/engine_scenario_harness.gd")
const EngineScenarioSceneAdapter = preload("res://tests/support/engine_scenario/engine_scenario_scene_adapter.gd")

@onready var fixture = $SpatialNavigationPerception

var _harness
var _adapter


func _ready() -> void:
	_harness = EngineScenarioHarness.new(EngineScenarioHarness.Mode.ASSISTED, true)
	_adapter = EngineScenarioSceneAdapter.new()
	_adapter.configure(fixture, _harness)
	fixture.auto_start = true
	fixture.pause_at_checkpoints = true
	fixture.smoke_finished.connect(_on_smoke_finished)
	print("[SCENARIO][ASSISTED] Spatial/navigation/perception harness started")
	print("[SCENARIO][ASSISTED] Press Space at each semantic checkpoint to continue")


func _on_smoke_finished(success: bool, _report: Dictionary) -> void:
	if success and _harness.completed():
		print("PASS spatial_navigation_perception_harness_assisted")
		return
	push_error("FAIL spatial_navigation_perception_harness_assisted: %s" % str(_harness.failure_diagnostics()))
