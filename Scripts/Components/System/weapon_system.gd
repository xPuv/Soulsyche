class_name WeaponSystem
extends RefCounted


signal gun_switched
signal current_ammo_changed(to : int)
signal reserve_ammo_changed(to : int)
signal reload_started(cooldown_component : CooldownComponent)
signal reload_stopped
signal shoot_bullet(gun_instance : GunInstance)


var current_gun_instance : GunInstance = null

var guns : Array[GunInstance] = []


func add_gun_instance(gun_instance : GunInstance):
	if len(guns) == 0:
		current_gun_instance = gun_instance
		gun_switched.emit(current_gun_instance)
	guns.append(gun_instance)
	gun_instance.reload_started.connect(_on_reload_start)
	gun_instance.reload_stopped.connect(_on_reload_end)
	gun_instance.current_ammo_changed.connect(_on_current_ammo_changed)
	gun_instance.reserve_ammo_changed.connect(_on_reserve_ammo_changed)


func remove_gun_instance(gun_instance : GunInstance):
	guns.erase(gun_instance)



func tick(delta : float):
	if not current_gun_instance:
		return
	current_gun_instance.tick(delta)


func process_commands(weapon_commands : WeaponCommands):
	if weapon_commands.switch_next_gun or weapon_commands.switch_previous_gun:
		try_switch_guns(weapon_commands)
		return # no double pump
	
	if weapon_commands.shoot_intent:
		try_shoot()
	elif weapon_commands.reload_intent:
		try_reload()



func try_switch_guns(weapon_commands : WeaponCommands):
	var switch_gun_pressed : bool = weapon_commands.switch_next_gun or weapon_commands.switch_previous_gun
	
	if switch_gun_pressed and len(guns) > 1:
		if current_gun_instance.is_reloading():
			current_gun_instance.stop_reload()
		
		var index_to_change_by : int = -1 
		if weapon_commands.switch_next_gun:
			index_to_change_by = 1
		swap_current_gun_instance(index_to_change_by)


func try_shoot():
	if not current_gun_instance:
		return
	if current_gun_instance.can_shoot():
		shoot()
	elif current_gun_instance.can_reload() and current_gun_instance.fire_cooldown_ready():
		current_gun_instance.start_reload()


func try_reload():
	if not current_gun_instance:
		return
	if current_gun_instance.can_reload():
		current_gun_instance.start_reload()


func shoot():
	shoot_bullet.emit(current_gun_instance)
	current_gun_instance.shoot()


func swap_current_gun_instance(index_to_change_by : int):
	current_gun_instance.pause_cooldown()
	var current_gun_index = guns.find(current_gun_instance)
	var final_index = current_gun_index + index_to_change_by
	if final_index == len(guns):
		final_index = 0
	elif final_index < 0:
		final_index = len(guns) - 1
	current_gun_instance = guns[final_index]
	if current_gun_instance.cooldown_is_paused():
		current_gun_instance.unpause_cooldown()
	
	gun_switched.emit(current_gun_instance)
	# Pause current gun cooldown fire rate timer with weapon isntance fucn


func _on_reload_start(gun_instance : GunInstance):
	# Can assume it has an ammo counter
	reload_started.emit(gun_instance.ammo_provider.ammo_counter.reload_cooldown_component)


func _on_reload_end(_gun_instance : GunInstance):
	reload_stopped.emit()


func _on_current_ammo_changed(to : int):
	current_ammo_changed.emit(to)


func _on_reserve_ammo_changed(to : int):
	reserve_ammo_changed.emit(to)


func can_shoot() -> bool:
	if !current_gun_instance:
		return false
	return current_gun_instance.can_shoot()
