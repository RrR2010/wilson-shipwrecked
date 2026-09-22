extends SceneTree
## Asset-pipeline smoke check; expectations are emitted by generate_camp.py export.

var failures: Array[String] = []

func _initialize() -> void:
	call_deferred("_check_imports")

func _check_imports() -> void:
	var data: Variant = JSON.parse_string(FileAccess.get_file_as_string("res://temp/camp-import-expectations.json"))
	if not data is Array or data.size() != 8:
		push_error("FAIL: export all eight camp assets before import validation")
		quit(1)
		return
	for item: Dictionary in data:
		var packed: PackedScene = load(item.path) as PackedScene
		if packed == null:
			failures.append("Missing imported scene: " + str(item.path))
			continue
		var instance: Node3D = packed.instantiate() as Node3D
		root.add_child(instance)
		if not instance.transform.is_equal_approx(Transform3D.IDENTITY):
			failures.append("Nonidentity root: " + str(item.asset_id))
		var meshes: Array[Node] = instance.find_children("*", "MeshInstance3D", true, false)
		if meshes.is_empty():
			failures.append("No geometry: " + str(item.asset_id))
		var bounds := AABB()
		var first := true
		for node: Node in meshes:
			var mesh_node := node as MeshInstance3D
			var transformed: AABB = mesh_node.global_transform * mesh_node.mesh.get_aabb()
			bounds = transformed if first else bounds.merge(transformed)
			first = false
			if not mesh_node.global_transform.is_finite() or mesh_node.global_transform.basis.determinant() <= 0:
				failures.append("Invalid mesh transform: " + str(node.name))
		var dimensions: Array = item.bounds.size
		var expected_size := Vector3(dimensions[0], dimensions[2], dimensions[1])
		# glTF can bake local transforms, tightening rotated per-mesh AABBs.
		for axis: int in range(3):
			if absf(bounds.size[axis] - expected_size[axis]) > 0.04:
				failures.append("Scale mismatch: " + str(item.asset_id))
		for anchor_name: String in item.anchors:
			var anchor := instance.find_child(anchor_name, true, false) as Node3D
			if anchor == null:
				failures.append("Missing anchor: " + anchor_name)
				continue
			var position: Array = item.anchors[anchor_name]
			var expected_position := Vector3(position[0], position[2], -position[1])
			if anchor.global_position.distance_to(expected_position) > 0.001:
				failures.append("Anchor mapping mismatch: " + anchor_name)
		if str(item.asset_id) == "ship_crate_wood_01":
			var lid := instance.find_child("SOCKET_LID__ship_crate_wood_01", true, false)
			if lid == null or lid.get_child_count() != 4:
				failures.append("Crate lid hierarchy did not survive import")
		instance.free()
	if not failures.is_empty():
		for failure: String in failures:
			push_error("FAIL: " + failure)
		quit(1)
		return
	print("PASS: eight camp GLBs imported with scale, hierarchy and anchor transforms intact")
	quit(0)
