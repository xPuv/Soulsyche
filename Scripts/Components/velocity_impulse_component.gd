class_name VelocityImpulse
extends RefCounted


var actor : CharacterBody2D = null
var impulse : Vector2 = Vector2.ZERO
var decay = 110


func _init(_actor, _decay) -> void:
	actor = _actor
	decay = _decay


func tick(delta):
	add_impulse(delta)


func add_impulse(delta : float):
	actor.velocity += impulse
	impulse = impulse.move_toward(Vector2.ZERO, decay * delta)
