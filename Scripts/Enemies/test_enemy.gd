extends CharacterBody2D


@onready var hurtbox_component : HurtboxComponent = $HurtboxComponent
@onready var behaviour_tree : BehaviourTree = $BehaviourTree
@onready var line_of_sight_component : LineOfSightComponent = $LineOfSightComponent
@onready var weapon_component : WeaponComponent = $WeaponComponent
@onready var sprite_2d : Sprite2D = $Sprite2D

const PISTOL = preload("uid://rfubp0k5hbk5")
const ENEMY_BASE_BULLET = preload("uid://b121d7gn35b5r")


var movement_component : MovementComponent = null
var statistic_component : StatisticComponent = null
var team_component : TeamComponent = null
var health_component : HealthComponent = null
var waypoint_component : WaypointComponent = null
var knockback_component : KnockbackComponent = null
var stun_component : StunComponent = null
var hit_flash_component : HitFlashComponent = null 
var status_effect_component : StatusEffectComponent = null


var ENEMY_STATS : Dictionary = {
	"Health" : {"type" : "clamped", "base_value" : 30000000, "min_value" : 0, "max_value" : 300000000},
	"Speed" : {"type" : "clamped", "base_value" : 30, "min_value" : 0, "max_value" : 50},
	"Damage" : {"type" : "clamped", "base_value" : 1, "min_value" : 0, "max_value" : 5}
}


func _enter_tree() -> void:
	statistic_component = StatisticComponentFactory.create_statistic_component(self, ENEMY_STATS)
	team_component = TeamComponent.new(TeamComponent.Teams.ENEMY)
	health_component = HealthComponent.new(statistic_component.get_statistic_object("Health").base_value, statistic_component.get_statistic_object("Health").max_value)
	waypoint_component = WaypointComponent.new(80)
	health_component.died.connect(_on_die)

 
func _ready() -> void:
	weapon_component.setup(team_component, ENEMY_BASE_BULLET)
	var gun_instance : GunInstance = GunInstance.new(PISTOL, AmmoProvider.new(PISTOL))
	weapon_component.add_gun(gun_instance)
	hit_flash_component = HitFlashComponent.new(Color.WHITE, .3)
	movement_component = MovementComponent.new()
	knockback_component = KnockbackComponent.new(movement_component)
	stun_component = StunComponent.new()
	setup_behaviour_tree()
	line_of_sight_component.setup(Utils.get_player())
	hurtbox_component.hitbox_entered.connect(_on_take_damage)
	status_effect_component = StatusEffectComponent.new(self)


func _physics_process(delta: float) -> void:
	stun_component.tick(delta)
	# If there is no movement from the behaviour tree, dont move. Behaviour tree will override if there is
	
	if stun_component.get_stun() == false:
		movement_component.smooth_move(statistic_component.get_statistic_value("Speed"), Vector2.ZERO, delta)
		behaviour_tree.tick(delta)
	else:
		movement_component.move(0, Vector2.ZERO) # If stunned, dont mov
	
	weapon_component.tick(delta, Utils.get_player().global_position)
	movement_component.calculate_final_velocity(delta)
	velocity = movement_component.get_velocity()
	status_effect_component.tick(delta)
	move_and_slide()


func _on_take_damage(hitbox : HitboxComponent):
	take_damage(hitbox.damage)
	knockback_component.take_knockback(global_position, hitbox.global_position, hitbox.knockback_strength)


func take_damage(dmg : int):
	health_component.increase_health(-dmg)
	stun_component.start_stun(.3)
	hit_flash_component.hit_flash(sprite_2d)
	GameEvents.enemy_hit.emit({"enemy" : self})


func setup_behaviour_tree():
	behaviour_tree.blackboard.set_data(line_of_sight_component, "LineOfSightComponent")
	behaviour_tree.blackboard.set_data(waypoint_component, "WaypointComponent")
	behaviour_tree.blackboard.set_data(self, "Actor")
	behaviour_tree.blackboard.set_data(statistic_component, "StatisticComponent")
	behaviour_tree.blackboard.set_data(movement_component, "MovementComponent")
	behaviour_tree.blackboard.set_data(weapon_component, "WeaponComponent")


func get_status_effect_component() -> StatusEffectComponent:
	return status_effect_component


func get_statistic_component() -> StatisticComponent:
	return statistic_component


func get_health_component() -> HealthComponent:
	return health_component


func _on_die():
	queue_free()
