extends SceneTree

const SCENE_PATH := "res://tools/living_simulation/living_simulation.tscn"
var failures: Array[String] = []

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var scene = load(SCENE_PATH).instantiate()
	root.add_child(scene)
	for _frame in range(180):
		if scene.boot_error() != "" or scene.is_live():
			break
		await physics_frame
	if not scene.is_live():
		failures.append("Scene did not become live")
	else:
		var data: Dictionary = scene.debug_inventory_sidebar_snapshot()
		var groups: Array = data.get("inventories", [])
		_check(groups.size() >= 5, "Sidebar includes all world inventory groups")
		_check(data.has("beliefs"), "Wilson beliefs are separate from World quantities")
		var found_food := false
		for group in groups:
			if group.get("name", "") == "Food (far)":
				var items: Array = group.get("items", [])
				_check(items.size() == 1, "Far food appears as World item")
				if items.size() == 1:
					found_food = true
					_check(int(items[0].get("quantity", -1)) == 8, "World quantity is not replaced with belief")
		_check(found_food, "Far food is visible in developer inventory")
		var found_chest := false
		for group in groups:
			if group.get("name", "") != "Opaque chest":
				continue
			found_chest = true
			var items: Array = group.get("items", [])
			_check(items.size() == 1, "World displays physical chest contents")
			if items.size() == 1:
				_check(String(items[0].get("name", "")) == "chest_food_001", "Chest contains authored item")
				_check(int(items[0].get("quantity", -1)) == 2, "Chest stock is conserved before transfer")
				_check(String(items[0].get("belief", "")) == "unknown contents", "Wilson cannot know closed chest contents from developer inventory")
		_check(found_chest, "Sidebar includes opaque chest group")
	await _finish(scene)

func _finish(scene) -> void:
	Engine.time_scale = 1.0
	scene.queue_free()
	await process_frame
	if failures.is_empty():
		print("PASS living_simulation_inventory_sidebar_test")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		print("FAIL living_simulation_inventory_sidebar_test: %d failure(s)" % failures.size())
		quit(1)

func _check(value: bool, label: String) -> void:
	if not value:
		failures.append(label)
