class_name HurtboxComponent
extends Area2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

signal hitbox_entered(hitbox : HitboxComponent)

var can_take_damage : bool = true


func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _on_area_entered(area):
	if area is HitboxComponent and can_take_damage:
		hitbox_entered.emit(area)


func set_can_take_damage(to : bool):
	can_take_damage = to


func disable():
	can_take_damage = false


func enable():
	can_take_damage = true
