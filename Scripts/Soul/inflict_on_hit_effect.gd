extends TriggeredEffect




func _init() -> void:
	signal_name = "enemy_hit"


func should_trigger(data : Dictionary) -> bool:
	return true


func apply_with_data(data : Dictionary) -> void:
	pass
