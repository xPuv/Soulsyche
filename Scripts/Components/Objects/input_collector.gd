class_name InputCollector
extends RefCounted


var move_direction : Vector2 = Vector2.ZERO
var mouse_direction : Vector2 = Vector2.ZERO
var mouse_position : Vector2 = Vector2.ZERO
var dash_pressed : bool = false
var shoot_pressed : bool = false
var reload_pressed : bool = false
var mouse_scroll_up : bool = false
var mouse_scroll_down : bool = false
var interact_pressed : bool = false
var use_ability : bool = false


func reset_input_flags():
	dash_pressed = false
	shoot_pressed = false
	reload_pressed = false
	mouse_scroll_down = false
	mouse_scroll_up = false
	interact_pressed = false
	use_ability = false


func calculate_mouse_direction(player_position : Vector2):
	return (mouse_position - player_position).normalized()


func tick(player_position : Vector2, mouse_pos : Vector2):
	reset_input_flags()
	check_input_flags()
	move_direction = calculate_move_direction()
	mouse_position = mouse_pos
	mouse_direction = calculate_mouse_direction(player_position)
	

func check_input_flags():
	if Input.is_action_just_pressed("dash"):
		dash_pressed = true
	
	if Input.is_action_just_pressed("shoot"):
		shoot_pressed = true
	
	if Input.is_action_just_pressed("reload"):
		reload_pressed = true
	
	if Input.is_action_just_pressed("scroll_up"):
		mouse_scroll_up = true
	
	if Input.is_action_just_pressed("scroll_down"):
		mouse_scroll_down = true
	
	if Input.is_action_just_pressed("interact"):
		interact_pressed = true
	
	if Input.is_action_just_pressed("use_ability"):
		use_ability = true


func calculate_move_direction():
	var dir := Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	).normalized()

	return dir
