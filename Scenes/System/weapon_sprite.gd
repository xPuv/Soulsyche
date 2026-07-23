class_name GunSprite
extends Sprite2D




func setup(_weapon_system : WeaponSystem):
	_weapon_system.gun_switched.connect(_on_gun_switched.bind(_weapon_system))
	update_visuals(_weapon_system.current_gun_instance)



func _on_gun_switched(_weapon_system):
	update_visuals(_weapon_system)


func update_visuals(gun_instance : GunInstance):
	if !gun_instance:
		return
	var gun_res = gun_instance.gun_data
	texture = gun_res.sprite
