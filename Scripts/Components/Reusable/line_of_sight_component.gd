class_name LineOfSightComponent
extends ShapeCast2D


@export var maximum_length : int = 128


var target : Node = null


func setup(_target : Node):
	target = _target


func _physics_process(_delta: float) -> void:
	target_position = (target.global_position - global_position)
	target_position.limit_length(maximum_length)


func target_in_line_of_sight() -> bool:
	var target_found : bool = false
	var num_spotted : int = 0
	force_shapecast_update()
	for i in range(get_collision_count()):
		print(get_collision_count())
		num_spotted += 1
		var col = get_collider(i)
		if col == target:
			target_found = true
	return is_colliding() and target_found and num_spotted == 1
