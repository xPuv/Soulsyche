class_name Room
extends Node2D

signal lock_connected_doors
signal unlock_connected_doors

@onready var enemy_spawner : Node = $EnemySpawner

@export var is_boss_room = false 
@export var chest_random_table : WeightedTable = null
@export var tilemap_layer_grouper : Node = null
@export var walls : TileMapLayer = null

var room_cleared : bool = false

const DOUBLE_DOOR = preload("uid://cnlrrc767lg3y")


func _ready() -> void:
	enemy_spawner.enemies_in_room_clear.connect(_on_enemies_cleared)
	variation()


func variation():
	var random_float : float = randf()
	if random_float < 0.3:
		make_chest_room()
	elif random_float < 0.8:
		enemy_spawner.enemies_to_spawn += 3 # More mobs


func make_chest_room():
	var chest = chest_random_table.pick_random()
	var c_instance = chest.instantiate()
	c_instance.global_position = get_centre() + Vector2(0, -48)
	add_child(c_instance)



func _on_enemies_cleared():
	if not is_boss_room:
		room_cleared = true
		unlock_doors()


func _on_player_entered():
	if room_cleared:
		return
	
	lock_doors()
	enemy_spawner.spawn_enemies()


func lock_doors():
	lock_connected_doors.emit()


func unlock_doors():
	unlock_connected_doors.emit()



func remove_tiles_at(pos_1 : Vector2i, pos_2 : Vector2i):
	walls.erase_cell(pos_1)
	walls.erase_cell(pos_2)


func get_centre() -> Vector2:
	var rect := walls.get_used_rect()
	var centre := rect.get_center()
	return centre * walls.tile_set.tile_size


func get_dimensions() -> Vector2i:
	var combined_rect : Rect2i = Rect2i()

	for layer in tilemap_layer_grouper.get_children():
		combined_rect = combined_rect.merge(layer.get_used_rect())

	return combined_rect.size


func get_tile_size() -> int:
	return tilemap_layer_grouper.get_children()[0].tile_set.tile_size.x
	
