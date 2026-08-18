class_name GunInstance
extends RefCounted

var gun_data : GunData = null
var ammo_provider : AmmoProvider = null
var fire_rate_cooldown : CooldownComponent = null


signal reload_started(instance : GunInstance)
signal reload_stopped(instance : GunInstance)
signal current_ammo_changed(to : int)


func _init(_gun_data : GunData, _ammo_provider : AmmoProvider) -> void:
	gun_data = _gun_data
	ammo_provider = _ammo_provider
	fire_rate_cooldown = CooldownComponent.new(gun_data.fire_rate)
	ammo_provider.reload_started.connect(func(): reload_started.emit(self))
	ammo_provider.reload_stopped.connect(func(): reload_stopped.emit(self))
	ammo_provider.current_ammo_changed.connect(func(to): current_ammo_changed.emit(to))


func pause_cooldown():
	fire_rate_cooldown.paused = true


func cooldown_is_paused():
	return fire_rate_cooldown.paused


func unpause_cooldown():
	fire_rate_cooldown.paused = false


func shoot():
	fire_rate_cooldown.start_cooldown()
	ammo_provider.use()


func can_shoot():
	return fire_cooldown_ready() and ammo_provider.can_shoot()


func fire_cooldown_ready():
	return fire_rate_cooldown.ready


func is_reloading() -> bool:
	return ammo_provider.can_reload()


func tick(delta : float):
	ammo_provider.tick(delta)
	
	if fire_rate_cooldown.ready == false:
		fire_rate_cooldown.tick(delta)


func can_reload():
	return ammo_provider.can_reload()  


func reload():
	ammo_provider.reload()
	

func start_reload():
	ammo_provider.start_reload()


func stop_reload():
	ammo_provider.stop_reload()
