class_name BurnVisualEffect
extends VisualEffect


func start_effect() -> void:
	var sprite : Sprite2D = actor.find_child("MainSprite")
	sprite.global_position = actor.global_position
	sprite.modulate -= Color(.5, 0, 0, 1)


func end_effect() -> void:
	var sprite : Sprite2D = actor.find_child("MainSprite")
	sprite.global_position = actor.global_position
	sprite.modulate += Color(.5, 0, 0, 1)
