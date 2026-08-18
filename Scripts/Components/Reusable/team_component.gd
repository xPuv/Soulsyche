class_name TeamComponent
extends RefCounted


enum Teams {
	PLAYER,
	NEUTRAL,
	ENEMY
}
var team : int = 0


func get_team() -> int:
	return team


func _init(current_team : Teams) -> void:
	team = current_team
