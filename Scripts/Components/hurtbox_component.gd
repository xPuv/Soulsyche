class_name HurtboxComponent
extends Area2D


signal hitbox_entered(hitbox : HitboxComponent)


func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _on_area_entered(area):
	if area is HitboxComponent:
		hitbox_entered.emit(area)
