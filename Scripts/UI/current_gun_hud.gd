extends Control

@onready var current_gun_texture : TextureRect = $Panel/CurrentGunTexture
@onready var current_gun_name : Label = $Panel/CurrentGunName
@onready var gun_ammo : Label = $Panel/GunAmmo
@onready var reloading_label : Label = $Panel/ReloadingLabel
@onready var reloading_progress_bar : ProgressBar = $Panel/ReloadingProgressBar


var weapon_component : WeaponComponent = null

var current_ammo : int = 0
var reserve_ammo : int = 0
var current_gun_instance : GunInstance = null
var current_reload_timer : CooldownComponent = null

var live_reload_bar : bool = false


func _ready() -> void:
	setup_reload_ui()
	hide()


func setup_reload_ui():
	reloading_label.hide()
	reloading_label.modulate.a = 0 # Hidden at default
	reloading_progress_bar.hide()
	reloading_progress_bar.modulate.a = 0



func _process(_delta: float) -> void:
	if live_reload_bar == true:
		reloading_progress_bar.value = current_reload_timer.current_time


func set_weapon_component(to : WeaponComponent):
	weapon_component = to

	weapon_component.weapon_system.current_ammo_changed.connect(_update_ammo)
	weapon_component.weapon_system.gun_switched.connect(_on_gun_switched)
	weapon_component.weapon_system.reload_started.connect(_on_reload_started)
	weapon_component.weapon_system.reload_stopped.connect(_on_reload_stopped)
	weapon_component.weapon_system.reserve_ammo_changed.connect(_update_reserve_ammo)
	current_gun_instance = weapon_component.weapon_system.current_gun_instance
	
	if current_gun_instance:
		_update_ammo(current_gun_instance.ammo_provider.get_current_ammo())
		_update_reserve_ammo(current_gun_instance.ammo_provider.get_current_reserve_ammo())
		update_visuals()
	# To do finish


func update_visuals():
	if current_gun_instance:
		show()
		update_gun_texture()
		update_gun_name()
		update_ammo_label()
	else:
		hide()


func update_gun_name():
	current_gun_name.text = current_gun_instance.gun_data.name


func update_ammo_label():
	gun_ammo.text = "%s/%s" % [current_ammo, reserve_ammo]


func update_gun_texture():
	current_gun_texture.texture = current_gun_instance.gun_data.texture


func _on_reload_started(reload_timer : CooldownComponent):
	show_reload_ui()
	current_reload_timer = reload_timer
	reloading_progress_bar.max_value = reload_timer.cooldown_time
	live_reload_bar = true


func show_reload_ui():
	var tween : Tween = create_tween()
	tween.set_parallel(true)
	reloading_label.show()
	reloading_progress_bar.show()
	tween.tween_property(reloading_label, "modulate:a", 1, .5)
	tween.tween_property(reloading_progress_bar, "modulate:a", 1, .5)
	await tween.finished
	tween.kill()


func hide_reload_ui():
	var tween : Tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(reloading_label, "modulate:a", 0, .25).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(reloading_progress_bar, "modulate:a", 0, .25).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
	await tween.finished
	tween.kill()
	reloading_label.hide()
	reloading_progress_bar.hide()
	reloading_label.text = "Reloading..."



func _on_reload_stopped():
	current_reload_timer = null
	live_reload_bar = false
	reloading_label.text = "Reloaded!"
	hide_reload_ui()


func _update_ammo(_current_ammo : int):
	current_ammo = _current_ammo
	## TODO: if ever add a gun with infinite ammo, below must be changed
	## assuming every gun has mgaazine
	update_ammo_label()

func _update_reserve_ammo(new_ammo : int):
	if new_ammo != reserve_ammo:
		reserve_ammo = current_gun_instance.ammo_provider.get_current_reserve_ammo()
	update_ammo_label()



func _on_gun_switched(to : GunInstance):
	current_gun_instance = to
	reserve_ammo = current_gun_instance.ammo_provider.get_current_reserve_ammo()
	_update_ammo(current_gun_instance.ammo_provider.get_current_ammo())
	update_visuals()
