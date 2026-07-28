class_name Blackboard
extends RefCounted


var data = {}


func set_data(thing_to_add : Variant, key_name : String):
	data[key_name] = thing_to_add


func remove_data(key_name : String):
	data.erase(key_name)


func get_data(key_name : String):
	if data.has(key_name) == true:
		return data[key_name]
	return null
