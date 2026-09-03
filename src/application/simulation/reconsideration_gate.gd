class_name ReconsiderationGate
extends RefCounted

## Pure trigger gate for deciding whether candidate generation/routing is due.
##
## Trigger priority controls when cognition may reconsider. Candidate scores still
## control what Wilson prefers inside the admitted routing regime.

enum Trigger {
	THREAT,
	ACTION_INVALIDATION,
	ACTION_OR_INTENTION_COMPLETION,
	STRONG_ANOMALY,
	MAJOR_EVENT_OR_OPPORTUNITY,
	PLAYER_SIGNAL,
	DRIVE_URGENCY_CHANGE,
	PROJECT_CHECKPOINT,
	CONTEXT_TRANSITION,
	PERIODIC_REVIEW,
}


func coalesce(trigger_set) -> Array[int]:
	var unique: Dictionary = {}
	if trigger_set == null:
		return []
	for raw_trigger in trigger_set:
		var trigger := int(raw_trigger)
		if trigger >= Trigger.THREAT and trigger <= Trigger.PERIODIC_REVIEW:
			unique[trigger] = true
	var result: Array[int] = []
	for raw_trigger in unique.keys():
		result.append(int(raw_trigger))
	result.sort()
	return result


func should_reconsider(trigger_set) -> bool:
	return not coalesce(trigger_set).is_empty()


func has_immediate_threat(trigger_set) -> bool:
	return coalesce(trigger_set).has(Trigger.THREAT)
