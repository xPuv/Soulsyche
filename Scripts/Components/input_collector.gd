class_name InputCollector
extends RefCounted


var move_direction : Vector2 = Vector2.ZERO
var mouse_direction : Vector2 = Vector2.ZERO
var dash_pressed : bool = false
var shoot_pressed : bool = false
var reload_pressed : bool = false


func reset_input_flags():
	dash_pressed = false
	shoot_pressed = false
	reload_pressed = false


func calculate_mouse_direction(player_position : Vector2, mouse_position : Vector2):
	return (mouse_position - player_position).normalized()


func tick(player_position : Vector2, mouse_position : Vector2):
	reset_input_flags()
	check_input_flags()
	move_direction = calculate_move_direction()
	mouse_direction = calculate_mouse_direction(player_position, mouse_position)


func check_input_flags():
	if Input.is_action_just_pressed("dash"):
		dash_pressed = true
	
	if Input.is_action_just_pressed("shoot"):
		shoot_pressed = true
	
	if Input.is_action_just_pressed("reload"):
		reload_pressed = true
	

func calculate_move_direction():
	return Vector2(
	Input.get_axis("move_left", "move_right"),
	Input.get_axis("move_up", "move_down")
	).normalized()
