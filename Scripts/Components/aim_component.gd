class_name AimComponent
extends RefCounted


var player_input_component : InputCollector = null
var origin : Node2D = null



func _init(_origin : Node2D, input : InputCollector) -> void:
	player_input_component = input
	origin = _origin


func calculate_point_aiming_at():
	return player_input_component.mouse_position


func get_aiming_direction():
	return (player_input_component.mouse_position - origin.global_position).normalized()
	
