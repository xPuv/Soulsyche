extends Node

const DOUBLE_DOOR = preload("uid://cnlrrc767lg3y")

var door_to_pos : Dictionary = {}


func create_door_at(room : Room, room_two : Room, pos_1 : Vector2i, pos_2 : Vector2i, ) -> Door:
	var tile_size : int = room.get_tile_size()
	var door : Door = DOUBLE_DOOR.instantiate()
	var direction = Vector2(pos_2 - pos_1).normalized()
	door.rotate(direction.angle())  
	var anchor_tile : Vector2 = pos_2
	var room_centre = room.get_centre()
	door.rotation = direction.angle()

	if direction.x == 0: # Vertical
		if direction.y <= 0:
			anchor_tile = pos_1
		var door_facing_direction = ((Vector2(anchor_tile.x * tile_size, anchor_tile.y * tile_size) - room_centre).sign())
		if door_facing_direction == Vector2.RIGHT:
			door.rotate(deg_to_rad(180))  
		door.global_position.x = anchor_tile.x * tile_size + tile_size / 2
		door.global_position.y = anchor_tile.y * tile_size
	elif direction.y == 0:
		if direction.x < 0:
			anchor_tile = pos_1
		var door_facing_direction = ((Vector2(anchor_tile.x * tile_size, anchor_tile.y * tile_size) - room_centre).sign())
		if door_facing_direction == Vector2.UP:
			door.rotate(deg_to_rad(180))  
		door.global_position.x = anchor_tile.x * tile_size
		door.global_position.y = anchor_tile.y * tile_size + tile_size / 2
	
	add_child(door)
	door_to_pos[door] = [room, room_two]
	return door



func is_door_placed(room_one : Room, room_two : Room) -> bool:
	return door_to_pos.values().has([room_one, room_two]) or door_to_pos.values().has([room_two, room_one])
