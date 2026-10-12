extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const RoleBinding = preload("res://src/domain/actions/role_binding.gd")
const ActionOutcome = preload("res://src/domain/actions/action_outcome.gd")
const WorldCommitResult = preload("res://src/domain/world/world_commit_result.gd")
const DriveState = preload("res://src/domain/cognition/drive_state.gd")
const DriveConsequenceDefinition = preload("res://src/domain/cognition/drive_consequence_definition.gd")
const GroundedDriveConsequenceService = preload("res://src/application/simulation/grounded_drive_consequence_service.gd")

class FoodQuery:
	extends RefCounted
	var values: Dictionary = {}
	func get_instance_property(target, _property_id) -> Variant:
		return values.get(target.key())

func _init() -> void:
	var food_action = DomainId.action(&"consume_food")
	var consumed = DomainId.event_definition(&"food_consumed")
	var relief = DomainId.property(&"hunger_relief")
	var berries = RuntimeWorldRef.entity(DomainId.entity(&"berries"))
	var coconut = RuntimeWorldRef.entity(DomainId.entity(&"coconut"))
	var query = FoodQuery.new()
	query.values[berries.key()] = 0.2
	query.values[coconut.key()] = 0.45
	var drive = DriveState.new({DriveState.HUNGER: 0.9})
	var policy = DriveConsequenceDefinition.new(food_action, DriveState.HUNGER, -0.2, consumed, relief, &"target")
	var service = GroundedDriveConsequenceService.new(drive, [policy], query)
	var committed = WorldCommitResult.new(true, [], [])
	var rejected = WorldCommitResult.new(false, [], [], ["empty stock"])
	assert(service.apply_grounded(_outcome(&"rejected", food_action, consumed, berries), rejected).ok)
	assert(is_equal_approx(drive.value(DriveState.HUNGER), 0.9))
	assert(service.apply_grounded(_outcome(&"berry", food_action, consumed, berries), committed).ok)
	assert(is_equal_approx(drive.value(DriveState.HUNGER), 0.7))
	assert(service.apply_grounded(_outcome(&"coconut", food_action, consumed, coconut), committed).ok)
	assert(is_equal_approx(drive.value(DriveState.HUNGER), 0.25))
	assert(service.apply_grounded(_outcome(&"coconut", food_action, consumed, coconut), committed).ok)
	assert(is_equal_approx(drive.value(DriveState.HUNGER), 0.25))
	query.values[coconut.key()] = NAN
	assert(service.apply_grounded(_outcome(&"bad", food_action, consumed, coconut), committed).code == &"drive_consequence_invalid_resource")
	assert(is_equal_approx(drive.value(DriveState.HUNGER), 0.25))
	print("PASS resource_food_benefit_test")
	quit(0)

func _outcome(execution: StringName, action, event, target):
	var binding = RoleBinding.new()
	binding.bind(&"target", target)
	return ActionOutcome.new(execution, action, binding, [], event)
