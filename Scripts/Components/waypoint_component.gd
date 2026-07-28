class_name WaypointComponent
extends RefCounted


var radius : int = 0
var minimum_offset : int = 40

func _init(_radius : int) -> void:
	radius = _radius


func calculate_random_position(from_origin : Vector2) -> Vector2:
	while true:
		var offset : Vector2 = Vector2(
		randi_range(-radius, radius),
		randi_range(-radius, radius)
		)

		if offset.length() >= minimum_offset:
			return from_origin + offset
	return from_origin + Vector2(25, 25)
