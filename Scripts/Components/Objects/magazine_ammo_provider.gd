class_name MagazineAmmoProvider
extends AmmoProvider


var ammo_counter : AmmoCounter = null

# TODO add reserve ammo changed signal

func _init(gun_resource : GunData) -> void:
	current_gun = gun_resource
	ammo_counter = AmmoCounter.new(current_gun)
	ammo_counter.current_ammo_changed.connect(_on_current_ammo_changed)
	ammo_counter.reload_started.connect(_on_reload_started)
	ammo_counter.reload_stopped.connect(_on_reload_stopped)
	ammo_counter.reserve_ammo_changed.connect(_on_reserve_changed)


func tick(delta : float):
	if ammo_counter.reloading == true:
		ammo_counter.tick(delta)


func can_shoot():
	return ammo_counter.can_shoot()


func can_reload():
	return ammo_counter.can_reload()


func start_reload():
	ammo_counter.start_reload()


func reload():
	ammo_counter.reload()


func get_current_ammo():
	return ammo_counter.current_ammo


func use():
	ammo_counter.increase_current_ammo(-1)
	current_ammo_changed.emit(ammo_counter.current_ammo)


func stop_reload():
	ammo_counter.stop_reload()


func add_reserve_ammo(how_much : int):
	ammo_counter.increase_reserve_ammo(min(ammo_counter.reserve_ammo + how_much, ammo_counter.gun.base_ammo_in_reserve))


func add_to_current_ammo(how_much : int):
	ammo_counter.increase_current_ammo(how_much)


func _on_reload_started():
	reload_started.emit()


func _on_reload_stopped():
	reload_stopped.emit()


func _on_current_ammo_changed(to : int):
	current_ammo_changed.emit(to)


func get_current_reserve_ammo():
	return ammo_counter.reserve_ammo


func _on_reserve_changed(to : int):
	reserve_ammo_changed.emit(to)
