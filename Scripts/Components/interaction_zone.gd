class_name InteractionSystem
extends Area2D


func get_target():
	if get_overlapping_bodies() == []:
		return null

	var sorted_bodies : Array = get_overlapping_bodies()
	@warning_ignore("standalone_expression")
	sorted_bodies.sort_custom(func(a, b):global_position.distance_squared_to(a.global_position) < global_position.distance_squared_to(b.global_position))
	return sorted_bodies[0]
