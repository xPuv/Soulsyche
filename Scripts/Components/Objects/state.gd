class_name State
extends RefCounted

# Set in each scripts init
@export var id : int = -1


signal change_state(id : int)


func enter_state():
	pass


func exit_state():
	pass


func tick():
	pass
