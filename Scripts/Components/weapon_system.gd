class_name WeaponSystem
extends RefCounted


signal gun_switched
signal shoot_bullet(gun_instance : GunInstance)


var services : PlayerServices = null
var input : InputCollector = null


var current_gun_instance : GunInstance = null
var guns : Array[GunInstance] = []
var reloading_gun_instances : Array[GunInstance] = []

#FSM for can shoot / cant shoot / reload
# Shoot + reload func
# Ammo counter
func _init(_services) -> void:
	services = _services
	input = services.input


func add_gun_instance(gun_instance : GunInstance):
	guns.append(gun_instance)
	if len(guns) == 1:
		current_gun_instance = gun_instance
	# Maybe weapon instance should be an interface? and then this happens through it instead
	gun_instance.reload_started.connect(_on_reload_start)
	gun_instance.reload_stopped.connect(_on_reload_end)


func remove_gun_instance(gun_instance : GunInstance):
	guns.erase(gun_instance)
	gun_instance.ammo_counter.reload_started.disconnect(_on_reload_start)
	gun_instance.ammo_counter.reload_stopped.disconnect(_on_reload_end)


func tick(delta : float):
	# Shoot the gun, if ammo shoot if no ammo dont 
	# If try to swithc gun while currently reloading, cancel reload and do that
	# TODO implement
	
	
	var switch_gun_pressed : bool = false
	
	if switch_gun_pressed:
		reloading_gun_instances[0].stop_reload()
		swap_current_gun_instance()
		
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


#TODO
func swap_current_gun_instance():
	pass
	gun_switched.emit()
	# Pause current gun cooldown fire rate timer with weapon isntance fucn


func _on_reload_start(gun_instance : GunInstance):
	reloading_gun_instances.append(gun_instance)


func _on_reload_end(gun_instance : GunInstance):
	reloading_gun_instances.erase(gun_instance)
