class_name GunSprite
extends Sprite2D




func setup(_weapon_system : WeaponSystem):
	_weapon_system.gun_switched.connect(_on_gun_switched)
	if _weapon_system.current_gun_instance:
		update_visuals(_weapon_system.current_gun_instance)


func _on_gun_switched(gun_instance : GunInstance):
	update_visuals(gun_instance)


func update_visuals(gun_instance : GunInstance):
	if !gun_instance:
		return
	var gun_res = gun_instance.gun_data
	texture = gun_res.texture
