class_name DirectionFacingBehaviour
extends RefCounted


var aim_component : AimComponent = null
var sprite_2d : Sprite2D = null



func _init(_aim_component : AimComponent, _sprite : Sprite2D) -> void:
	aim_component = _aim_component
	sprite_2d = _sprite


func tick() -> void:
	var mouse_dir = aim_component.get_aiming_direction()
	
	var cross_product = (Vector2.RIGHT).cross(mouse_dir)
	
	if cross_product > 0:
		sprite_2d.flip_h = true
	elif cross_product < 0:
		sprite_2d.flip_h = false
