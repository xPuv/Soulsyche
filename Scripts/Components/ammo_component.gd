class_name AmmoCounter
extends RefCounted


var gun : GunData = null
var reload_cooldown_component : CooldownComponent = null
var current_ammo : int = 0
var magazine_ammo : int = 0
var reserve_ammo : int = 0

var reloading : bool = false
var reload_time : float = 0.0


signal current_ammo_changed(to : int)
signal reload_started()
signal reload_stopped()


func _init(gun_res : GunData) -> void:
	gun = gun_res
	setup()
	reload_cooldown_component = CooldownComponent.new(reload_time)
	reload_cooldown_component.cooldown_over.connect(_on_cooldown_over)


func setup():
	reserve_ammo = gun.base_ammo_in_reserve
	magazine_ammo = gun.ammo_per_magazine
	current_ammo = gun.ammo_per_magazine
	reload_time = gun.reload_time


func _on_cooldown_over():
	stop_reload()
	reload()


func reload():
	if (magazine_ammo - current_ammo) > reserve_ammo:
		increase_current_ammo(reserve_ammo)
		reserve_ammo = 0
	else:
		var ammo_to_add : int = (magazine_ammo - current_ammo)
		increase_current_ammo(ammo_to_add)
		reserve_ammo -= ammo_to_add
	current_ammo_changed.emit(current_ammo)


func start_reload():
	if reloading:
		return
	if reserve_ammo == 0: # No ammo
		return
		
	reloading = true
	reload_started.emit()


func tick(delta):
	if reloading == false:
		push_error("Trying to reload a gun thats already relaoaded")
	
	reload_cooldown_component.tick(delta)


func increase_current_ammo(by : int):
	current_ammo += by
	current_ammo = clamp(current_ammo, 0, magazine_ammo)
	current_ammo_changed.emit(current_ammo)


func can_shoot():
	return reloading == false and current_ammo > 0


func can_reload():
	return reserve_ammo > 0 and reloading == false and current_ammo != magazine_ammo


func stop_reload():
	reloading = false
	reload_stopped.emit()
