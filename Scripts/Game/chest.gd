class_name Chest
extends StaticBody2D

const COLLECTABLE = preload("uid://cv12kq6wn4btw")

@export var locked : bool = false
@export var loot_table : WeightedTable = null
@export var number_of_drops : int = 1

var opened : bool = false


func interact(interacter : Node2D):
	if locked:
		unlock(interacter)
	else:
		open()


func open():
	if locked or opened:
		return
	
	var collectable : Collectable = COLLECTABLE.instantiate()
	collectable.drop = loot_table.pick_random()
	var entity_layer : Node2D = Utils.get_entity_layer()
	entity_layer.add_child(collectable)
	collectable.global_position = global_position + Vector2(0, 16) + Vector2(randi_range(8, 8), randi_range(8, 8))
	opened = true


func unlock(opener : Node2D):
	if opener.has_key():
		opener.use_key()
		locked = false
