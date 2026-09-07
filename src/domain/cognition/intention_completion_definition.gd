class_name IntentionCompletionDefinition
extends RefCounted

const DomainId = preload("res://src/domain/core/domain_id.gd")

## Authored policy stating which grounded action outcome satisfies one semantic
## intention. Action completion alone is deliberately not treated as intention
## completion because many intentions require several tactics/actions.

var intention_id
var action_id
var event_type


func _init(p_intention_id, p_action_id, p_event_type = null) -> void:
	assert(p_intention_id != null, "IntentionCompletionDefinition requires SemanticIntentionId")
	p_intention_id.assert_kind(DomainId.Kind.SEMANTIC_INTENTION)
	assert(p_action_id != null, "IntentionCompletionDefinition requires ActionId")
	p_action_id.assert_kind(DomainId.Kind.ACTION)
	if p_event_type != null:
		p_event_type.assert_kind(DomainId.Kind.EVENT_DEFINITION)
	intention_id = p_intention_id
	action_id = p_action_id
	event_type = p_event_type


func matches(intention_state, outcome) -> bool:
	if intention_state == null or intention_state.intention_id == null or outcome == null or outcome.action_id == null:
		return false
	if not intention_id.equals(intention_state.intention_id) or not action_id.equals(outcome.action_id):
		return false
	return event_type == null or (outcome.event_type != null and event_type.equals(outcome.event_type))


func stable_key() -> String:
	var event_key: String = "*" if event_type == null else String(event_type.sort_key())
	return "%s|%s|%s" % [intention_id.sort_key(), action_id.sort_key(), event_key]
