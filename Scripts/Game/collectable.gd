class_name Collectable
extends StaticBody2D

@onready var sprite_2d : Sprite2D = $Sprite2D

@export var drop : Resource = null


func _ready() -> void:
	set_collision_layer_value(8, false)
	if drop:
		sprite_2d.texture = drop.texture
	await get_tree().create_timer(.5).timeout
	set_collision_layer_value(8, true)


func collect():
	queue_free()
