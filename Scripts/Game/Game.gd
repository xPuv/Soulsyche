extends Node


@onready var player : CharacterBody2D = %Player
@onready var ui : CanvasLayer = %UI


func _ready() -> void:
	var current_gun_hud : Control = ui.find_child("CurrentGunHUD")
	current_gun_hud.set_weapon_component(player.weapon_component)
