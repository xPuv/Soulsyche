class_name GhostEffect
extends VisualEffect


func start_effect():
	var sprite : Sprite2D = actor.find_child("MainSprite")
	var ghost_sprite = sprite.duplicate()
	ghost_sprite.global_position = actor.global_position
	ghost_sprite.modulate = Color(0.2, 0.2, 0.2, 1)
	if Utils.get_effects_layer():
		Utils.get_effects_layer().add_child(ghost_sprite)
	var tween = ghost_sprite.create_tween()
	tween.tween_property(ghost_sprite, "modulate:a", 0, duration)
	await tween.finished
	ghost_sprite.queue_free()
	effect_complete.emit()



func end_effect():
	pass
