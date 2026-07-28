class_name GunHoldData
extends Resource
## Configure in editor before trying to make these.

@export var offhand_required : bool = false

@export_category("Poses")
@export var left_one_handed: GunHoldPose
@export var right_one_handed: GunHoldPose
@export var left_two_handed: GunHoldPose
@export var right_two_handed: GunHoldPose




func get_pose(is_facing_left : bool) -> GunHoldPose:
	if offhand_required:
		return left_two_handed if is_facing_left else right_two_handed
	else:
		return left_one_handed if is_facing_left else right_one_handed
