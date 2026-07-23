class_name AimComponent
extends RefCounted


var player_input_component : InputCollector = null


func _init(input : InputCollector) -> void:
	player_input_component = input



func get_aiming_direction():
	return player_input_component.mouse_direction
