extends CharacterBody2D


@onready var weapon_component : Node2D = $WeaponComponent
@onready var player_sprite : Sprite2D = $MainSprite



var player_context : PlayerContext = null
var input_collector : InputCollector = null
var statistic_component : StatisticComponent = null
var movement_component : MovementComponent = null
var aim_component : AimComponent = null
var dash_component : DashComponent = null
var services : PlayerServices = null
var team_component : TeamComponent = null
var dash_effects : Array[Effect] = [GhostEffect.new(self, .2), GhostEffect.new(self, 0.2), GhostEffect.new(self, 0.2)]



var PLAYER_STATS : Dictionary = {
	"Health" : {"type" : "clamped", "base_value" : 6, "min_value" : 0, "max_value" : 6},
	"Speed" : {"type" : "clamped", "base_value" : 30, "min_value" : 10000, "max_value" : 50},
	"DashDistance" : {"type" : "clamped", "base_value" : 80, "min_value" : 0, "max_value" : 160}
}


# Called when the node enters the scene tree for the first time.
func _enter_tree() -> void:
	player_context = PlayerContext.new()
	input_collector = InputCollector.new()
	statistic_component = StatisticComponentFactory.create_statistic_component(self, PLAYER_STATS)
	services = PlayerServices.new(player_context, statistic_component, input_collector, self)
	aim_component = AimComponent.new(self, input_collector)
	team_component = TeamComponent.new(TeamComponent.Teams.PLAYER)


func _ready() -> void:
	weapon_component.setup(services, team_component)
	player_sprite.setup(aim_component)
	movement_component = MovementComponent.new()
	dash_component = DashComponent.new(services, movement_component, dash_effects)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	input_collector.tick(global_position, get_global_mouse_position())
	player_sprite.tick()
	movement_component.smooth_move(statistic_component.get_statistic_value("Speed"), input_collector.move_direction, delta)
	dash_component.tick(delta)
	weapon_component.tick(delta)
	movement_component.calculate_final_velocity(delta)
	velocity = movement_component.get_velocity()
	move_and_slide()
