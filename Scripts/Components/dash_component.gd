class_name DashComponent
extends RefCounted

const COOLDOWN_TIME : int = 4
const DASH_DECAY : int = 110
var services : PlayerServices = null
var cooldown_timer : CooldownComponent = null
var vfx : Array[Effect] = []
var effect_hanlder : EffectHandler = null
var movement_component : MovementComponent = null
#TODO put impusle logic to move component so only it writres into velo


func _init(_services : PlayerServices, _movement_component : MovementComponent, _vfx : Array[Effect] = []) -> void:
	services = _services
	movement_component = _movement_component
	cooldown_timer = CooldownComponent.new(COOLDOWN_TIME)
	vfx = _vfx
	effect_hanlder = EffectHandler.new(vfx)


func tick(delta):
	cooldown_timer.tick(delta)
	
	var input = services.input
	var can_dash : bool = cooldown_timer.ready
	
	if can_dash and input.dash_pressed == true:
		start_dash(input.move_direction)
		cooldown_timer.start_cooldown()


func start_dash(move_dir : Vector2):
	var direction : Vector2 = move_dir
	if direction.is_equal_approx(Vector2.ZERO):
		direction = Vector2.RIGHT
	
	var dash_distance = services.stats.get_statistic_value("DashDistance")
	var velocity : Vector2 = direction * dash_distance
	movement_component.add_impulse(DASH_DECAY, velocity)
	effect_hanlder.start_effects()
