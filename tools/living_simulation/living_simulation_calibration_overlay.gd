class_name LivingSimulationCalibrationOverlay
extends CanvasLayer

## Compact read-only operator projection for the living-island playground.
## The overlay consumes observation_snapshot() and never mutates simulation owners.
## Engine.time_scale remains a tooling-only execution control.

const ALLOWED_SPEEDS: Array[float] = [1.0, 4.0, 16.0]
const MAX_RECENT_TRANSITIONS := 6

var _simulation
var _speed_multiplier := 1.0
var _previous_snapshot: Dictionary = {}
var _previous_weather := ""
var _previous_daylight := ""
var _recent_transitions: Array[String] = []

var _speed_label: Label
var _runtime_label: Label
var _behavior_label: Label
var _world_label: Label
var _health_label: Label
var _recent_label: Label


func _ready() -> void:
	_simulation = get_parent()
	var old_debug_panel = _simulation.get_node_or_null("DebugUI/Panel")
	if old_debug_panel != null:
		old_debug_panel.visible = false
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
		_speed_label.text = "%.0fx" % multiplier
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
	panel.offset_left = -372.0
	panel.offset_right = -18.0
	panel.offset_top = 18.0
	panel.offset_bottom = 390.0
	add_child(panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 12)
	margin.add_theme_constant_override("margin_top", 10)
	margin.add_theme_constant_override("margin_right", 12)
	margin.add_theme_constant_override("margin_bottom", 10)
	panel.add_child(margin)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 4)
	margin.add_child(vbox)

	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", 8)
	vbox.add_child(header)
	var title := Label.new()
	title.text = "LIVING ISLAND"
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_child(title)
	for multiplier in ALLOWED_SPEEDS:
		var button := Button.new()
		button.text = "%.0fx" % multiplier
		button.pressed.connect(set_speed_multiplier.bind(multiplier))
		header.add_child(button)

	_runtime_label = Label.new()
	_runtime_label.text = "bootstrapping..."
	vbox.add_child(_runtime_label)

	_behavior_label = Label.new()
	_behavior_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vbox.add_child(_behavior_label)

	_world_label = Label.new()
	_world_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vbox.add_child(_world_label)

	_health_label = Label.new()
	_health_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vbox.add_child(_health_label)

	var separator := HSeparator.new()
	vbox.add_child(separator)

	_recent_label = Label.new()
	_recent_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_recent_label.text = "—"
	vbox.add_child(_recent_label)

	_speed_label = Label.new()
	_speed_label.visible = false
	vbox.add_child(_speed_label)


func _render(snapshot: Dictionary) -> void:
	_runtime_label.text = "t=%.0fs · %s · step %d" % [
		float(snapshot.get("simulation_time", -1.0)),
		String(snapshot.get("weather", &"")),
		int(snapshot.get("semantic_step", -1)),
	]
	var intention := _short_intention(String(snapshot.get("intention_key", "")))
	_behavior_label.text = "%s\n🍖 %.2f   💤 %.2f   🔎 %.2f\nmeals %d · rests %d · explores %d" % [
		intention,
		float(snapshot.get("hunger", -1.0)),
		float(snapshot.get("energy", -1.0)),
		float(snapshot.get("stimulation", -1.0)),
		int(snapshot.get("grounded_consumptions", 0)),
		int(snapshot.get("grounded_rests", 0)),
		int(snapshot.get("grounded_explorations", 0)),
	]
	_world_label.text = "🏠 shelter %d/100%s\n🐦 Gerald · ambient · %s · arrivals %d" % [
		int(snapshot.get("project_contributions", 0)),
		"" if bool(snapshot.get("project_active", false)) else " ✓",
		String(snapshot.get("gerald_mode", &"")),
		int(snapshot.get("gerald_arrivals", 0)),
	]

	var wilson_motion := int(snapshot.get("motion_status", -1))
	var gerald_motion := int(snapshot.get("gerald_motion_status", -1))
	_health_label.visible = wilson_motion == 3 or wilson_motion == 4 or gerald_motion == 3 or gerald_motion == 4
	if _health_label.visible:
		_health_label.text = "⚠ motion warning · Wilson=%d Gerald=%d" % [wilson_motion, gerald_motion]

	_recent_label.text = "—" if _recent_transitions.is_empty() else "\n".join(_recent_transitions)


func _observe_transitions(snapshot: Dictionary) -> void:
	if _previous_snapshot.is_empty():
		_capture_environment_baseline(snapshot)
		return

	var old_intention := String(_previous_snapshot.get("intention_key", ""))
	var new_intention := String(snapshot.get("intention_key", ""))
	if old_intention != new_intention and new_intention != "":
		_append_transition("→ %s" % _short_intention(new_intention))

	var old_meals := int(_previous_snapshot.get("grounded_consumptions", 0))
	var new_meals := int(snapshot.get("grounded_consumptions", 0))
	if new_meals > old_meals:
		_append_transition("🍖 ate · hunger %.2f" % float(snapshot.get("hunger", -1.0)))

	var old_rests := int(_previous_snapshot.get("grounded_rests", 0))
	var new_rests := int(snapshot.get("grounded_rests", 0))
	if new_rests > old_rests:
		_append_transition("💤 rested · energy %.2f" % float(snapshot.get("energy", -1.0)))

	var old_explores := int(_previous_snapshot.get("grounded_explorations", 0))
	var new_explores := int(snapshot.get("grounded_explorations", 0))
	if new_explores > old_explores:
		_append_transition("🔎 explored relic")

	var old_progress := int(_previous_snapshot.get("project_contributions", 0))
	var new_progress := int(snapshot.get("project_contributions", 0))
	if new_progress > old_progress and (new_progress == 1 or new_progress % 25 == 0):
		_append_transition("🔨 shelter %d/100" % new_progress)

	var old_active := bool(_previous_snapshot.get("project_active", false))
	var new_active := bool(snapshot.get("project_active", false))
	if old_active and not new_active:
		_append_transition("🏠 shelter complete")

	_observe_environment_transition(snapshot)


func _capture_environment_baseline(snapshot: Dictionary) -> void:
	_previous_weather = String(snapshot.get("weather", &""))
	_previous_daylight = String(snapshot.get("daylight_phase", &""))


func _observe_environment_transition(snapshot: Dictionary) -> void:
	var weather := String(snapshot.get("weather", &""))
	var daylight := String(snapshot.get("daylight_phase", &""))
	if _previous_weather != "" and weather != _previous_weather:
		_append_transition("🌧 %s → %s" % [_previous_weather, weather])
	if _previous_daylight != "" and daylight != _previous_daylight:
		_append_transition("☀ %s → %s" % [_previous_daylight, daylight])
	_previous_weather = weather
	_previous_daylight = daylight


func _append_transition(text: String) -> void:
	if text == "":
		return
	_recent_transitions.push_front(text)
	if _recent_transitions.size() > MAX_RECENT_TRANSITIONS:
		_recent_transitions.resize(MAX_RECENT_TRANSITIONS)


func _short_intention(value: String) -> String:
	if value == "":
		return "• idle"
	if value.contains("seek_food"):
		return "🍖 eat"
	if value.contains("seek_rest"):
		return "💤 rest"
	if value.contains("seek_stimulation"):
		return "🔎 explore"
	if value.contains("continue_shelter_project"):
		return "🔨 build shelter"
	if value.contains("seek_safer_cover"):
		return "🌧 seek cover"
	return value
