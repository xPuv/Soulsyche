@abstract
class_name VisualEffect
extends RefCounted


var actor : Node2D = null
var duration : float = 0.0

signal effect_complete


func _init(_actor : Node2D, _duration : float) -> void:
	actor = _actor
	duration = _duration

@abstract func start_effect() -> void
