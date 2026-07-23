class_name DashComponent
extends RefCounted

const COOLDOWN_TIME : int = 2
const DASH_DECAY : int = 110
var services : PlayerServices
var cooldown : float = 0.0

var dash_impulse : VelocityImpulse = null


func _init(_services : PlayerServices) -> void:
	services = _services
	cooldown = 0.0


func tick(delta):
	if cooldown != 0.0:
		cooldown = maxf(0.0, cooldown - delta)
	
	var input = services.input
	if !dash_impulse and input.dash_pressed == true and cooldown == 0.0:
		start_dash(input.move_direction)
		cooldown = COOLDOWN_TIME
	if !dash_impulse:
		return
	elif dash_impulse.impulse == Vector2.ZERO:
		dash_impulse = null
	elif dash_impulse.impulse != Vector2.ZERO:
		dash_impulse.add_impulse(delta)


func start_dash(move_dir : Vector2):
	dash_impulse = VelocityImpulse.new(services.player_node, DASH_DECAY)
	var dash_distance = services.stats.get_statistic_value("DashDistance")
	dash_impulse.impulse = move_dir * dash_distance
