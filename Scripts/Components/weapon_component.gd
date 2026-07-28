class_name WeaponComponent
extends Node2D



@onready var gun_rotation_component : GunRotationComponent = $GunRotationComponent
@onready var gun_sprite: GunSprite = $GunRotationComponent/WeaponPivot/GunSprite
@onready var muzzle_marker: Marker2D = $GunRotationComponent/WeaponPivot/GunSprite/MuzzleMarker



const PISTOL = preload("uid://rfubp0k5hbk5")
const BULLET = preload("uid://n02g4tkus4j1")
const THE_DAWG = preload("uid://c8ibmerqlcv3e")


var weapon_system : WeaponSystem = null
var player_services : PlayerServices = null
var team_component : TeamComponent = null


func tick(delta):
	weapon_system.tick(delta)
	gun_rotation_component.tick()


func setup(services : PlayerServices, _team_component : TeamComponent):
	player_services = services
	team_component = _team_component
	
	weapon_system = WeaponSystem.new(services.input)
	weapon_system.shoot_bullet.connect(shoot_gun)
	weapon_system.add_gun_instance(GunInstance.new(PISTOL))
	weapon_system.add_gun_instance(GunInstance.new(THE_DAWG))
	gun_sprite.setup(weapon_system)
	gun_rotation_component.setup(gun_sprite, weapon_system)


func shoot_gun(gun_instance : GunInstance):
	var bullet_layer = Utils.get_bullets_layer()
	
	if !bullet_layer:
		return
	if gun_instance.gun_data.bullets_fired == 1:
		var bullet = _create_bullet(gun_instance)
		bullet_layer.add_child(bullet)
	else:
		for num in gun_instance.gun_data.bullets_fired:
			var bullet_rotation = _get_bullet_rotation(gun_instance, num)
			var bullet = _create_bullet(gun_instance, bullet_rotation)
			bullet_layer.add_child(bullet)


func _create_bullet(gun_instance : GunInstance, angle_offset : float = 0.0) -> Bullet:
	var b : Bullet = BULLET.instantiate()
	var base_direction : Vector2 = player_services.input.mouse_direction
	var final_direction : Vector2 = base_direction.rotated(angle_offset)
	b.setup(
		gun_instance.gun_data.bullet_data,  
		final_direction, 
		muzzle_marker.global_position,
		team_component.get_team())
	return b


func _get_bullet_rotation(gun_instance : GunInstance, index : int):
	var gun_arc : float = deg_to_rad(gun_instance.gun_data.bullet_arc)
	var increment : float = gun_arc / (gun_instance.gun_data.bullets_fired - 1)
	return global_rotation + increment * index - gun_arc / 2
