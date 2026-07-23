class_name GunRotationComponent
extends Node2D

@export_range(1, 90, 1)
var snap_interval : float = 15.0
var aim_component : AimComponent = null
var gun_sprite : GunSprite = null


func setup(_aim_component : AimComponent, _gun_sprite : GunSprite):
	aim_component = _aim_component
	gun_sprite = _gun_sprite


func tick() -> void:
	snap()


func snap():
	var direction : Vector2 = aim_component.get_aiming_direction()
	var is_facing_left : bool = direction.x < 0
	gun_sprite.flip_h = is_facing_left
	
	if is_facing_left:
		direction  *= -1
	
	var angle_radians : float = direction.angle()
	var angle_degrees : float = rad_to_deg(angle_radians)
	var snapped_angle : float = round(angle_degrees / snap_interval) * snap_interval
	get_parent().rotation_degrees = clamp(snapped_angle, -90, 90)
