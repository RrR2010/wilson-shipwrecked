class_name LivingSimulationWorldProjection
extends Node

## Presentation-only projection for the primitive living-island diorama.
## All inputs come from observation_snapshot(); mesh visibility, poses, lighting and
## communication bubbles never feed back into navigation or semantic authority.

var _simulation
var _world_environment: WorldEnvironment
var _sun: DirectionalLight3D
var _rain_visual: Node3D
var _wilson_visual: Node3D
var _wilson_bubble: Label3D
var _gerald_bubble: Label3D
var _base_frame: MeshInstance3D
var _post_left: MeshInstance3D
var _post_right: MeshInstance3D
var _cross_beam: MeshInstance3D
var _roof_a: MeshInstance3D
var _roof_b: MeshInstance3D
var _roof_c: MeshInstance3D
var _sleeping_area: MeshInstance3D

var _clear_background := Color(0.16, 0.37, 0.55, 1.0)
var _rain_background := Color(0.075, 0.13, 0.2, 1.0)
var _clear_ambient := Color(0.72, 0.78, 0.84, 1.0)
var _rain_ambient := Color(0.38, 0.45, 0.57, 1.0)


func _ready() -> void:
	_simulation = get_parent()
	_world_environment = _simulation.get_node_or_null("WorldEnvironment") as WorldEnvironment
	_sun = _simulation.get_node_or_null("DirectionalLight3D") as DirectionalLight3D
	_rain_visual = _simulation.get_node_or_null("RainVisual") as Node3D
	_wilson_visual = _simulation.get_node_or_null("Wilson/VisualRoot") as Node3D
	_wilson_bubble = _simulation.get_node_or_null("Wilson/ThoughtBubble") as Label3D
	_gerald_bubble = _simulation.get_node_or_null("Gerald/StateBubble") as Label3D
	_base_frame = _simulation.get_node_or_null("Shelter/BaseFrame") as MeshInstance3D
	_post_left = _simulation.get_node_or_null("Shelter/PostLeft") as MeshInstance3D
	_post_right = _simulation.get_node_or_null("Shelter/PostRight") as MeshInstance3D
	_cross_beam = _simulation.get_node_or_null("Shelter/CrossBeam") as MeshInstance3D
	_roof_a = _simulation.get_node_or_null("Shelter/RoofA") as MeshInstance3D
	_roof_b = _simulation.get_node_or_null("Shelter/RoofB") as MeshInstance3D
	_roof_c = _simulation.get_node_or_null("Shelter/RoofC") as MeshInstance3D
	_sleeping_area = _simulation.get_node_or_null("Shelter/SleepingArea") as MeshInstance3D


func _process(_delta: float) -> void:
	if _simulation == null or not _simulation.has_method("observation_snapshot"):
		return
	var snapshot: Dictionary = _simulation.observation_snapshot()
	_project_weather(String(snapshot.get("weather", &"")))
	_project_shelter(int(snapshot.get("project_contributions", 0)))
	_project_wilson(snapshot)
	_project_gerald(snapshot)


func _project_weather(weather: String) -> void:
	var raining := weather == "rain"
	if _world_environment != null and _world_environment.environment != null:
		_world_environment.environment.background_color = _rain_background if raining else _clear_background
		_world_environment.environment.ambient_light_color = _rain_ambient if raining else _clear_ambient
		_world_environment.environment.ambient_light_energy = 0.48 if raining else 0.8
	if _sun != null:
		_sun.light_energy = 0.48 if raining else 1.15
	if _rain_visual != null:
		_rain_visual.visible = raining


func _project_shelter(contributions: int) -> void:
	## More milestones make the persistent project read as construction rather than
	## a finished prop with a hidden counter.
	if _base_frame != null:
		_base_frame.visible = contributions >= 1
	if _post_left != null:
		_post_left.visible = contributions >= 10
	if _post_right != null:
		_post_right.visible = contributions >= 25
	if _sleeping_area != null:
		_sleeping_area.visible = contributions >= 35
	if _cross_beam != null:
		_cross_beam.visible = contributions >= 45
	if _roof_a != null:
		_roof_a.visible = contributions >= 60
	if _roof_b != null:
		_roof_b.visible = contributions >= 75
	if _roof_c != null:
		_roof_c.visible = contributions >= 90


func _project_wilson(snapshot: Dictionary) -> void:
	var intention := String(snapshot.get("intention_key", ""))
	var raining := String(snapshot.get("weather", &"")) == "rain"
	if _wilson_bubble != null:
		match intention:
			"SemanticIntentionId:seek_food":
				_wilson_bubble.text = "☔  🍖 EAT" if raining else "🍖 EAT"
			"SemanticIntentionId:seek_rest":
				_wilson_bubble.text = "💤 REST"
			"SemanticIntentionId:seek_stimulation":
				_wilson_bubble.text = "🔎 EXPLORE"
			"SemanticIntentionId:continue_shelter_project":
				_wilson_bubble.text = "🔨 BUILD"
			"SemanticIntentionId:seek_safer_cover":
				_wilson_bubble.text = "☔ COVER"
			_:
				_wilson_bubble.text = "☔ …" if raining else "🙂 …"

	if _wilson_visual == null:
		return
	_wilson_visual.position = Vector3.ZERO
	_wilson_visual.rotation_degrees = Vector3.ZERO
	_wilson_visual.scale = Vector3.ONE
	if intention.contains("seek_rest"):
		_wilson_visual.position = Vector3(0.0, 0.30, 0.0)
		_wilson_visual.rotation_degrees = Vector3(0.0, 0.0, -68.0)
		_wilson_visual.scale = Vector3(1.0, 0.9, 1.0)
	elif intention.contains("continue_shelter_project"):
		_wilson_visual.rotation_degrees = Vector3(0.0, 0.0, 8.0)
	elif intention.contains("seek_stimulation"):
		_wilson_visual.scale = Vector3(1.0, 1.06, 1.0)


func _project_gerald(snapshot: Dictionary) -> void:
	if _gerald_bubble == null:
		return
	var mode := String(snapshot.get("gerald_mode", &""))
	match mode:
		"roost":
			_gerald_bubble.text = "🐦 ROOST"
		"beach":
			_gerald_bubble.text = "🐟 BEACH"
		"camp":
			_gerald_bubble.text = "👀 CAMP"
		"lookout":
			_gerald_bubble.text = "👀 LOOK"
		_:
			_gerald_bubble.text = "🐦 GERALD"
