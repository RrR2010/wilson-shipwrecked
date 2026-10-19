class_name LivingSimulationWorldProjection
extends Node

## Presentation-only projection for the primitive living-island diorama.
## All inputs come from observation_snapshot(); mesh visibility, poses, lighting and
## communication bubbles never feed back into navigation or semantic authority.

const MOTION_ARRIVED := 2

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
var _spatial_debug_labels: Dictionary = {}
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

	# Keep visible props honest: the campfire has no authored affordance yet, so it
	# should not read like an interactable object in this calibration scene.
	var campfire = _simulation.get_node_or_null("Campfire")
	if campfire != null:
		campfire.visible = false

	# The in-world bubble is the primary player-facing communication layer. Make it
	# readable at the default camera scale rather than relying on the debug overlay.
	if _wilson_bubble != null:
		_wilson_bubble.font_size = 48
		_wilson_bubble.outline_size = 12
		_wilson_bubble.position.y = 2.65
	if _gerald_bubble != null:
		_gerald_bubble.font_size = 34
		_gerald_bubble.outline_size = 9


func _process(_delta: float) -> void:
	if _simulation == null or not _simulation.has_method("observation_snapshot"):
		return
	var snapshot: Dictionary = _simulation.observation_snapshot()
	_project_weather(String(snapshot.get("weather", &"")))
	_project_shelter(int(snapshot.get("project_contributions", 0)))
	_project_exposed_food("FoodPatch", int(snapshot.get("near_food_quantity", 0)))
	_project_exposed_food("FoodPatchFar", int(snapshot.get("far_food_quantity", 0)))
	_project_wilson(snapshot)
	_project_gerald(snapshot)
	_project_spatial_diagnostics()
	_project_wilson_diagnostics()


## Visual only: the fruit props reflect World quantity but never grant perception.
## Wilson learns through passive spatial evidence, not this mesh projection.
func _project_exposed_food(patch_name: String, quantity: int) -> void:
	var patch = _simulation.get_node_or_null(patch_name)
	if patch == null:
		return
	for fruit_name in ["FruitA", "FruitB", "FruitC"]:
		var fruit = patch.get_node_or_null(fruit_name)
		if fruit != null:
			fruit.visible = quantity > 0


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
	var arrived := int(snapshot.get("motion_status", -1)) == MOTION_ARRIVED
	if _wilson_bubble != null:
		match intention:
			"SemanticIntentionId:seek_food":
				_wilson_bubble.text = "🌧  🍖" if raining else "🍖"
			"SemanticIntentionId:seek_rest":
				_wilson_bubble.text = "💤"
			"SemanticIntentionId:seek_stimulation":
				_wilson_bubble.text = "🔎"
			"SemanticIntentionId:continue_shelter_project":
				_wilson_bubble.text = "🔨"
			"SemanticIntentionId:seek_safer_cover":
				_wilson_bubble.text = "🌧 🏠"
			_:
				_wilson_bubble.text = "🌧 ?" if raining else ""

	if _wilson_visual == null:
		return
	_wilson_visual.position = Vector3.ZERO
	_wilson_visual.rotation_degrees = Vector3.ZERO
	_wilson_visual.scale = Vector3.ONE
	if intention.contains("seek_rest") and arrived:
		_wilson_visual.position = Vector3(0.0, 0.30, 0.0)
		_wilson_visual.rotation_degrees = Vector3(0.0, 0.0, -68.0)
		_wilson_visual.scale = Vector3(1.0, 0.9, 1.0)
	elif intention.contains("continue_shelter_project") and arrived:
		_wilson_visual.rotation_degrees = Vector3(0.0, 0.0, 8.0)
	elif intention.contains("seek_stimulation") and arrived:
		_wilson_visual.scale = Vector3(1.0, 1.06, 1.0)


func _project_gerald(snapshot: Dictionary) -> void:
	if _gerald_bubble == null:
		return
	var mode := String(snapshot.get("gerald_mode", &""))
	match mode:
		"roost":
			_gerald_bubble.text = "🐦"
		"beach":
			_gerald_bubble.text = "🐟"
		"camp":
			_gerald_bubble.text = "👀"
		"lookout":
			_gerald_bubble.text = "👀"
		_:
			_gerald_bubble.text = "🐦"


## Labels follow visual nodes, not screen corners. Data is a read-only debug
## projection and explicitly labels World truth vs Wilson's inferred knowledge.
func _project_spatial_diagnostics() -> void:
	if not _simulation.has_method("debug_object_snapshot"):
		return
	var items: Dictionary = _simulation.debug_object_snapshot()
	var aliases := {
		"FoodPatch": "Food (near)",
		"FoodPatchFar": "Food (far)",
		"Shelter": "Shelter",
		"CuriositySpot": "Shipwreck relic",
		"SpyglassLocation": "Spyglass",
	}
	for node_name in items.keys():
		var anchor = _simulation.get_node_or_null(node_name) as Node3D
		if anchor == null:
			continue
		if not _spatial_debug_labels.has(node_name):
			var label := Label3D.new()
			label.name = "DebugObjectLabel"
			label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
			label.no_depth_test = true
			label.fixed_size = true
			label.font_size = 14
			label.outline_size = 4
			label.pixel_size = 0.002
			label.position = Vector3(0, 1.55, 0)
			label.modulate = Color(0.94, 0.96, 1.0)
			anchor.add_child(label)
			_spatial_debug_labels[node_name] = label
		var label: Label3D = _spatial_debug_labels[node_name]
		var state: Dictionary = items[node_name]
		label.text = String(aliases.get(node_name, node_name))


func _project_wilson_diagnostics() -> void:
	if not _simulation.has_method("debug_wilson_snapshot"):
		return
	var anchor = _simulation.get_node_or_null("Wilson") as Node3D
	if anchor == null:
		return
	if not _spatial_debug_labels.has("Wilson"):
		var label := Label3D.new()
		label.name = "DebugWilsonLabel"
		label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
		label.no_depth_test = true
		label.fixed_size = true
		label.font_size = 14
		label.outline_size = 4
		label.pixel_size = 0.002
		label.position = Vector3(0, 2.55, 0)
		anchor.add_child(label)
		_spatial_debug_labels["Wilson"] = label
	var state: Dictionary = _simulation.debug_wilson_snapshot()
	var label: Label3D = _spatial_debug_labels["Wilson"]
	label.text = "Wilson"


func _compact_debug_text(value: String, limit: int) -> String:
	if value.length() <= limit:
		return value
	return value.substr(0, limit - 1) + "…"
