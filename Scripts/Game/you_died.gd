extends ColorRect

@onready var quit : Button = $Quit
@onready var try_again : Button = $TryAgain

func _ready() -> void:
	get_tree().paused = true
	try_again.pressed.connect(_on_try_again)
	quit.pressed.connect(_on_quit)


func _on_try_again():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Game/game.tscn")


func _on_quit():
	get_tree().quit()
