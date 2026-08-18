extends Node


@onready var player : CharacterBody2D = %Player
@onready var ui : CanvasLayer = %UI


func _ready() -> void:
	var current_gun_hud : Control = ui.find_child("CurrentGunHUD")
	if current_gun_hud:
		current_gun_hud.set_weapon_component(player.weapon_component)
	var player_items_hud : Control = ui.find_child("PlayerItemsHUD")
	if player_items_hud:
		player_items_hud.setup(player)
	var soul_hud : Control = ui.find_child("SoulHUD")
	if soul_hud:
		soul_hud.setup(player)
	var health_hud : Control = ui.find_child("HealthHUD")
	if health_hud:
		health_hud.setup(player)
