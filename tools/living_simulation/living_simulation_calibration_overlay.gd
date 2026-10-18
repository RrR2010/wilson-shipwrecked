class_name LivingSimulationCalibrationOverlay
extends CanvasLayer

## Compact read-only operator projection for the living-island playground.
## The overlay consumes observation_snapshot() and never mutates simulation owners.
## Engine.time_scale remains a tooling-only execution control.

const ALLOWED_SPEEDS: Array[float] = [0.0, 1.0, 4.0, 16.0]
const MAX_RECENT_TRANSITIONS := 6

var _simulation
var _speed_multiplier := 1.0
var _resume_speed := 1.0
var _previous_snapshot: Dictionary = {}
var _previous_weather := ""
var _previous_daylight := ""
var _recent_transitions: Array[String] = []

var _speed_label: Label
var _runtime_label: Label
var _behavior_label: Label
var _world_label: Label
var _health_label: Label
var _inspector_picker: OptionButton
var _inspector_detail: Label
var _inventory_sidebar: RichTextLabel
var _inspector_keys: Array[String] = []
var _recent_label: Label


func _ready() -> void:
	_simulation = get_parent()
	var old_debug_panel = _simulation.get_node_or_null("DebugUI/Panel")
	if old_debug_panel != null:
		old_debug_panel.visible = false
	_build_ui()
	set_speed_multiplier(1.0)


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and (event.keycode == KEY_P or event.keycode == KEY_SPACE):
		toggle_pause()
		get_viewport().set_input_as_handled()


func _unhandled_input(event: InputEvent) -> void:
	if not (event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT):
		return
	if _simulation == null or _inspector_picker == null:
		return
	var camera = _simulation.get_node_or_null("Camera3D") as Camera3D
	if camera == null:
		return
	var candidates: Array[String] = ["Wilson"]
	candidates.append_array(_inspector_keys)
	var best_name := ""
	var best_distance := 38.0
	for node_name in candidates:
		var anchor = _simulation.get_node_or_null(node_name) as Node3D
		if anchor == null or camera.is_position_behind(anchor.global_position):
			continue
		var screen_point: Vector2 = camera.unproject_position(anchor.global_position + Vector3.UP * 1.2)
		var distance: float = screen_point.distance_to(event.position)
		if distance < best_distance:
			best_distance = distance
			best_name = node_name
	if best_name == "":
		return
	var index := 1 if best_name == "Wilson" else _inspector_keys.find(best_name) + 2
	if index > 0:
		_inspector_picker.select(index)
		_render_inspector()
		get_viewport().set_input_as_handled()


func toggle_pause() -> bool:
	if is_zero_approx(_speed_multiplier):
		return set_speed_multiplier(_resume_speed)
	return set_speed_multiplier(0.0)


func _exit_tree() -> void:
	var host = _simulation.get_node_or_null("GodotSimulationHost") if _simulation != null else null
	if host != null:
		host.set_physics_process(true)
	Engine.time_scale = 1.0


func _process(_delta: float) -> void:
	if _simulation == null or not _simulation.has_method("observation_snapshot"):
		return
	var snapshot: Dictionary = _simulation.observation_snapshot()
	_observe_transitions(snapshot)
	_render(snapshot)
	_render_inspector()
	_render_inventory_sidebar()
	_previous_snapshot = snapshot.duplicate(true)


func set_speed_multiplier(multiplier: float) -> bool:
	if not ALLOWED_SPEEDS.has(multiplier):
		return false
	if multiplier > 0.0:
		_resume_speed = multiplier
	_speed_multiplier = multiplier
	Engine.time_scale = multiplier
	# Godot may still dispatch zero-delta physics callbacks while time_scale is 0.
	# Disable the semantic host directly to guarantee that paused time/steps do not advance.
	var host = _simulation.get_node_or_null("GodotSimulationHost") if _simulation != null else null
	if host != null:
		host.set_physics_process(multiplier > 0.0)
	if _speed_label != null:
		_speed_label.text = "PAUSED" if is_zero_approx(multiplier) else "%.0fx" % multiplier
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
	title.text = "LIVING ISLAND · Space/P pause"
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_child(title)
	for multiplier in ALLOWED_SPEEDS:
		var button := Button.new()
		button.text = "⏸" if is_zero_approx(multiplier) else "%.0fx" % multiplier
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

	var inspector_panel := PanelContainer.new()
	inspector_panel.name = "ObjectInspector"
	inspector_panel.anchor_left = 0.0
	inspector_panel.anchor_right = 0.0
	inspector_panel.offset_left = 20.0
	inspector_panel.offset_right = 355.0
	inspector_panel.offset_top = 25.0
	inspector_panel.offset_bottom = 170.0
	add_child(inspector_panel)
	var inspector_margin := MarginContainer.new()
	inspector_margin.add_theme_constant_override("margin_left", 10)
	inspector_margin.add_theme_constant_override("margin_right", 10)
	inspector_margin.add_theme_constant_override("margin_top", 8)
	inspector_margin.add_theme_constant_override("margin_bottom", 8)
	inspector_panel.add_child(inspector_margin)
	var inspector_stack := VBoxContainer.new()
	inspector_margin.add_child(inspector_stack)
	_inspector_picker = OptionButton.new()
	_inspector_picker.add_item("Select object to inspect")
	_inspector_picker.add_item("Wilson")
	_inspector_picker.select(0)
	inspector_stack.add_child(_inspector_picker)
	_inspector_detail = Label.new()
	_inspector_detail.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_inspector_detail.text = "Pause with Space/P, then select an object.\nW = developer World truth\nB = Wilson's current belief"
	inspector_stack.add_child(_inspector_detail)

	var inventory_panel := PanelContainer.new()
	inventory_panel.name = "InventorySidebar"
	inventory_panel.anchor_left = 0.0
	inventory_panel.anchor_right = 0.0
	inventory_panel.anchor_top = 0.0
	inventory_panel.anchor_bottom = 1.0
	inventory_panel.offset_left = 12.0
	inventory_panel.offset_right = 308.0
	inventory_panel.offset_top = 185.0
	inventory_panel.offset_bottom = -20.0
	add_child(inventory_panel)
	_inventory_sidebar = RichTextLabel.new()
	_inventory_sidebar.bbcode_enabled = true
	_inventory_sidebar.scroll_active = true
	_inventory_sidebar.scroll_following = false
	_inventory_sidebar.fit_content = false
	_inventory_sidebar.add_theme_font_size_override("normal_font_size", 14)
	inventory_panel.add_child(_inventory_sidebar)

	_speed_label = Label.new()
	_speed_label.visible = false
	vbox.add_child(_speed_label)


func _render(snapshot: Dictionary) -> void:
	_runtime_label.text = "%s t=%.0fs · %s · step %d" % [
		"PAUSED ·" if is_zero_approx(_speed_multiplier) else "",
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
	_world_label.text = "🍎 food %d total · near %d · far %d\n👁 empty-near confidence %.2f\n🏠 shelter %d/100%s\n🐦 Gerald · ambient · %s · arrivals %d" % [
		int(snapshot.get("food_quantity", -1)),
		int(snapshot.get("near_food_quantity", -1)),
		int(snapshot.get("far_food_quantity", -1)),
		float(snapshot.get("observed_food_empty_confidence", 0.0)),
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


func _render_inspector() -> void:
	if _simulation == null or not _simulation.has_method("debug_object_snapshot") or _inspector_picker == null:
		return
	var objects: Dictionary = _simulation.debug_object_snapshot()
	var keys: Array[String] = []
	for key in objects.keys():
		keys.append(String(key))
	keys.sort()
	if keys != _inspector_keys:
		var selected := _inspector_picker.get_selected_id()
		_inspector_keys = keys
		_inspector_picker.clear()
		_inspector_picker.add_item("Select object to inspect")
		_inspector_picker.add_item("Wilson")
		for key in keys:
			_inspector_picker.add_item(key)
		_inspector_picker.select(mini(selected, keys.size() + 1))
	var index := _inspector_picker.selected
	if index == 1 and _simulation.has_method("debug_wilson_snapshot"):
		var state: Dictionary = _simulation.debug_wilson_snapshot()
		_inspector_detail.text = "World carrying: %s\nIntention: %s\nTarget: %s\nBeliefs recorded: %d" % [
			String(state.get("carried", "none")),
			String(state.get("intention", "idle")),
			String(state.get("target", "none")),
			int(state.get("belief_count", 0)),
		]
	elif index >= 2 and index - 2 < keys.size():
		var key := keys[index - 2]
		var state: Dictionary = objects.get(key, {})
		_inspector_detail.text = "W · %s\nB · %s" % [
			String(state.get("world", "unknown")),
			String(state.get("wilson", "unknown")),
		]


func _render_inventory_sidebar() -> void:
	if _inventory_sidebar == null or _simulation == null or not _simulation.has_method("debug_inventory_sidebar_snapshot"):
		return
	var state: Dictionary = _simulation.debug_inventory_sidebar_snapshot()
	var lines: Array[String] = ["[b]INVENTORIES · DEV World[/b]", "[color=gray]B = Wilson's quantity belief[/color]"]
	for inventory in state.get("inventories", []):
		lines.append("")
		lines.append("[b]%s[/b]" % String(inventory.get("name", "")))
		var items: Array = inventory.get("items", [])
		if items.is_empty():
			lines.append("  [color=gray][empty][/color]")
		for item in items:
			lines.append("  • %s ×%s" % [String(item.get("name", "item")), str(item.get("quantity", 1))])
			lines.append("    B: %s" % String(item.get("belief", "unknown")))
	lines.append("")
	lines.append("[b]──────────[/b]")
	lines.append("[b]WILSON · BELIEFS[/b]")
	for belief in state.get("beliefs", []):
		lines.append("  • %s" % String(belief).replace("[", "(").replace("]", ")"))
	var previous_scroll := _inventory_sidebar.get_v_scroll_bar().value
	_inventory_sidebar.text = "\n".join(lines)
	_inventory_sidebar.get_v_scroll_bar().value = previous_scroll
