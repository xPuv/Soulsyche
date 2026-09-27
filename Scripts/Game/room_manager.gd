extends Node2D

@export var max_number_of_rooms : int = 5
@export var number_of_chest_rooms : int = 3

@export var room_pool : WeightedTable = null
@export var room_grouper_node : Node = null
@export var door_grouper_node : Node = null

var directions : Array[Vector2i] = [Vector2i.RIGHT, Vector2i.LEFT, Vector2i.DOWN, Vector2i.UP]
var room_position_map : Dictionary = {}
var world_position_to_abstract_map : Dictionary = {}


func _ready() -> void:
	var maps : Array = generate_rooms()
	for key in maps[0].keys():
		var room = key
		room.global_position = to_global(maps[0][key])
		room_position_map[room] = to_global(maps[0][key])
		room_grouper_node.add_child(room)
	add_doors_to_rooms(maps[0], maps[1])


func generate_rooms():
	var rooms = get_random_rooms() 
	var map = {}
	var attempts = 0
	var abstract_map = null
	while map == {} and attempts < 200:
		attempts += 1
		abstract_map = generate_abstract_map()
		if abstract_map == []:
			continue
		map = get_room_positions(rooms, abstract_map)
	return [map, abstract_map]



func add_doors_to_rooms(room_map : Dictionary, abstract_map : Array[Vector2i]):
	for room in room_map.keys():
		var world_position : Vector2 = room_map[room]
		var abstract_map_position : Vector2i = world_position_to_abstract_map[(world_position)]
		var abstract_map_neighbours : Array = get_neighbours(abstract_map_position, abstract_map)
		var all_neighbouring_rooms = abstract_map_neighbours.filter(func(x): return abstract_map.has(x))
		for neighbour_abstract_pos in all_neighbouring_rooms:
			var other_room = get_room_from_abstract_position(neighbour_abstract_pos, room_map)
			var wall_tiles = get_positions_of_shared_wall_tiles(room, other_room)
			if not wall_tiles:
				continue 
			if door_grouper_node.is_door_placed(room, other_room):
				continue
			var local_tile_pos_one_other_room : Vector2i = get_local_tile_position(other_room, wall_tiles[0])
			var local_tile_pos_two_other_room : Vector2i = get_local_tile_position(other_room, wall_tiles[1])
			var local_tile_pos_one_room : Vector2i = get_local_tile_position(room, wall_tiles[0])
			var local_tile_pos_two_room : Vector2i = get_local_tile_position(room, wall_tiles[1])
			room.remove_tiles_at(local_tile_pos_one_room, local_tile_pos_two_room)
			other_room.remove_tiles_at(local_tile_pos_one_other_room, local_tile_pos_two_other_room)
			var door : Door = door_grouper_node.create_door_at(room, other_room,  wall_tiles[0], wall_tiles[1])
			door.door_entered.connect(_on_player_enter_door)
			door.add_room_to_linked_rooms(room)
			door.add_room_to_linked_rooms(other_room)


func _on_player_enter_door(player_position: Vector2):

	for room in room_position_map.keys():
		var rect := get_room_rect(room, room_position_map[room])


		if rect.has_point(player_position):

			room._on_player_entered()
			return





func get_room_from_abstract_position(abstract_pos : Vector2i, room_map : Dictionary):
	var world_position : Vector2 = world_position_to_abstract_map.find_key(abstract_pos)
	var room = room_map.find_key(world_position)
	return room


func get_positions_of_shared_wall_tiles(room_one : Room, room_two : Room):
	var common_tiles : Array[Vector2i] = []
	var all_room_one_wall_tiles : Array[Vector2i] = get_world_tiles(room_one)
	var all_room_two_wall_tiles : Array[Vector2i] = get_world_tiles(room_two)
	common_tiles = all_room_one_wall_tiles.filter(func(tile_coords): return all_room_two_wall_tiles.has(tile_coords))
	var vertical := common_tiles.all(
		func(tile): return tile.x == common_tiles[0].x
	)


	if vertical:
		common_tiles.sort_custom(func(a, b): return a.y < b.y)
	else:
		common_tiles.sort_custom(func(a, b): return a.x < b.x)

	if len(common_tiles) < 2:
		push_error("Need to make sure these rooms can connect!%s and %s" % [room_one, room_two])
		return []


	return [common_tiles[len(common_tiles) / 2], common_tiles[len(common_tiles) / 2 - 1]]


func get_world_tiles(room : Room) -> Array[Vector2i]:
	var tiles : Array[Vector2i] = []

	var room_offset : Vector2i = Vector2i(room.global_position / room.walls.tile_set.tile_size.x)

	for tile in room.walls.get_used_cells():
		tiles.append(tile + room_offset)

	return tiles


func get_local_tile_position(room : Room, tile : Vector2i)  -> Vector2i:
	var room_offset : Vector2i = Vector2i(room.global_position / room.walls.tile_set.tile_size.x)

	return tile - room_offset


func generate_abstract_map() -> Array[Vector2i]:
	var current_map : Array[Vector2i] = []
	current_map.append(Vector2i.ZERO)
	
	for i in range(max_number_of_rooms - 1): # account for intial room
		var desired_placement = current_map[i] + directions.pick_random()
		
		if len(current_map) > 1:
			while desired_placement in current_map:
				var all_possible_placements = []
				var free_spots = []
				
				for direction in directions:
					all_possible_placements.append(direction + current_map[i - 1])
				
				for value in all_possible_placements:
					if not current_map.has(value):
						free_spots.append(value)
				
				if free_spots == []:
					return []
				
				desired_placement = free_spots.pick_random()
		
		current_map.append(desired_placement)
	return current_map


func get_random_rooms() -> Array[Room]:
	var rooms : Array[Room] = []
	for i in max_number_of_rooms:
		var room : Room = (room_pool.pick_random()).instantiate()
		rooms.append(room)
	return rooms


func get_room_positions(rooms : Array[Room], map : Array[Vector2i]) -> Dictionary:
	# Room 0 can be replaced with starter room 
	var assignment = {rooms[0] : Vector2(0, 0)} # Set first room to 0,0
	var abstract_map_assignment = {}
	for i in range(min((len(rooms)), len(map))):
		abstract_map_assignment[rooms[i]] = map[i]
	world_position_to_abstract_map[Vector2(0, 0)] = map[0]
	var queue : Array = [rooms[0]]
	while not queue.is_empty():
		
		var placed_room = queue.pop_front()
		var current_map_pos = abstract_map_assignment[placed_room]
		var neighbour_map_positions = get_neighbours(current_map_pos, map)
		for neighbour_pos in neighbour_map_positions:
			
				var room_to_place = rooms[map.find(neighbour_pos)]
				
				if assignment.keys().has(room_to_place):
					continue
				
				var direction : Vector2i = neighbour_pos - current_map_pos
				var possible_room_position = get_possible_room_position(placed_room, direction, assignment)
				if not is_valid_placement(possible_room_position, room_to_place, assignment):
					world_position_to_abstract_map = {}
					return {}
				
				assignment[room_to_place] = possible_room_position
				world_position_to_abstract_map[possible_room_position] = neighbour_pos
				queue.push_back(room_to_place)
	return assignment


func get_neighbours(position : Vector2i, all_positions : Array[Vector2i]) -> Array[Vector2i]:
	return all_positions.filter(func(x): return position + Vector2i.RIGHT == x or\
	position + Vector2i.DOWN == x or position + Vector2i.UP == x or position + Vector2i.LEFT == x)


func get_possible_room_position(
	placed_room: Room,
	direction: Vector2i,
	assignment: Dictionary
) -> Vector2:

	var possible_position: Vector2 = assignment[placed_room]


	var room_size: Vector2i = (
		placed_room.get_dimensions() - Vector2i.ONE # To account for the 0th tile
	)

	possible_position += Vector2(room_size * direction) * placed_room.get_tile_size()

	return possible_position


func is_valid_placement(possible_room_position : Vector2, room_to_place : Room, assignment : Dictionary):
	var room_placing_space = get_room_rect(room_to_place, possible_room_position)
	for room in assignment.keys():
		var other_room_space_taken = get_room_rect(room, assignment[room])
		if other_room_space_taken.intersects(room_placing_space):
			return false
	return true


func get_room_rect(room: Room, position: Vector2) -> Rect2:
	var dimensions := room.get_dimensions() - Vector2i.ONE
	var tile_size := room.get_tile_size()

	var size := Vector2(dimensions) * tile_size

	return Rect2(position, size)
