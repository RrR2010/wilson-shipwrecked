class_name PassiveSpatialPerceptionSource
extends RefCounted

const EpistemicClaim = preload("res://src/domain/cognition/epistemic_claim.gd")
const PerceptualEvidence = preload("res://src/domain/cognition/perceptual_evidence.gd")
const PerceptionResult = preload("res://src/domain/cognition/perception_result.gd")

## Projects dirty engine-side proximity candidates into Wilson-relative perceptual evidence.
##
## The candidate source is non-authoritative broadphase state. Metric range and line of
## sight are revalidated through SpatialQueryPort before evidence is emitted.

var _candidate_source
var _spatial_query
var _observer
var _relation_type
var _max_distance: float
var _modality: StringName
var _confidence: float
var _sequence: int = 0


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
	for subject in candidates:
		if subject == null or subject.equals(_observer):
			continue
		var distance: float = _spatial_query.metric_distance(_observer, subject)
		if not is_finite(distance) or distance > _max_distance:
			diagnostics.append("Passive candidate outside metric access: %s" % subject.sort_key())
			continue
		if not _spatial_query.has_line_of_sight(_observer, subject):
			diagnostics.append("Passive candidate occluded: %s" % subject.sort_key())
			continue
		_sequence += 1
		var source_id := StringName("passive_spatial_%d" % _sequence)
		evidence.append(PerceptualEvidence.new(
			EpistemicClaim.relation_claim(_observer, _relation_type, subject),
			_confidence,
			source_id,
			_modality
		))
	return PerceptionResult.new([], evidence, diagnostics)
