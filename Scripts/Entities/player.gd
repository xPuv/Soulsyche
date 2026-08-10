extends CharacterBody2D


const PISTOL = preload("uid://rfubp0k5hbk5")
const THE_DAWG = preload("uid://c8ibmerqlcv3e")


@onready var player_sprite : Sprite2D = $MainSprite
@onready var weapon_component : WeaponComponent = $WeaponComponent
@onready var hurtbox_component : HurtboxComponent = $HurtboxComponent
@onready var main_sprite : Sprite2D = $MainSprite
@onready var interaction_system : InteractionSystem = $InteractionZone
@onready var collection_zone: Area2D = $CollectionZone



var player_context : PlayerContext = null
var player_items : PlayerItems = null
var input_collector : InputCollector = null
var statistic_component : StatisticComponent = null
var movement_component : MovementComponent = null
var aim_component : AimComponent = null
var dash_component : DashComponent = null
var services : PlayerServices = null
var team_component : TeamComponent = null
var dash_effects : Array[Effect] = [GhostEffect.new(self, .2), GhostEffect.new(self, 0.2), GhostEffect.new(self, 0.2)]
var health_component : HealthComponent = null
var collectable_system : CollectableSystem = null

var PLAYER_STATS : Dictionary = {
	"Health" : {"type" : "clamped", "base_value" : 6, "min_value" : 0, "max_value" : 6},
	"Speed" : {"type" : "clamped", "base_value" : 30, "min_value" : 10000, "max_value" : 50},
	"DashDistance" : {"type" : "clamped", "base_value" : 100, "min_value" : 0, "max_value" : 160}
}


# Called when the node enters the scene tree for the first time.
func _enter_tree() -> void:
	player_context = PlayerContext.new()
	input_collector = InputCollector.new()
	statistic_component = StatisticComponentFactory.create_statistic_component(self, PLAYER_STATS)
	services = PlayerServices.new(player_context, statistic_component, input_collector, self)
	aim_component = AimComponent.new(self, input_collector)
	team_component = TeamComponent.new(TeamComponent.Teams.PLAYER)
	health_component = HealthComponent.new(statistic_component.get_statistic_value("Health"), statistic_component.get_statistic_object("Health").max_value)


func _ready() -> void:
	#var other_gun_instance : GunInstance = GunInstance.new(THE_DAWG, MagazineAmmoProvider.new(THE_DAWG))
	weapon_component.setup(team_component)
	#weapon_component.add_gun(other_gun_instance)
	player_sprite.setup(aim_component)
	movement_component = MovementComponent.new()
	dash_component = DashComponent.new(services, movement_component, dash_effects)
	hurtbox_component.hitbox_entered.connect(_on_hurt)
	player_items = PlayerItems.new()
	collectable_system = CollectableSystem.new(self)
	collection_zone.body_entered.connect(_on_collect)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	input_collector.tick(global_position, get_global_mouse_position())
	player_sprite.tick()
	movement_component.smooth_move(statistic_component.get_statistic_value("Speed"), input_collector.move_direction, delta)
	dash_component.tick(delta)
	weapon_component.tick(delta, get_global_mouse_position())
	weapon_component.process_commands(create_weapon_commands())
	movement_component.calculate_final_velocity(delta)
	velocity = movement_component.get_velocity()
	move_and_slide()
	check_interactions()


func check_interactions():
	if input_collector.interact_pressed:
		var interactable = interaction_system.get_target()
		if interactable:
			interactable.interact(self)


func create_weapon_commands() -> WeaponCommands:
	return WeaponCommands.new(
		input_collector.shoot_pressed,
		input_collector.reload_pressed,
		input_collector.mouse_scroll_up,
		input_collector.mouse_scroll_down
	)


func _on_hurt(hitbox_component : HitboxComponent):
	health_component.increase_health(-hitbox_component.damage)


func use_key(key_name : StringName):
	player_items.use_key(key_name)


func has_key(key_name : StringName):
	return player_items.has_key(key_name)


func add_gun(what_gun : GunData):
	var gun_instance = GunInstance.new(what_gun, MagazineAmmoProvider.new(what_gun))
	weapon_component.add_gun(gun_instance)


func _on_collect(body : Collectable):
	collectable_system.collect(body)
