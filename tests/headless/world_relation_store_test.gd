extends SceneTree

## Minimal deterministic smoke test for the first domain slice.
## Run once a Godot 4 project root is committed:
##   godot --headless --path . --script tests/headless/world_relation_store_test.gd

var _failures: Array[String] = []


func _init() -> void:
	_run_relation_store_slice()
	if _failures.is_empty():
		print("PASS world_relation_store_test")
		quit(0)
		return

	for failure in _failures:
		push_error(failure)
	print("FAIL world_relation_store_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_relation_store_slice() -> void:
	var stone_type := DomainId.entity_type(&"stone_small")
	var pouch_type := DomainId.entity_type(&"pouch")
	var crate_type := DomainId.entity_type(&"crate")
	var stone_category := DomainId.category(&"stone")
	var container_capability := DomainId.capability(&"container")
	var impact_capability := DomainId.capability(&"impact_surface")
	var hardness := DomainId.property(&"hardness")
	var inside := DomainId.relation_type(&"inside")
	var camp := DomainId.place(&"camp")

	var content := ContentRegistry.new()
	_expect_true(content.register_entity_definition(EntityDefinition.new(
		stone_type,
		[stone_category],
		{hardness.key(): 3},
		[impact_capability]
	)).ok, "stone definition registers")
	_expect_true(content.register_entity_definition(EntityDefinition.new(
		pouch_type,
		[],
		{},
		[container_capability]
	)).ok, "pouch definition registers")
	_expect_true(content.register_entity_definition(EntityDefinition.new(
		crate_type,
		[],
		{},
		[container_capability]
	)).ok, "crate definition registers")
	_expect_true(content.seal().ok, "content registry seals")

	var stone_id := DomainId.entity(&"stone_42")
	var pouch_id := DomainId.entity(&"pouch_7")
	var crate_id := DomainId.entity(&"crate_4")
	var entities := EntityStore.new()
	_expect_true(entities.add_entity(EntityInstance.new(stone_id, stone_type, camp)).ok, "stone instance added")
	_expect_true(entities.add_entity(EntityInstance.new(pouch_id, pouch_type, camp)).ok, "pouch instance added")
	_expect_true(entities.add_entity(EntityInstance.new(crate_id, crate_type, camp)).ok, "crate instance added")

	var stone := RuntimeWorldRef.entity(stone_id)
	var pouch := RuntimeWorldRef.entity(pouch_id)
	var crate := RuntimeWorldRef.entity(crate_id)
	var relations := WorldRelationStore.new()
	_expect_true(relations.add_relation(WorldRelation.new(inside, stone, pouch)).ok, "stone inside pouch added")
	_expect_true(relations.add_relation(WorldRelation.new(inside, pouch, crate)).ok, "pouch inside crate added")

	var duplicate := relations.add_relation(WorldRelation.new(inside, stone, pouch))
	_expect_false(duplicate.ok, "duplicate relation rejected")
	_expect_equal(String(duplicate.code), "duplicate_relation", "duplicate diagnostic code")

	var query := DefaultWorldQuery.new(entities, relations, content)
	_expect_equal(query.get_instance_property(stone, hardness), 3, "definition property visible through query")
	_expect_true(query.has_category(stone, stone_category), "category visible through query")
	_expect_true(query.has_authored_capability(crate, container_capability), "capability visible through query")

	_expect_equal(query.get_outgoing_relations(stone, inside).size(), 1, "outgoing relation indexed")
	_expect_equal(query.get_incoming_relations(crate, inside).size(), 1, "incoming relation indexed")

	var traversal := query.traverse_relations(
		stone,
		[inside],
		2,
		10,
		WorldRelationStore.Direction.OUTGOING
	)
	_expect_false(traversal.truncated, "bounded traversal completes")
	_expect_equal(_subject_keys(traversal.subjects), [String(pouch.key()), String(crate.key())], "nested containment traversal")

	var before_rebuild := _relation_keys(query.find_relations(inside))
	_expect_true(relations.validate_indexes().ok, "relation indexes valid before rebuild")
	relations.rebuild_indexes()
	_expect_true(relations.validate_indexes().ok, "relation indexes valid after rebuild")
	var after_rebuild := _relation_keys(query.find_relations(inside))
	_expect_equal(after_rebuild, before_rebuild, "rebuild preserves semantic query results")

	_expect_true(entities.set_property_override(stone_id, hardness, 4).ok, "property override mutates through owner store")
	_expect_equal(query.get_instance_property(stone, hardness), 4, "instance override wins over authored property")


func _relation_keys(relations: Array) -> Array[String]:
	var result: Array[String] = []
	for relation in relations:
		result.append(relation.sort_key())
	result.sort()
	return result


func _subject_keys(subjects: Array) -> Array[String]:
	var result: Array[String] = []
	for subject in subjects:
		result.append(subject.sort_key())
	return result


func _expect_true(actual: bool, label: String) -> void:
	if not actual:
		_failures.append("Expected true: %s" % label)


func _expect_false(actual: bool, label: String) -> void:
	if actual:
		_failures.append("Expected false: %s" % label)


func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
