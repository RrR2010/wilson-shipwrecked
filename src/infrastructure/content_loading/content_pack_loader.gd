class_name ContentPackLoader
extends RefCounted

const DomainId = preload("res://src/domain/core/domain_id.gd")
const MutationResult = preload("res://src/domain/core/mutation_result.gd")
const SemanticValueKey = preload("res://src/domain/core/semantic_value_key.gd")
const ContentRegistry = preload("res://src/domain/content/content_registry.gd")
const PropertyDefinition = preload("res://src/domain/content/property_definition.gd")
const EntityDefinition = preload("res://src/domain/content/entity_definition.gd")
const EventDefinition = preload("res://src/domain/content/event_definition.gd")
const RequirementPredicate = preload("res://src/domain/actions/requirement_predicate.gd")
const ActionDefinition = preload("res://src/domain/actions/action_definition.gd")
const ActionEffect = preload("res://src/domain/actions/action_effect.gd")
const ActionResolutionDefinition = preload("res://src/domain/actions/action_resolution_definition.gd")
const AssemblyDefinition = preload("res://src/domain/physical/assembly_definition.gd")
const AssemblySlotDefinition = preload("res://src/domain/physical/assembly_slot_definition.gd")
const PropertyDerivationDefinition = preload("res://src/domain/physical/property_derivation_definition.gd")
const PropertyInputSelector = preload("res://src/domain/physical/property_input_selector.gd")

const SCHEMA_VERSION := 1


func load_json(json_text: String) -> MutationResult:
	var parsed = JSON.parse_string(json_text)
	if not (parsed is Dictionary):
		return MutationResult.failure(&"invalid_content_json", ["Content pack must decode to a Dictionary"])
	return load_dictionary(parsed)


func load_dictionary(pack: Dictionary) -> MutationResult:
	if int(pack.get("schema_version", -1)) != SCHEMA_VERSION:
		return MutationResult.failure(&"unsupported_content_schema", ["Expected content schema version %d" % SCHEMA_VERSION])
	var registry = ContentRegistry.new()
	var result = _load_properties(pack.get("properties", []), registry)
	if not result.ok:
		return result
	result = _load_events(pack.get("events", []), registry)
	if not result.ok:
		return result
	result = _load_entities(pack.get("entities", []), registry)
	if not result.ok:
		return result
	result = _load_assemblies(pack.get("assemblies", []), registry)
	if not result.ok:
		return result
	result = _load_property_derivations(pack.get("property_derivations", []), registry)
	if not result.ok:
		return result
	result = _load_actions(pack.get("actions", []), registry)
	if not result.ok:
		return result
	result = _load_resolutions(pack.get("resolutions", []), registry)
	if not result.ok:
		return result
	var seal_result = registry.seal()
	if not seal_result.ok:
		return MutationResult.failure(&"content_pack_validation_failed", seal_result.diagnostics)
	return MutationResult.success(&"content_pack_loaded", registry)


func _load_properties(records, registry) -> MutationResult:
	if not (records is Array):
		return _shape_failure("properties must be an Array")
	for record in records:
		if not (record is Dictionary) or not record.has("id") or not record.has("family"):
			return _shape_failure("property record requires id and family")
		var family = _property_family(String(record["family"]))
		if family < 0:
			return MutationResult.failure(&"unknown_property_family", [String(record["family"])])
		var definition = PropertyDefinition.new(
			DomainId.property(StringName(record["id"])), family, record.get("min"), record.get("max")
		)
		var result = registry.register_property_definition(definition)
		if not result.ok:
			return result
	return MutationResult.success(&"content_properties_loaded")


func _load_events(records, registry) -> MutationResult:
	if not (records is Array):
		return _shape_failure("events must be an Array")
	for record in records:
		if not (record is Dictionary) or not record.has("id"):
			return _shape_failure("event record requires id")
		var roles_result = _string_name_array(record.get("perceptible_roles", []), "event perceptible_roles")
		if not roles_result.ok:
			return roles_result
		var modalities_result = _string_name_array(record.get("modalities", []), "event modalities")
		if not modalities_result.ok:
			return modalities_result
		var definition = EventDefinition.new(
			DomainId.event_definition(StringName(record["id"])),
			roles_result.value,
			modalities_result.value,
			float(record.get("base_confidence", 1.0))
		)
		var result = registry.register_event_definition(definition)
		if not result.ok:
			return result
	return MutationResult.success(&"content_events_loaded")


func _load_entities(records, registry) -> MutationResult:
	if not (records is Array):
		return _shape_failure("entities must be an Array")
	for record in records:
		if not (record is Dictionary) or not record.has("id"):
			return _shape_failure("entity record requires id")
		var categories: Array = []
		for value in record.get("categories", []):
			categories.append(DomainId.category(StringName(value)))
		var capabilities: Array = []
		for value in record.get("capabilities", []):
			capabilities.append(DomainId.capability(StringName(value)))
		var base_properties: Dictionary = {}
		var authored_properties = record.get("base_properties", {})
		if not (authored_properties is Dictionary):
			return _shape_failure("entity base_properties must be a Dictionary")
		for property_name in authored_properties.keys():
			base_properties[DomainId.property(StringName(property_name)).key()] = authored_properties[property_name]
		var definition = EntityDefinition.new(
			DomainId.entity_type(StringName(record["id"])), categories, base_properties, capabilities
		)
		var result = registry.register_entity_definition(definition)
		if not result.ok:
			return result
	return MutationResult.success(&"content_entities_loaded")


func _load_assemblies(records, registry) -> MutationResult:
	if not (records is Array):
		return _shape_failure("assemblies must be an Array")
	for record in records:
		if not (record is Dictionary) or not record.has("id"):
			return _shape_failure("assembly record requires id")
		var raw_slots = record.get("slots", [])
		if not (raw_slots is Array):
			return _shape_failure("assembly slots must be an Array")
		var slots: Array = []
		for slot_record in raw_slots:
			if not (slot_record is Dictionary) or not slot_record.has("id") or not slot_record.has("role") or not slot_record.has("accepted_component"):
				return _shape_failure("assembly slot requires id, role and accepted_component")
			var predicate_result = _parse_predicate(slot_record["accepted_component"])
			if not predicate_result.ok:
				return predicate_result
			var optional := bool(slot_record.get("optional", false))
			var min_count := int(slot_record.get("min_count", 0 if optional else 1))
			var max_count := int(slot_record.get("max_count", 1))
			slots.append(AssemblySlotDefinition.new(
				DomainId.assembly_slot(StringName(slot_record["id"])),
				DomainId.assembly_role(StringName(slot_record["role"])),
				predicate_result.value,
				min_count,
				max_count,
				optional
			))
		var definition = AssemblyDefinition.new(
			DomainId.assembly_definition(StringName(record["id"])), slots
		)
		var result = registry.register_assembly_definition(definition)
		if not result.ok:
			return result
	return MutationResult.success(&"content_assemblies_loaded")


func _load_property_derivations(records, registry) -> MutationResult:
	if not (records is Array):
		return _shape_failure("property_derivations must be an Array")
	for record in records:
		if not (record is Dictionary) or not record.has("id") or not record.has("inputs") or not record.has("output") or not record.has("policy"):
			return _shape_failure("property derivation requires id, inputs, output and policy")
		if not (record["inputs"] is Array):
			return _shape_failure("property derivation inputs must be an Array")
		var inputs: Array = []
		for input_record in record["inputs"]:
			var input_result = _parse_property_input(input_record)
			if not input_result.ok:
				return input_result
			inputs.append(input_result.value)
		var definition = PropertyDerivationDefinition.new(
			StringName(record["id"]),
			inputs,
			DomainId.property(StringName(record["output"])),
			StringName(record["policy"])
		)
		var result = registry.register_property_derivation_definition(definition)
		if not result.ok:
			return result
	return MutationResult.success(&"content_property_derivations_loaded")


func _parse_property_input(record) -> MutationResult:
	if not (record is Dictionary) or not record.has("kind") or not record.has("property"):
		return _shape_failure("property derivation input requires kind and property")
	var property_id = DomainId.property(StringName(record["property"]))
	match String(record["kind"]):
		"self":
			return MutationResult.success(&"property_input_parsed", PropertyInputSelector.subject_property(property_id))
		"assembly_slot":
			if not record.has("slot"):
				return _shape_failure("assembly_slot property input requires slot")
			return MutationResult.success(
				&"property_input_parsed",
				PropertyInputSelector.assembly_slot_property(DomainId.assembly_slot(StringName(record["slot"])), property_id)
			)
	return MutationResult.failure(&"unknown_property_input_kind", [String(record["kind"])])


func _load_actions(records, registry) -> MutationResult:
	if not (records is Array):
		return _shape_failure("actions must be an Array")
	for record in records:
		if not (record is Dictionary) or not record.has("id") or not record.has("requirements"):
			return _shape_failure("action record requires id and requirements")
		var roles_result = _string_name_array(record.get("roles", []), "action roles")
		if not roles_result.ok:
			return roles_result
		var predicate_result = _parse_predicate(record["requirements"])
		if not predicate_result.ok:
			return predicate_result
		var interruption_class = _interruption_class(String(record.get("interruption", "pre_commit_only")))
		if interruption_class < 0:
			return MutationResult.failure(&"unknown_interruption_class", [String(record.get("interruption"))])
		var definition = ActionDefinition.new(
			DomainId.action(StringName(record["id"])), roles_result.value, predicate_result.value, interruption_class
		)
		var result = registry.register_action_definition(definition)
		if not result.ok:
			return result
	return MutationResult.success(&"content_actions_loaded")


func _load_resolutions(records, registry) -> MutationResult:
	if not (records is Array):
		return _shape_failure("resolutions must be an Array")
	for record in records:
		if not (record is Dictionary) or not record.has("id") or not record.has("action") or not record.has("event"):
			return _shape_failure("resolution record requires id, action and event")
		var action_id = DomainId.action(StringName(record["action"]))
		if registry.get_action_definition(action_id) == null:
			return MutationResult.failure(&"unknown_resolution_action", [action_id.sort_key()])
		var effects: Array = []
		for effect_record in record.get("effects", []):
			var effect_result = _parse_effect(effect_record)
			if not effect_result.ok:
				return effect_result
			effects.append(effect_result.value)
		var definition = ActionResolutionDefinition.new(
			action_id,
			float(record.get("duration", 1.0)),
			float(record.get("commit_fraction", 1.0)),
			effects,
			DomainId.event_definition(StringName(record["event"])),
			StringName(record["id"])
		)
		var result = registry.register_action_resolution_definition(definition)
		if not result.ok:
			return result
	return MutationResult.success(&"content_resolutions_loaded")


func _parse_predicate(record) -> MutationResult:
	if not (record is Dictionary) or not record.has("kind"):
		return _shape_failure("predicate requires kind")
	var kind = String(record["kind"])
	match kind:
		"all_of", "any_of":
			var children: Array = []
			var raw_children = record.get("children", [])
			if not (raw_children is Array):
				return _shape_failure("predicate children must be Array")
			for child_record in raw_children:
				var child_result = _parse_predicate(child_record)
				if not child_result.ok:
					return child_result
				children.append(child_result.value)
			return MutationResult.success(&"predicate_parsed", RequirementPredicate.all_of(children) if kind == "all_of" else RequirementPredicate.any_of(children))
		"not":
			var child_result = _parse_predicate(record.get("child"))
			if not child_result.ok:
				return child_result
			return MutationResult.success(&"predicate_parsed", RequirementPredicate.negate(child_result.value))
		"has_capability":
			if not record.has("role") or not record.has("capability"):
				return _shape_failure("has_capability requires role/capability")
			return MutationResult.success(&"predicate_parsed", RequirementPredicate.has_capability(StringName(record["role"]), DomainId.capability(StringName(record["capability"]))))
		"has_category":
			if not record.has("role") or not record.has("category"):
				return _shape_failure("has_category requires role/category")
			return MutationResult.success(&"predicate_parsed", RequirementPredicate.has_category(StringName(record["role"]), DomainId.category(StringName(record["category"]))))
		"property_compare":
			if not record.has("role") or not record.has("property") or not record.has("op") or not record.has("value"):
				return _shape_failure("property_compare requires role/property/op/value")
			var op = _compare_op(String(record["op"]))
			if op < 0:
				return MutationResult.failure(&"unknown_compare_op", [String(record["op"])])
			return MutationResult.success(&"predicate_parsed", RequirementPredicate.property_compare(StringName(record["role"]), DomainId.property(StringName(record["property"])), op, record["value"]))
		"has_relation":
			if not record.has("subject_role") or not record.has("relation") or not record.has("object_role"):
				return _shape_failure("has_relation requires subject_role/relation/object_role")
			return MutationResult.success(&"predicate_parsed", RequirementPredicate.has_relation(StringName(record["subject_role"]), DomainId.relation_type(StringName(record["relation"])), StringName(record["object_role"])))
	return MutationResult.failure(&"unknown_predicate_kind", [kind])


func _parse_effect(record) -> MutationResult:
	if not (record is Dictionary) or not record.has("kind") or not record.has("subject_role"):
		return _shape_failure("effect requires kind and subject_role")
	var kind = String(record["kind"])
	match kind:
		"set_property":
			if not record.has("property") or not record.has("value"):
				return _shape_failure("set_property requires property/value")
			return MutationResult.success(&"effect_parsed", ActionEffect.new(ActionEffect.Kind.SET_PROPERTY, StringName(record["subject_role"]), DomainId.property(StringName(record["property"])), record["value"]))
		"create_relation", "remove_relation":
			if not record.has("relation") or not record.has("object_role"):
				return _shape_failure("relation effect requires relation/object_role")
			var qualifier_result = _parse_relation_qualifier(record.get("qualifier"))
			if not qualifier_result.ok:
				return qualifier_result
			var effect_kind = ActionEffect.Kind.CREATE_RELATION if kind == "create_relation" else ActionEffect.Kind.REMOVE_RELATION
			return MutationResult.success(&"effect_parsed", ActionEffect.new(
				effect_kind,
				StringName(record["subject_role"]),
				DomainId.relation_type(StringName(record["relation"])),
				qualifier_result.value,
				StringName(record["object_role"])
			))
	return MutationResult.failure(&"unknown_effect_kind", [kind])


func _parse_relation_qualifier(value: Variant) -> MutationResult:
	if value is Dictionary:
		if String(value.get("kind", "")) == "assembly_slot" and value.has("id") and not String(value["id"]).is_empty():
			return MutationResult.success(&"relation_qualifier_parsed", DomainId.assembly_slot(StringName(value["id"])))
		return MutationResult.failure(&"invalid_relation_qualifier", ["Typed qualifier Dictionary must use {kind: assembly_slot, id: ...}"])
	if value is String:
		value = StringName(value)
	if not SemanticValueKey.supports(value):
		return MutationResult.failure(&"invalid_relation_qualifier", ["Relation qualifier must be a bounded semantic value"])
	return MutationResult.success(&"relation_qualifier_parsed", value)


func _property_family(value: String) -> int:
	match value:
		"number": return PropertyDefinition.ValueFamily.NUMBER
		"boolean": return PropertyDefinition.ValueFamily.BOOLEAN
		"symbol": return PropertyDefinition.ValueFamily.SYMBOL
	return -1


func _interruption_class(value: String) -> int:
	match value:
		"pre_commit_only": return ActionDefinition.InterruptionClass.PRE_COMMIT_ONLY
		"never": return ActionDefinition.InterruptionClass.NEVER
		"anytime": return ActionDefinition.InterruptionClass.ANYTIME
	return -1


func _compare_op(value: String) -> int:
	match value:
		"==": return RequirementPredicate.CompareOp.EQ
		"!=": return RequirementPredicate.CompareOp.NE
		"<": return RequirementPredicate.CompareOp.LT
		"<=": return RequirementPredicate.CompareOp.LTE
		">": return RequirementPredicate.CompareOp.GT
		">=": return RequirementPredicate.CompareOp.GTE
	return -1


func _string_name_array(value, label: String) -> MutationResult:
	if not (value is Array):
		return _shape_failure("%s must be Array" % label)
	var result: Array[StringName] = []
	for item in value:
		if not (item is String or item is StringName) or String(item).is_empty():
			return _shape_failure("%s contains invalid string" % label)
		result.append(StringName(item))
	return MutationResult.success(&"string_name_array_parsed", result)


func _shape_failure(message: String) -> MutationResult:
	return MutationResult.failure(&"invalid_content_shape", [message])
