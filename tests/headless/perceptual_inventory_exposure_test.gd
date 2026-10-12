extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const EpistemicClaim = preload("res://src/domain/cognition/epistemic_claim.gd")
const PassiveSpatialPerceptionSource = preload("res://src/application/simulation/passive_spatial_perception_source.gd")
const SemanticPerceptualExposureResolver = preload("res://src/application/simulation/semantic_perceptual_exposure_resolver.gd")
const SemanticChange = preload("res://src/domain/world/semantic_change.gd")
const SemanticChangeSet = preload("res://src/domain/world/semantic_change_set.gd")

var _failures: Array[String] = []


class CandidateSourceStub:
	extends RefCounted
	var candidates: Array = []
	var dirty := true

	func has_pending_refresh() -> bool:
		return dirty

	func consume_refresh_candidates() -> Array:
		dirty = false
		return candidates.duplicate()

	func request_refresh() -> void:
		dirty = true


class SpatialQueryStub:
	extends RefCounted
	func metric_distance(_observer, _subject) -> float:
		return 2.0

	func has_line_of_sight(_observer, _subject) -> bool:
		return true


class RelationStub:
	extends RefCounted
	var object
	func _init(p_object) -> void:
		object = p_object


class WorldQueryStub:
	extends RefCounted
	var quantities: Dictionary = {}
	var containers: Dictionary = {}
	var occluding: Dictionary = {}
	var open_by_key: Dictionary = {}

	func get_quantity(subject) -> Variant:
		return quantities.get(subject.key())

	func get_outgoing_relations(subject, _relation_type = null) -> Array:
		var container = containers.get(subject.key())
		return [] if container == null else [RelationStub.new(container)]

	func has_authored_capability(subject, _capability_id) -> bool:
		return bool(occluding.get(subject.key(), false))

	func get_instance_property(subject, _property_id) -> Variant:
		return open_by_key.get(subject.key())


func _init() -> void:
	_run_slice()
	if _failures.is_empty():
		print("PASS perceptual_inventory_exposure_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL perceptual_inventory_exposure_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_slice() -> void:
	var wilson_ref = RuntimeWorldRef.wilson()
	var food_ref = RuntimeWorldRef.entity(DomainId.entity(&"fruit_stack"))
	var chest_ref = RuntimeWorldRef.entity(DomainId.entity(&"chest"))
	var nearby_relation = DomainId.relation_type(&"perceptibly_near")
	var inside_relation = DomainId.relation_type(&"inside")
	var occluding_container = DomainId.capability(&"visually_occluding_container")
	var open_property = DomainId.property(&"open")

	var candidates = CandidateSourceStub.new()
	candidates.candidates = [food_ref]
	var world = WorldQueryStub.new()
	world.quantities[food_ref.key()] = 3
	var exposure = SemanticPerceptualExposureResolver.new(
		world,
		inside_relation,
		occluding_container,
		open_property
	)
	var source = PassiveSpatialPerceptionSource.new(
		candidates,
		SpatialQueryStub.new(),
		wilson_ref,
		nearby_relation,
		8.0,
		&"vision",
		0.9,
		world,
		exposure
	)

	# Exposed food behaves like food on a table: Wilson learns presence and quantity.
	var visible = source.collect()
	_expect_equal(visible.evidence.size(), 2, "exposed quantified item emits presence and quantity evidence")
	_expect_true(_has_quantity(visible.evidence, food_ref, 3), "visible item reveals available quantity")

	# Moving the same item inside a closed occluding chest removes perceptual access.
	world.containers[food_ref.key()] = chest_ref
	world.occluding[chest_ref.key()] = true
	world.open_by_key[chest_ref.key()] = false
	candidates.request_refresh()
	var concealed = source.collect()
	_expect_equal(concealed.evidence.size(), 0, "closed opaque container hides contained item")

	# Gerald can alter hidden World truth. Semantic refresh revalidates exposure but must
	# not inject the new quantity into Wilson cognition while the chest remains closed.
	world.quantities[food_ref.key()] = 1
	source.notify_semantic_changes(_quantity_change(food_ref))
	var stolen_while_hidden = source.collect()
	_expect_equal(stolen_while_hidden.evidence.size(), 0, "hidden theft does not leak changed quantity")

	# Opening the chest exposes the item again. Wilson now observes the new quantity.
	world.open_by_key[chest_ref.key()] = true
	source.notify_semantic_changes(_property_change(chest_ref, open_property))
	var reopened = source.collect()
	_expect_equal(reopened.evidence.size(), 2, "opening container rearms presence and quantity observation")
	_expect_true(_has_quantity(reopened.evidence, food_ref, 1), "reinspection reveals post-theft quantity")

	# A visible quantity change produces only a fresh quantity observation, not another
	# presence edge, so continuous visibility does not spam relation evidence.
	world.quantities[food_ref.key()] = 0
	source.notify_semantic_changes(_quantity_change(food_ref))
	var visibly_exhausted = source.collect()
	_expect_equal(visibly_exhausted.evidence.size(), 1, "visible stock change emits one new observation")
	_expect_true(_has_quantity(visibly_exhausted.evidence, food_ref, 0), "Wilson can perceive explicit zero quantity")


func _quantity_change(subject):
	var changes = SemanticChangeSet.new()
	changes.add(SemanticChange.quantity_change(subject))
	return changes


func _property_change(subject, property_id):
	var changes = SemanticChangeSet.new()
	changes.add(SemanticChange.property_change(subject, property_id))
	return changes


func _has_quantity(evidence: Array, subject, expected: Variant) -> bool:
	for item in evidence:
		var claim = item.claim
		if claim.kind == EpistemicClaim.Kind.QUANTITY \
			and claim.subject.equals(subject) \
			and claim.value == expected:
			return true
	return false


func _expect_true(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _expect_equal(actual: Variant, expected: Variant, message: String) -> void:
	if actual != expected:
		_failures.append("%s (expected=%s actual=%s)" % [message, expected, actual])
