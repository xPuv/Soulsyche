class_name LootDropComponent
extends Node2D

const COLLECTABLE = preload("uid://cv12kq6wn4btw")

@export var loot_table : WeightedTable = null
@export var drop_number : int = 2


func get_loot() -> Array:
	var loot_to_drop = []
	for i in drop_number:
		loot_to_drop.append(loot_table.pick_random())
	
	return loot_to_drop


func drop_loot():
	var loot = get_loot()
	spawn_loot(loot)



func spawn_loot(what : Array):
	for item in what:
		if not is_instance_of(item, Resource) and item ==  "None":
			continue
		var c : Collectable = COLLECTABLE.instantiate()
		c.drop = item
		c.global_position = owner.global_position
		var entity_layer = Utils.get_entity_layer()
		entity_layer.call_deferred("add_child", c)
