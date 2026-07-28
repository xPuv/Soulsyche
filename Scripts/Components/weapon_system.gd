class_name WeaponSystem
extends RefCounted


signal gun_switched
signal ammo_changed
signal reload_started(cooldown_component : CooldownComponent)
signal reload_stopped
signal shoot_bullet(gun_instance : GunInstance)



var input : InputCollector = null


var current_gun_instance : GunInstance = null
var guns : Array[GunInstance] = []
var reloading_gun_instances : Array[GunInstance] = []

#FSM for can shoot / cant shoot / reload
# Shoot + reload func
# Ammo counter
func _init(_input : InputCollector) -> void:
	input = _input


func add_gun_instance(gun_instance : GunInstance):
	if len(guns) == 0:
		current_gun_instance = gun_instance
	gun_instance.ammo_counter.current_ammo_changed.connect(_on_ammo_changed)
	guns.append(gun_instance)
	gun_instance.reload_started.connect(_on_reload_start)
	gun_instance.reload_stopped.connect(_on_reload_end)


func remove_gun_instance(gun_instance : GunInstance):
	guns.erase(gun_instance)
	gun_instance.ammo_counter.reload_started.disconnect(_on_reload_start)
	gun_instance.ammo_counter.reload_stopped.disconnect(_on_reload_end)


func tick(delta : float):
	var switch_gun_pressed : bool = input.mouse_scroll_up or input.mouse_scroll_down
	
	if switch_gun_pressed and len(guns) > 1:
		if current_gun_instance.is_reloading():
			reloading_gun_instances[0].stop_reload()
		var index_to_change_by = -1 
		if input.mouse_scroll_up:
			index_to_change_by = 1
		swap_current_gun_instance(index_to_change_by)
		
		return # no gun swapping 
	var shoot_pressed = input.shoot_pressed
	var reload_pressed = input.reload_pressed
	
	for counter in reloading_gun_instances:
		counter.tick(delta)
	
	
	current_gun_instance.tick(delta)
	if !shoot_pressed and  !reload_pressed:
		return
	
	var gun_instance = current_gun_instance
	if shoot_pressed and gun_instance.can_shoot():
		shoot()
	elif shoot_pressed and gun_instance.can_reload() and gun_instance.fire_cooldown_ready():
		gun_instance.start_reload()
	elif reload_pressed and gun_instance.can_reload():
		gun_instance.start_reload()

	

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
	reloading_gun_instances.append(gun_instance)
	reload_started.emit(gun_instance.ammo_counter.reload_cooldown_component)


func _on_reload_end(gun_instance : GunInstance):
	reloading_gun_instances.erase(gun_instance)
	reload_stopped.emit()


func _on_ammo_changed(to : int):
	ammo_changed.emit(to)
