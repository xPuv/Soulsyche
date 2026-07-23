class_name MovementComponent
extends RefCounted


func move(actor : Node2D, speed_value: float, direction : Vector2):
	actor.velocity = speed_value * direction


func tick(vector : Vector2, actor : Node2D, speed : float):
	move(actor, speed, vector)
