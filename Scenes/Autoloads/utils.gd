extends Node


func get_effects_layer() -> Node2D:
	if get_tree().get_first_node_in_group("VFX") != null:
		return get_tree().get_first_node_in_group("VFX")
	return null


func get_bullets_layer() -> Node2D:
	if get_tree().get_first_node_in_group("Bullets") != null:
		return get_tree().get_first_node_in_group("Bullets")
	return null 


func get_player() -> CharacterBody2D:
	if get_tree().get_first_node_in_group("Player") != null:
		return get_tree().get_first_node_in_group("Player")
	return null


@warning_ignore("unused_parameter")
# TODO
func is_valid_position(pos : Vector2) -> bool:
	return true
