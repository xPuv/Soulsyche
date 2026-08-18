class_name StatisticModifierffect
extends Effect


@export var statistic_name : String = ""
@export var multilpier : float = 1.0
@export var flat_increase : int = 0


func apply(target : Node) -> void:
	var statistic_component : StatisticComponent = target.statistic_component
	var stat_object : Statistic = statistic_component.get_statistic_object(statistic_name)
	if multilpier != 1.0:
		stat_object.add_modifier(StatisticModifier.new(multilpier, StatisticModifier.Type.MULTIPLICITIVE))
	if flat_increase != 0:
		stat_object.add_modifier(StatisticModifier.new(flat_increase, StatisticModifier.Type.ADDITIVE))
