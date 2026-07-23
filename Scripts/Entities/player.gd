extends CharacterBody2D


@onready var weapon_component : Node2D = $WeaponComponent
@onready var player_sprite : Sprite2D = $Sprite2D


var player_context : PlayerContext = null
var input_collector : InputCollector = null
var statistic_component : StatisticComponent = null
var movement_component : SmoothMovementComponent = null
var dash_component : DashComponent = null
var services : PlayerServices = null
var aim_component : AimComponent = null
var PLAYER_STATS : Dictionary = {
	"Health" : {"type" : "clamped", "base_value" : 3, "min_value" : 0, "max_value" : 100},
	"Speed" : {"type" : "clamped", "base_value" : 30, "min_value" : 0, "max_value" : 50},
	"DashDistance" : {"type" : "clamped", "base_value" : 40, "min_value" : 0, "max_value" : 160}
}


# Called when the node enters the scene tree for the first time.
func _enter_tree() -> void:
	player_context = PlayerContext.new()
	input_collector = InputCollector.new()
	statistic_component = StatisticComponentFactory.create_statistic_component(self, PLAYER_STATS)
	services = PlayerServices.new(player_context, statistic_component, input_collector, self)
	dash_component = DashComponent.new(services)
	aim_component = AimComponent.new(input_collector)


func _ready() -> void:
	weapon_component.setup(services, aim_component)
	player_sprite.setup(aim_component)
	movement_component = SmoothMovementComponent.new()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	player_sprite.tick()
	input_collector.tick(global_position, get_global_mouse_position())
	dash_component.tick(delta)
	weapon_component.tick(delta)
	movement_component.tick(input_collector.move_direction, self, statistic_component.get_statistic_value("Speed"), delta)
	move_and_slide()
