extends Node


@onready var player : CharacterBody2D = %Player
@onready var ui : CanvasLayer = %UI
@onready var game_win : Node = $GameWin
@onready var room_manager : Node2D = $RoomManager


func _ready() -> void:
	GameEvents.player_dead.connect(_on_player_die)
	GameEvents.game_win.connect(_on_game_win)
	game_win.setup(room_manager)
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
	


func _on_player_die():
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/Game/you_died.tscn")


func _on_game_win():
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/Game/you_win.tscn")
