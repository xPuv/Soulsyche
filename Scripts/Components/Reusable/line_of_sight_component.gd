class_name LineOfSightComponent
extends RayCast2D


@export var maximum_length : int = 128


var target : Node = null


func setup(_target : Node):
	target = _target


func _physics_process(_delta: float) -> void:
	target_position = (target.global_position - global_position)
	target_position.limit_length(maximum_length)


func target_in_line_of_sight() -> bool:
	return is_colliding() and get_collider() == target
