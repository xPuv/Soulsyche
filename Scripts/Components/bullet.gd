class_name Bullet
extends CharacterBody2D

@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

var direction : Vector2 = Vector2.ZERO
var speed : float = 220
var max_collision_count : int = -1
var collision_count : int = 0
var movement_component : MovementComponent = null


func setup(max_collisions : int, spd : float, dir : Vector2, global_pos : Vector2):
	movement_component = MovementComponent.new()
	max_collision_count = max_collisions
	if spd != -1: # Default case. if its not it will be 30 as defined here
		speed = spd
	direction = dir
	global_position = global_pos
	global_rotation = direction.angle()


func _ready() -> void:
	visible_on_screen_notifier_2d.screen_exited.connect(queue_free)


func _physics_process(_delta : float) -> void:
	movement_component.move(self, speed, direction)
	move_and_slide()
