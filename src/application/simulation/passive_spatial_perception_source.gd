class_name PassiveSpatialPerceptionSource
extends RefCounted

const EpistemicClaim = preload("res://src/domain/cognition/epistemic_claim.gd")
const PerceptualEvidence = preload("res://src/domain/cognition/perceptual_evidence.gd")
const PerceptionResult = preload("res://src/domain/cognition/perception_result.gd")

## Projects dirty engine-side proximity candidates into Wilson-relative perceptual evidence.
##
## The candidate source is non-authoritative broadphase state. Metric range and line of
## sight are revalidated through SpatialQueryPort before evidence is emitted.
##
## Positive evidence is edge-driven. Bounded movement refreshes may revalidate the same
## active broadphase candidate many times, but unchanged perceptual access does not emit
## duplicate evidence. Losing metric/LOS access rearms the subject for a future positive
## transition.

var _candidate_source
var _spatial_query
var _observer
var _relation_type
var _max_distance: float
var _modality: StringName
var _confidence: float
var _sequence: int = 0
var _accessible_by_key: Dictionary = {}


func _init(
	candidate_source,
	spatial_query,
	observer,
	relation_type,
	max_distance: float,
	modality: StringName = &"vision",
	confidence: float = 0.9
) -> void:
	assert(candidate_source != null, "PassiveSpatialPerceptionSource requires candidate source")
	assert(spatial_query != null, "PassiveSpatialPerceptionSource requires SpatialQueryPort")
	assert(observer != null, "PassiveSpatialPerceptionSource requires observer")
	assert(relation_type != null, "PassiveSpatialPerceptionSource requires relation type")
	assert(is_finite(max_distance) and max_distance > 0.0, "max_distance must be finite and positive")
	assert(modality != &"", "modality cannot be empty")
	assert(confidence >= 0.0 and confidence <= 1.0, "confidence must be within [0,1]")
	_candidate_source = candidate_source
	_spatial_query = spatial_query
	_observer = observer
	_relation_type = relation_type
	_max_distance = max_distance
	_modality = modality
	_confidence = confidence


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
		var key = subject.key()
		active_keys[key] = true

		var distance: float = _spatial_query.metric_distance(_observer, subject)
		if not is_finite(distance) or distance > _max_distance:
			_accessible_by_key.erase(key)
			diagnostics.append("Passive candidate outside metric access: %s" % subject.sort_key())
			continue
		if not _spatial_query.has_line_of_sight(_observer, subject):
			_accessible_by_key.erase(key)
			diagnostics.append("Passive candidate occluded: %s" % subject.sort_key())
			continue

		if _accessible_by_key.has(key):
			continue
		_accessible_by_key[key] = true
		_sequence += 1
		var source_id := StringName("passive_spatial_%d" % _sequence)
		evidence.append(PerceptualEvidence.new(
			EpistemicClaim.relation_claim(_observer, _relation_type, subject),
			_confidence,
			source_id,
			_modality
		))

	# Candidate removal also clears positive-access memory so a later re-entry can emit
	# a new observation without requiring negative evidence in this slice.
	for remembered_key in _accessible_by_key.keys():
		if not active_keys.has(remembered_key):
			_accessible_by_key.erase(remembered_key)

	return PerceptionResult.new([], evidence, diagnostics)
