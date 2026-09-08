class_name LivingSimulationCalibrationOverlay
extends CanvasLayer

## Read-only operator projection for the living-island playground.
## The overlay consumes observation_snapshot() and never mutates simulation owners.
## Engine.time_scale remains a tooling-only execution control.

const ALLOWED_SPEEDS: Array[float] = [1.0, 4.0, 16.0]
const MAX_RECENT_TRANSITIONS := 10

var _simulation
var _speed_multiplier := 1.0
var _previous_snapshot: Dictionary = {}
var _previous_weather := ""
var _previous_daylight := ""
var _recent_transitions: Array[String] = []

var _speed_label: Label
var _runtime_label: Label
var _behavior_label: Label
var _environment_label: Label
var _actor_label: Label
var _health_label: Label
var _recent_label: Label


func _ready() -> void:
	_simulation = get_parent()
	_build_ui()
	set_speed_multiplier(1.0)


func _exit_tree() -> void:
	Engine.time_scale = 1.0


func _process(_delta: float) -> void:
	if _simulation == null or not _simulation.has_method("observation_snapshot"):
		return
	var snapshot: Dictionary = _simulation.observation_snapshot()
	_observe_transitions(snapshot)
	_render(snapshot)
	_previous_snapshot = snapshot.duplicate(true)


func set_speed_multiplier(multiplier: float) -> bool:
	if not ALLOWED_SPEEDS.has(multiplier):
		return false
	_speed_multiplier = multiplier
	Engine.time_scale = multiplier
	if _speed_label != null:
		_speed_label.text = "Execution speed: %.0fx" % multiplier
	_append_transition("execution speed → %.0fx" % multiplier)
	return true


func speed_multiplier() -> float:
	return _speed_multiplier


func recent_transitions() -> Array[String]:
	return _recent_transitions.duplicate()


func _build_ui() -> void:
	var panel := PanelContainer.new()
	panel.name = "CalibrationPanel"
	panel.anchor_left = 1.0
	panel.anchor_right = 1.0
	panel.offset_left = -455.0
	panel.offset_right = -18.0
	panel.offset_top = 18.0
	panel.offset_bottom = 505.0
	add_child(panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 12)
	margin.add_theme_constant_override("margin_top", 10)
	margin.add_theme_constant_override("margin_right", 12)
	margin.add_theme_constant_override("margin_bottom", 10)
	panel.add_child(margin)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 5)
	margin.add_child(vbox)

	var title := Label.new()
	title.text = "CALIBRATION / LIVING ISLAND"
	vbox.add_child(title)

	var controls := HBoxContainer.new()
	controls.add_theme_constant_override("separation", 5)
	vbox.add_child(controls)
	for multiplier in ALLOWED_SPEEDS:
		var button := Button.new()
		button.text = "%.0fx" % multiplier
		button.pressed.connect(set_speed_multiplier.bind(multiplier))
		controls.add_child(button)

	_speed_label = Label.new()
	_speed_label.text = "Execution speed: 1x"
	vbox.add_child(_speed_label)

	_runtime_label = Label.new()
	_runtime_label.text = "Runtime: waiting"
	vbox.add_child(_runtime_label)

	_behavior_label = Label.new()
	_behavior_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vbox.add_child(_behavior_label)

	_environment_label = Label.new()
	vbox.add_child(_environment_label)

	_actor_label = Label.new()
	_actor_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vbox.add_child(_actor_label)

	_health_label = Label.new()
	_health_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vbox.add_child(_health_label)

	var separator := HSeparator.new()
	vbox.add_child(separator)

	var recent_title := Label.new()
	recent_title.text = "Recent semantic transitions"
	vbox.add_child(recent_title)

	_recent_label = Label.new()
	_recent_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_recent_label.text = "—"
	vbox.add_child(_recent_label)


func _render(snapshot: Dictionary) -> void:
	_runtime_label.text = "Semantic time %.1fs   step %d" % [
		float(snapshot.get("simulation_time", -1.0)),
		int(snapshot.get("semantic_step", -1)),
	]
	var intention := String(snapshot.get("intention_key", ""))
	if intention == "":
		intention = "none"
	_behavior_label.text = "Intention: %s\nHunger %.2f [%d]   Energy %.2f [%d]   Stimulation %.2f [%d]\nMeals %d   rests %d   explores %d\nShelter %d/100 active=%s   grounded work %d" % [
		intention,
		float(snapshot.get("hunger", -1.0)),
		int(snapshot.get("hunger_band", -1)),
		float(snapshot.get("energy", -1.0)),
		int(snapshot.get("energy_band", -1)),
		float(snapshot.get("stimulation", -1.0)),
		int(snapshot.get("stimulation_band", -1)),
		int(snapshot.get("grounded_consumptions", 0)),
		int(snapshot.get("grounded_rests", 0)),
		int(snapshot.get("grounded_explorations", 0)),
		int(snapshot.get("project_contributions", 0)),
		str(bool(snapshot.get("project_active", false))),
		int(snapshot.get("grounded_project_contributions", 0)),
	]

	_environment_label.text = "Environment: %s   daylight=%s   weather phase #%d" % [
		String(snapshot.get("weather", &"")),
		String(snapshot.get("daylight_phase", &"")),
		int(snapshot.get("weather_transition_index", -1)),
	]

	_actor_label.text = "Gerald: mode=%s   place=%s\naffinity=%.2f   arrivals=%d   pending=%s" % [
		String(snapshot.get("gerald_mode", &"")),
		String(snapshot.get("gerald_place", "")),
		float(snapshot.get("gerald_affinity", 0.0)),
		int(snapshot.get("gerald_arrivals", 0)),
		str(bool(snapshot.get("gerald_pending", false))),
	]

	var wilson_motion := int(snapshot.get("motion_status", -1))
	var gerald_motion := int(snapshot.get("gerald_motion_status", -1))
	var health := "Health: nominal"
	if wilson_motion == 3 or gerald_motion == 3:
		health = "Health: WARNING — motion BLOCKED"
	elif wilson_motion == 4 or gerald_motion == 4:
		health = "Health: WARNING — motion ROUTE_INVALID"
	_health_label.text = "%s   trace buffer=%d" % [health, int(snapshot.get("trace_count", 0))]

	_recent_label.text = "—" if _recent_transitions.is_empty() else "\n".join(_recent_transitions)


func _observe_transitions(snapshot: Dictionary) -> void:
	if _previous_snapshot.is_empty():
		_capture_environment_baseline(snapshot)
		return

	var old_intention := String(_previous_snapshot.get("intention_key", ""))
	var new_intention := String(snapshot.get("intention_key", ""))
	if old_intention != new_intention:
		_append_transition("intention: %s → %s" % [_display_none(old_intention), _display_none(new_intention)])

	var old_meals := int(_previous_snapshot.get("grounded_consumptions", 0))
	var new_meals := int(snapshot.get("grounded_consumptions", 0))
	if new_meals > old_meals:
		_append_transition("🍖 meal #%d   hunger=%.2f" % [new_meals, float(snapshot.get("hunger", -1.0))])

	var old_rests := int(_previous_snapshot.get("grounded_rests", 0))
	var new_rests := int(snapshot.get("grounded_rests", 0))
	if new_rests > old_rests:
		_append_transition("💤 rest #%d   energy=%.2f" % [new_rests, float(snapshot.get("energy", -1.0))])

	var old_explores := int(_previous_snapshot.get("grounded_explorations", 0))
	var new_explores := int(snapshot.get("grounded_explorations", 0))
	if new_explores > old_explores:
		_append_transition("🔎 explore #%d   stimulation=%.2f" % [new_explores, float(snapshot.get("stimulation", -1.0))])

	var old_progress := int(_previous_snapshot.get("project_contributions", 0))
	var new_progress := int(snapshot.get("project_contributions", 0))
	if new_progress > old_progress and (new_progress == 1 or new_progress % 10 == 0):
		_append_transition("🔨 shelter reached %d/100" % new_progress)

	var old_active := bool(_previous_snapshot.get("project_active", false))
	var new_active := bool(snapshot.get("project_active", false))
	if old_active != new_active:
		_append_transition("shelter active → %s" % str(new_active))

	var old_gerald_mode := String(_previous_snapshot.get("gerald_mode", &""))
	var new_gerald_mode := String(snapshot.get("gerald_mode", &""))
	if old_gerald_mode != new_gerald_mode:
		_append_transition("🐦 Gerald: %s → %s" % [_display_none(old_gerald_mode), _display_none(new_gerald_mode)])

	var old_motion := int(_previous_snapshot.get("motion_status", -1))
	var new_motion := int(snapshot.get("motion_status", -1))
	if new_motion != old_motion and (new_motion == 3 or new_motion == 4):
		_append_transition("Wilson motion entered %s" % ("BLOCKED" if new_motion == 3 else "ROUTE_INVALID"))

	_observe_environment_transition(snapshot)


func _capture_environment_baseline(snapshot: Dictionary) -> void:
	_previous_weather = String(snapshot.get("weather", &""))
	_previous_daylight = String(snapshot.get("daylight_phase", &""))


func _observe_environment_transition(snapshot: Dictionary) -> void:
	var weather := String(snapshot.get("weather", &""))
	var daylight := String(snapshot.get("daylight_phase", &""))
	if _previous_weather != "" and weather != _previous_weather:
		_append_transition("☔ weather: %s → %s" % [_previous_weather, weather])
	if _previous_daylight != "" and daylight != _previous_daylight:
		_append_transition("daylight: %s → %s" % [_previous_daylight, daylight])
	_previous_weather = weather
	_previous_daylight = daylight


func _append_transition(text: String) -> void:
	if text == "":
		return
	_recent_transitions.push_front(text)
	if _recent_transitions.size() > MAX_RECENT_TRANSITIONS:
		_recent_transitions.resize(MAX_RECENT_TRANSITIONS)


func _display_none(value: String) -> String:
	return "none" if value == "" else value
