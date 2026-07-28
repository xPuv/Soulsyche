class_name GunData
extends Resource


@export var name : String = ""
@export var sprite : Texture = null
@export var tooltip_description : String = ""

@export var ammo_per_magazine : int = 20
@export var base_ammo_in_reserve : int = 80

@export var bullets_fired : int = 1
@export var bullet_speed : int = -1 # Use default = -1 
@export var fire_rate : float = 0.8
@export var reload_time : float = 3.5
@export var bullet_arc : float = 90

@export var bullet_data : BulletData
@export var gun_hold_data : GunHoldData
