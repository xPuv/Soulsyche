extends CharacterBody2D


@onready var hurtbox_component : HurtboxComponent = $HurtboxComponent
@onready var behaviour_tree : BehaviourTree = $BehaviourTree
@onready var line_of_sight_area_2d : Area2D = $LineOfSightArea2D


var movement_component : MovementComponent = null
var stats_component : StatisticComponent = null
var team_component : TeamComponent = null
var health_component : HealthComponent = null
var waypoint_component : WaypointComponent = null


var ENEMY_STATS : Dictionary = {
	"Health" : {"type" : "clamped", "base_value" : 3, "min_value" : 0, "max_value" : 100},
	"Speed" : {"type" : "clamped", "base_value" : 30, "min_value" : 0, "max_value" : 50},
	"Damage" : {"type" : "clamped", "base_value" : 1, "min_value" : 0, "max_value" : 5}
}


func _enter_tree() -> void:
	stats_component = StatisticComponentFactory.create_statistic_component(self, ENEMY_STATS)
	team_component = TeamComponent.new(TeamComponent.Teams.ENEMY)
	health_component = HealthComponent.new(stats_component.get_statistic_object("Health").base_value, stats_component.get_statistic_object("Health").max_value)
	waypoint_component = WaypointComponent.new(80)
	health_component.died.connect(queue_free)

 
func _ready() -> void:
	movement_component = MovementComponent.new()
	behaviour_tree.blackboard.set_data(line_of_sight_area_2d, "LineOfSightArea2D")
	behaviour_tree.blackboard.set_data(waypoint_component, "WaypointComponent")
	behaviour_tree.blackboard.set_data(self, "Actor")
	behaviour_tree.blackboard.set_data(stats_component, "StatisticComponent")
	behaviour_tree.blackboard.set_data(movement_component, "MovementComponent")
	hurtbox_component.hitbox_entered.connect(_on_take_damage)


func _physics_process(delta: float) -> void:
	# If there is no movement from the behaviour tree, dont move. Behaviour tree will override if there is
	movement_component.smooth_move(stats_component.get_statistic_value("Speed"), Vector2.ZERO, delta)
	behaviour_tree.tick(delta)
	movement_component.calculate_final_velocity(delta)
	velocity = movement_component.get_velocity()
	move_and_slide()

func _on_take_damage(hitbox : HitboxComponent):
	health_component.increase_health(-hitbox.damage)
