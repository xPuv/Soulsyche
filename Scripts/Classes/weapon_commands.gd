class_name WeaponCommands
extends RefCounted


var switch_next_gun : bool = false
var switch_previous_gun : bool = false
var shoot_intent : bool = false
var reload_intent : bool = false


func _init(
	_shoot_intent : bool = false, 
_reload_intent : bool = false, 
_switch_next_gun : bool = false,
_switch_previous_gun : bool = false
) -> void:
	shoot_intent = _shoot_intent
	reload_intent = _reload_intent
	switch_next_gun = _switch_next_gun
	switch_previous_gun = _switch_previous_gun
