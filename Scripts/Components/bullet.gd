class_name Bullet
extends CharacterBody2D


@onready var visible_on_screen_notifier_2d : VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var sprite_2d : Sprite2D = $Sprite2D
@onready var hitbox_component : HitboxComponent = $HitboxComponent

const PLAYER_HITBOX_LAYER : int = 3
const PLAYER_HURTBOX_LAYER : int = 2
const ENEMY_HURTBOX_LAYER : int = 4
const ENEMY_HITBOX_LAYER : int = 5
enum Team {
	ENEMY,
	PLAYER,
	NEUTRAL
}

var direction : Vector2 = Vector2.ZERO
var speed : float = 220
var max_collision_count : int = -1
var collision_count : int = 0
var life_time_timer : CooldownComponent = null
var movement_component : MovementComponent = null
var current_team : TeamComponent.Teams = TeamComponent.Teams.NEUTRAL
var bullet_data : BulletData = null


func setup(_bullet_data : BulletData, dir : Vector2, global_pos : Vector2,
team : TeamComponent.Teams):
	movement_component = MovementComponent.new()
	direction = dir
	global_position = global_pos
	global_rotation = direction.angle()
	bullet_data = _bullet_data
	current_team = team
	


func _ready() -> void:
	if bullet_data:
		setup_with_bullet_data()
		life_time_timer.start_cooldown()
		hitbox_component.knockback_strength = bullet_data.knockback_strength
		hitbox_component.set_damage(bullet_data.damage)
		hitbox_component.get_child(0).shape.size = bullet_data.hitbox_size
	update_collision_layers()
	visible_on_screen_notifier_2d.screen_exited.connect(queue_free)
	


func _physics_process(delta : float) -> void:
	movement_component.move(speed, direction)
	movement_component.calculate_final_velocity(delta)
	velocity = movement_component.get_velocity()
	move_and_slide()


func setup_with_bullet_data():
	speed = bullet_data.speed
	max_collision_count = bullet_data.max_collisions
	sprite_2d.texture = bullet_data.sprite
	hitbox_component.damage = bullet_data.damage
	life_time_timer = CooldownComponent.new(bullet_data.lifetime)
	life_time_timer.cooldown_over.connect(queue_free)


func update_collision_layers():
	if !hitbox_component:
		return
	hitbox_component.set_collision_layer_value(ENEMY_HURTBOX_LAYER, false)
	hitbox_component.set_collision_layer_value(PLAYER_HURTBOX_LAYER, false)
	hitbox_component.set_collision_mask_value(PLAYER_HITBOX_LAYER, false)
	hitbox_component.set_collision_mask_value(ENEMY_HITBOX_LAYER, false)

	match current_team:
		TeamComponent.Teams.ENEMY:
			hitbox_component.set_collision_mask_value(PLAYER_HURTBOX_LAYER, true)
			hitbox_component.set_collision_layer_value(ENEMY_HITBOX_LAYER, true)
		TeamComponent.Teams.PLAYER:
			hitbox_component.set_collision_mask_value(ENEMY_HURTBOX_LAYER, true)
			hitbox_component.set_collision_layer_value(PLAYER_HITBOX_LAYER, true)
		TeamComponent.Teams.NEUTRAL:
			hitbox_component.set_collision_layer_value(PLAYER_HITBOX_LAYER, true)
			hitbox_component.set_collision_layer_value(ENEMY_HITBOX_LAYER, true)
			hitbox_component.set_collision_mask_value(PLAYER_HURTBOX_LAYER, true)
			hitbox_component.set_collision_mask_value(ENEMY_HURTBOX_LAYER, true)
