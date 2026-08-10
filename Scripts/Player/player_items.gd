class_name PlayerItems
extends RefCounted

signal key_num_changed(key : StringName, to : int)


var keys : Dictionary[StringName, int] = {}


func has_key(key_name : StringName) -> bool:
	return keys.has(key_name) and keys[key_name] > 0


func add_key(key_name : StringName, amount : int) -> void:
	keys[key_name] = keys.get(key_name, 0) + amount
	key_num_changed.emit(key_name, amount)


func use_key(key_name : StringName) -> void:
	keys[key_name] -= 1
	if keys[key_name] == 0:
		keys.erase(key_name)
