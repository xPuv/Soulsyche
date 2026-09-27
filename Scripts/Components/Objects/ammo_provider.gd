class_name AmmoProvider
extends RefCounted


var current_gun : GunData = null


signal current_ammo_changed(to : int)
signal reload_started
signal reload_stopped
signal reserve_ammo_changed(to : int)


func _init(gun_resource : GunData) -> void:
	current_gun = gun_resource



func tick(_delta : float):
	pass


func can_shoot() -> bool:
	return true


func can_reload() -> bool:
	return true


func start_reload():
	pass


func reload():
	pass


func use():
	pass


func get_current_ammo() -> int:
	return 1


func get_current_reserve_ammo() -> int:
	return 1
