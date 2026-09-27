class_name Door
extends Node2D

@onready var enter_detection_zone : Area2D = $EnterDetectionZone
@onready var area_blocked_off : CollisionShape2D = $StaticBody2D/AreaBlockedOff
@onready var enter_detection_zone_2: Area2D = $EnterDetectionZone2
@onready var sprite_2d: Sprite2D = $Sprite2D

const DOOR_ONE = preload("uid://d20vfppdn8cuq")
const DOOR_TWO = preload("uid://bn2b5jooo1qxp")

signal door_entered(pos : Vector2)


var locked : bool = false
var rooms_linked_to : Array[Room] = []


func add_room_to_linked_rooms(x : Room):
	rooms_linked_to.append(x)
	x.unlock_connected_doors.connect(unlock)
	x.lock_connected_doors.connect(lock)


func _ready() -> void:
	enter_detection_zone.body_entered.connect(_on_body_entered)
	enter_detection_zone_2.body_entered.connect(_on_body_entered)
	unlock()


func lock():
	locked = true
	sprite_2d.texture = DOOR_ONE
	area_blocked_off.set_deferred("disabled", false)
	enter_detection_zone.get_child(0).set_deferred("disabled", true)
	enter_detection_zone_2.get_child(0).set_deferred("disabled", true)


func unlock():
	locked = false
	sprite_2d.texture = DOOR_TWO
	area_blocked_off.set_deferred("disabled", true)
	enter_detection_zone.get_child(0).set_deferred("disabled", false)
	enter_detection_zone_2.get_child(0).set_deferred("disabled", false)


func _on_body_entered(body):
	door_entered.emit(body.global_position)
