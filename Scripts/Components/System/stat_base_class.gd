class_name Statistic 
extends RefCounted

signal modifier_change(stat : Statistic)

var base_value : int = 1 : get = get_value
var _modifiers :  Array[StatisticModifier] = []


func _init(value : int) -> void:
	base_value = value


func increase_base_value(by_amount  : int) -> void:
	base_value += by_amount


func add_modifier(stat_modifier : StatisticModifier):
	_modifiers.append(stat_modifier)
	modifier_change.emit(self)


func remove_modifier(stat_modifier : StatisticModifier):
	_modifiers.erase(stat_modifier)
	modifier_change.emit(self)


func get_value() -> int: ## Stats should also know what modifiers are added and should return a multiplied value bsaed on the modifiers applied
	var value = base_value
	for modifier in _modifiers:
		value = modifier.apply(value)
	return value


func to_dict() -> Dictionary:
	return {"type" : "default", "base_value" : base_value}
