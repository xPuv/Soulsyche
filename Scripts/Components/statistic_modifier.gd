class_name StatisticModifier extends RefCounted 


@export_enum("ADDITIVE", "MULTIPLICITIVE") var type : String  = "ADDITIVE"
@export var _value : float = 1.0


func _init(value : int, new_type : String) -> void:
	_value = value
	type = new_type


func apply(value : float):
	match type:
		"ADDITIVE":
			return value + _value
		"MULTIPLICITVE":
			return value * _value
