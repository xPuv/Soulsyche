class_name StatisticComponent

signal value_changed(name_of_stat : String, stat_object : Statistic)

var _stats : Dictionary[String, Statistic] = {}
var owner : Node = null


func _init(_owner : Node):
	owner = _owner


func _onValueChanged(stat_object : Statistic):
	var stat_name = _stats.find_key(stat_object)
	value_changed.emit(stat_name, self)


func add_statistic_object(name : String, statistic_object : Statistic):
	_stats[name] = statistic_object
	statistic_object.modifier_change.connect(_onValueChanged)


func add_value_to_statistic(stat_name : String, value : int):
	var statistic_object : Statistic = get_statistic_object(stat_name)
	statistic_object.increase_base_value(value)


func decrease_value_from_statistic(stat_name : String, value : int):
	var statistic_object : Statistic = get_statistic_object(stat_name)
	statistic_object.increase_base_value(-value)


func get_statistic_object(stat_name : String) -> Statistic:
	return _stats[stat_name]


func get_statistic_value(stat_name :  String) -> int:
	return (_stats[stat_name]).get_value()


func to_dict() -> Dictionary:
	var as_dict : Dictionary = {}
	for key in _stats:
		as_dict[key] = _stats[key].to_dict()
	return as_dict


func get_statistic_as_dict(stat_name : String) -> Dictionary:
	return _stats[stat_name].to_dict()
