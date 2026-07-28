class_name GunInstance
extends RefCounted

var gun_data : GunData = null
var ammo_counter : AmmoCounter = null
var fire_rate_cooldown : CooldownComponent = null

signal reload_started(instance : GunInstance)
signal reload_stopped(instance : GunInstance)


func _init(_gun_data : GunData) -> void:
	gun_data = _gun_data
	ammo_counter = AmmoCounter.new(_gun_data)
	ammo_counter.reload_started.connect(_on_reload_started)
	ammo_counter.reload_stopped.connect(_on_reload_stopped)
	fire_rate_cooldown = CooldownComponent.new(gun_data.fire_rate)


func pause_cooldown():
	fire_rate_cooldown.paused = true


func cooldown_is_paused():
	return fire_rate_cooldown.paused


func unpause_cooldown():
	fire_rate_cooldown.paused = false


func shoot():
	fire_rate_cooldown.start_cooldown()
	ammo_counter.increase_current_ammo(-1)


func can_shoot():
	return fire_cooldown_ready() and ammo_counter.can_shoot()


func fire_cooldown_ready():
	return fire_rate_cooldown.ready


func is_reloading() -> bool:
	return ammo_counter.reloading


func tick(delta : float):
	if ammo_counter.reloading:
		ammo_counter.tick(delta)
	
	if fire_rate_cooldown.ready == false:
		fire_rate_cooldown.tick(delta)


func can_reload():
	return ammo_counter.can_reload()  


func reload():
	ammo_counter.start_reload()


func _on_reload_started():
	reload_started.emit(self)


func _on_reload_stopped():
	reload_stopped.emit(self)


func start_reload():
	ammo_counter.start_reload()


func stop_reload():
	ammo_counter.stop_reload()
