class_name KnockbackComponent
extends RefCounted


var movement_component : MovementComponent = null


func _init(_movement_component : MovementComponent) -> void:
	movement_component = _movement_component


func take_knockback(current_position : Vector2, knocking_object_position : Vector2, knockback_strength : int):
	var direciton = knocking_object_position.direction_to(current_position)
	movement_component.add_impulse(75, direciton * knockback_strength)
