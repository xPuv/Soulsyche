class_name WeaponComponent
extends Node2D



@onready var bullet_spawn_position  : Marker2D = $GunSprite/BulletSpawnPosition
@onready var gun_rotation : GunRotationComponent = $GunRotation
@onready var gun_sprite : GunSprite = $GunSprite


const PISTOL = preload("uid://rfubp0k5hbk5")
const BULLET = preload("uid://n02g4tkus4j1")


var weapon_system : WeaponSystem = null
var player_services : PlayerServices = null


func tick(delta):
	weapon_system.tick(delta)
	gun_rotation.tick()


func setup(services : PlayerServices, aim_component : AimComponent):
	player_services = services
	
	weapon_system = WeaponSystem.new(services)
	weapon_system.shoot_bullet.connect(_spawn_bullet)
	weapon_system.add_gun_instance(GunInstance.new(PISTOL))
	
	gun_sprite.setup(weapon_system)
	gun_rotation.setup(aim_component, gun_sprite)


func _spawn_bullet(gun_instance : GunInstance):
	var b : Bullet = BULLET.instantiate()
	b.setup(gun_instance.gun_data.max_bullet_collision, gun_instance.gun_data.bullet_speed, 
	player_services.input.mouse_direction, bullet_spawn_position.global_position)
	var bullet_layer : Node2D = get_tree().get_first_node_in_group("Bullets")
	if bullet_layer: 
		bullet_layer.add_child(b)
	else:
		add_child(b)
