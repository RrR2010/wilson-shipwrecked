class_name PassiveSpatialPerceptionSource
extends RefCounted

const EpistemicClaim = preload("res://src/domain/cognition/epistemic_claim.gd")
const PerceptualEvidence = preload("res://src/domain/cognition/perceptual_evidence.gd")
const PerceptionResult = preload("res://src/domain/cognition/perception_result.gd")

## Projects dirty engine-side proximity candidates into Wilson-relative perceptual evidence.
##
## The candidate source is non-authoritative broadphase state. Metric range and line of
## sight are revalidated through SpatialQueryPort before evidence is emitted. Optional
## semantic exposure prevents contained objects from leaking through engine broadphase.
##
## Positive relation evidence is edge-driven. Quantity and explicitly configured
## observable-property evidence are snapshot-driven: while a subject remains exposed,
## changed authoritative values emit new observations on the next bounded refresh.
## World values are consulted only after metric/LOS/exposure access succeeds, so this
## source cannot inject hidden truth into Wilson cognition.

var _candidate_source
var _spatial_query
var _observer
var _relation_type
var _max_distance: float
var _modality: StringName
var _confidence: float
var _world_query
var _exposure_resolver
var _observable_property_ids: Array = []
var _sequence: int = 0
var _accessible_by_key: Dictionary = {}
var _quantity_by_key: Dictionary = {}
var _property_value_by_key: Dictionary = {}


func _init(
	candidate_source,
	spatial_query,
	observer,
	relation_type,
	max_distance: float,
	modality: StringName = &"vision",
	confidence: float = 0.9,
	world_query = null,
	exposure_resolver = null,
	observable_property_ids: Array = []
) -> void:
	assert(candidate_source != null, "PassiveSpatialPerceptionSource requires candidate source")
	assert(spatial_query != null, "PassiveSpatialPerceptionSource requires SpatialQueryPort")
	assert(observer != null, "PassiveSpatialPerceptionSource requires observer")
	assert(relation_type != null, "PassiveSpatialPerceptionSource requires relation type")
	assert(is_finite(max_distance) and max_distance > 0.0, "max_distance must be finite and positive")
	assert(modality != &"", "modality cannot be empty")
	assert(confidence >= 0.0 and confidence <= 1.0, "confidence must be within [0,1]")
	assert(exposure_resolver == null or world_query != null, "Semantic exposure requires WorldQuery")
	assert(observable_property_ids.is_empty() or world_query != null, "Observable properties require WorldQuery")
	_candidate_source = candidate_source
	_spatial_query = spatial_query
	_observer = observer
	_relation_type = relation_type
	_max_distance = max_distance
	_modality = modality
	_confidence = confidence
	_world_query = world_query
	_exposure_resolver = exposure_resolver
	_observable_property_ids = observable_property_ids.duplicate()


func notify_semantic_changes(change_set) -> void:
	if change_set == null or change_set.is_empty():
		return
	if _candidate_source.has_method("request_refresh"):
		_candidate_source.request_refresh()


func collect(_step_context = null):
	if not _candidate_source.has_pending_refresh():
		return PerceptionResult.new()

	var candidates: Array = _candidate_source.consume_refresh_candidates()
	var evidence: Array = []
	var diagnostics: Array[String] = []
	var active_keys: Dictionary = {}

	for subject in candidates:
		if subject == null or subject.equals(_observer):
			continue
		var key: StringName = subject.key()
		active_keys[key] = true

		var distance: float = _spatial_query.metric_distance(_observer, subject)
		if not is_finite(distance) or distance > _max_distance:
			_clear_access(key)
			diagnostics.append("Passive candidate outside metric access: %s" % subject.sort_key())
			continue
		if not _spatial_query.has_line_of_sight(_observer, subject):
			_clear_access(key)
			diagnostics.append("Passive candidate occluded: %s" % subject.sort_key())
			continue
		if _exposure_resolver != null and not _exposure_resolver.is_exposed(subject):
			_clear_access(key)
			diagnostics.append("Passive candidate semantically concealed: %s" % subject.sort_key())
			continue

		var newly_accessible := not _accessible_by_key.has(key)
		_accessible_by_key[key] = true
		if newly_accessible:
			evidence.append(_evidence(EpistemicClaim.relation_claim(_observer, _relation_type, subject)))

		if _world_query != null:
			var quantity = _world_query.get_quantity(subject)
			if quantity is int or quantity is float:
				if not _quantity_by_key.has(key) or _quantity_by_key[key] != quantity:
					_quantity_by_key[key] = quantity
					evidence.append(_evidence(EpistemicClaim.quantity_claim(subject, quantity)))
			for property_id in _observable_property_ids:
				var value = _world_query.get_instance_property(subject, property_id)
				if value == null:
					continue
				var property_key := "%s|%s" % [String(key), String(property_id.key())]
				if not _property_value_by_key.has(property_key) or _property_value_by_key[property_key] != value:
					_property_value_by_key[property_key] = value
					evidence.append(_evidence(EpistemicClaim.property_claim(subject, property_id, value)))

	# Candidate removal also clears access snapshots so a later re-entry emits fresh
	# relation and quantity observations. Wilson's durable memory lives elsewhere.
	for remembered_key in _accessible_by_key.keys():
		if not active_keys.has(remembered_key):
			_clear_access(remembered_key)

	return PerceptionResult.new([], evidence, diagnostics)


func _evidence(claim):
	_sequence += 1
	return PerceptualEvidence.new(
		claim,
		_confidence,
		StringName("passive_spatial_%d" % _sequence),
		_modality
	)


func _clear_access(key: Variant) -> void:
	_accessible_by_key.erase(key)
	_quantity_by_key.erase(key)
	for property_id in _observable_property_ids:
		_property_value_by_key.erase("%s|%s" % [String(key), String(property_id.key())])
