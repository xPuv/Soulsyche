class_name SmoothMovementComponent
extends RefCounted


func move(actor : Node2D, speed_value: float, direction : Vector2, delta : float):
	actor.velocity = lerp(actor.velocity, direction * speed_value, 1.0 - exp(-speed_value / 3 * delta))


func tick(vector : Vector2, actor : Node2D, speed, delta : float):
	move(actor, speed, vector, delta)
