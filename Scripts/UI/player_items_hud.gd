extends Control

@onready var number_label : Label = $NumberLabel


func setup(player : Player):
	player.player_items.key_num_changed.connect(_on_key_change)
	_on_key_change(player.player_items.key_num)


func _on_key_change(to : int):
	number_label.text = "x%s" % to
