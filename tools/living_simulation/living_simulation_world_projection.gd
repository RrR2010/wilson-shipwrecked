class_name LivingSimulationWorldProjection
extends Node

## Presentation-only projection for the primitive living-simulation diorama.
## All inputs come from observation_snapshot(); visibility/light changes never feed
## back into semantic owners, navigation, action success or cognition.

var _simulation
var _world_environment: WorldEnvironment
var _sun: DirectionalLight3D
var _post_left: MeshInstance3D
var _post_right: MeshInstance3D
var _roof: MeshInstance3D
var _sleeping_area: MeshInstance3D

var _clear_background := Color(0.16, 0.37, 0.55, 1.0)
var _rain_background := Color(0.09, 0.15, 0.22, 1.0)
var _clear_ambient := Color(0.72, 0.78, 0.84, 1.0)
var _rain_ambient := Color(0.42, 0.48, 0.58, 1.0)


func _ready() -> void:
	_simulation = get_parent()
	_world_environment = _simulation.get_node_or_null("WorldEnvironment") as WorldEnvironment
	_sun = _simulation.get_node_or_null("DirectionalLight3D") as DirectionalLight3D
	_post_left = _simulation.get_node_or_null("Shelter/PostLeft") as MeshInstance3D
	_post_right = _simulation.get_node_or_null("Shelter/PostRight") as MeshInstance3D
	_roof = _simulation.get_node_or_null("Shelter/Roof") as MeshInstance3D
	_sleeping_area = _simulation.get_node_or_null("Shelter/SleepingArea") as MeshInstance3D


func _process(_delta: float) -> void:
	if _simulation == null or not _simulation.has_method("observation_snapshot"):
		return
	var snapshot: Dictionary = _simulation.observation_snapshot()
	_project_weather(String(snapshot.get("weather", &"")))
	_project_shelter(int(snapshot.get("project_contributions", 0)))


func _project_weather(weather: String) -> void:
	var raining := weather == "rain"
	if _world_environment != null and _world_environment.environment != null:
		_world_environment.environment.background_color = _rain_background if raining else _clear_background
		_world_environment.environment.ambient_light_color = _rain_ambient if raining else _clear_ambient
		_world_environment.environment.ambient_light_energy = 0.55 if raining else 0.8
	if _sun != null:
		_sun.light_energy = 0.55 if raining else 1.15


func _project_shelter(contributions: int) -> void:
	## Coarse milestones make persistent work legible without pretending meshes are
	## authoritative construction state.
	if _sleeping_area != null:
		_sleeping_area.visible = contributions >= 1
	if _post_left != null:
		_post_left.visible = contributions >= 10
	if _post_right != null:
		_post_right.visible = contributions >= 35
	if _roof != null:
		_roof.visible = contributions >= 70
