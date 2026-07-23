class_name StatisticComponentFactory
extends RefCounted


static func create_statistic_component(owner : Node, dictionary_definition : Dictionary) -> StatisticComponent:
	var stat_component = StatisticComponent.new(owner)
	for dict_name in dictionary_definition:
		var stat_type : String = dictionary_definition[dict_name]["type"]
		var stat_base_value : int = dictionary_definition[dict_name]["base_value"]
	
		match stat_type:
			"default":
				stat_component.add_statistic_object(dict_name, Statistic.new(stat_base_value))
			"clamped":
				var max_value : int = dictionary_definition[dict_name]["max_value"]
				var min_value : int =  dictionary_definition[dict_name]["min_value"]
				stat_component.add_statistic_object(dict_name, ClampedStatistic.new(stat_base_value, min_value, max_value))
		
	return stat_component
