class_name StatisticModifier extends RefCounted 


enum Type {
	ADDITIVE,
	MULTIPLICITIVE
}
@export var _value : float = 1.0

var current_type : Type = Type.ADDITIVE


func _init(value : float, new_type : Type) -> void:
	_value = value
	current_type = new_type


func apply(value : float):
	match current_type:
		Type.ADDITIVE:
			return value + _value
		Type.MULTIPLICITIVE:
			return value * _value
