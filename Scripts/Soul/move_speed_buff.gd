class_name MoveSpeedBuff
extends Effect


@export var flat_increase : float = 10


func apply(target : Node) -> void:
	if not target.has_method("get_statistic_component"):
		return
	
	var statistic_component : StatisticComponent = target.get_statistic_component()
	if not statistic_component.get_statistic_object("Speed"):
		return
	
	var speed_object : Statistic = statistic_component.get_statistic_object("Speed")
	speed_object.add_modifier(StatisticModifier.new(flat_increase, StatisticModifier.Type.ADDITIVE))
