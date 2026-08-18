extends TimedEffect


func apply(target : Node) -> void:
	if not target.has_method("take_damage"):
		return
	
	target.take_damage(1)
