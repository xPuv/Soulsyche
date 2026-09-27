extends Node

const YOU_WIN = preload("uid://6qqwyswf4bmb")

var room_manager : Node2D


var rooms_cleared : int = 0
var rooms_to_clear : int = 0


func _ready() -> void:
	GameEvents.room_cleared.connect(_on_room_cleared)


func _on_room_cleared():
	rooms_cleared += 1
	if rooms_cleared == rooms_to_clear:
		win_game()


func setup(_room_manager : Node) -> void:
	room_manager = _room_manager
	setup_total_rooms()


func setup_total_rooms():
	rooms_to_clear = room_manager.max_number_of_rooms
	rooms_cleared = 0


func win_game():
	GameEvents.game_win.emit()
