class_name EngineScenarioSceneAdapter
extends RefCounted

const EngineScenarioHarness = preload("res://tests/support/engine_scenario/engine_scenario_harness.gd")

## Bridges a signal-based engine scenario into EngineScenarioHarness without
## knowing any gameplay semantics. The scene remains responsible for its own
## deterministic scenario logic and assisted-mode input handling.

var harness: EngineScenarioHarness
var scene
var _configured := false


func configure(p_scene, p_harness: EngineScenarioHarness) -> void:
	assert(not _configured, "EngineScenarioSceneAdapter is already configured")
	assert(p_scene != null, "EngineScenarioSceneAdapter requires scene")
	assert(p_harness != null, "EngineScenarioSceneAdapter requires harness")
	assert(p_scene.has_signal("checkpoint_reached"), "Scenario scene requires checkpoint_reached signal")
	assert(p_scene.has_signal("continue_requested"), "Scenario scene requires continue_requested signal")
	assert(p_scene.has_signal("smoke_finished"), "Scenario scene requires smoke_finished signal")
	scene = p_scene
	harness = p_harness
	p_scene.checkpoint_reached.connect(_on_checkpoint_reached)
	p_scene.continue_requested.connect(_on_continue_requested)
	p_scene.smoke_finished.connect(_on_smoke_finished)
	_configured = true


func _on_checkpoint_reached(name: StringName, details: Dictionary) -> void:
	var probes: Dictionary = details.duplicate(true)
	var instruction: String = String(probes.get("instruction", ""))
	probes.erase("instruction")
	harness.checkpoint(
		name,
		probes,
		instruction,
		float(probes.get("simulation_time", -1.0)),
		int(probes.get("semantic_step", -1)),
		Engine.get_physics_frames()
	)


func _on_continue_requested() -> void:
	if harness.waiting_for_continue():
		harness.continue_from_checkpoint()


func _on_smoke_finished(success: bool, report: Dictionary) -> void:
	if success:
		harness.complete(report)
		return
	var diagnostics: Array[String] = []
	for failure in report.get("failures", []):
		diagnostics.append(String(failure))
	if diagnostics.is_empty():
		diagnostics.append("Scenario scene reported failure without diagnostics")
	harness.fail(&"engine_scenario_failed", diagnostics)
