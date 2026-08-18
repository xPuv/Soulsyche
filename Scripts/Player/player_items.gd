class_name PlayerItems
extends RefCounted

signal key_num_changed(to : int)


var key_num : int = 0 : set = set_key


func has_key() -> bool:
	return key_num > 0


func set_key(value):
	key_num = value
	key_num_changed.emit(value)


func add_key() -> void:
	key_num += 1


func use_key() -> void:
	key_num -= 1
