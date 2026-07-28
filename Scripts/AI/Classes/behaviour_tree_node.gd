## Base class for all behaviour tree nodes. At the moment, can be used interchangbly as a 'Condition' leaf.
class_name BehaviourTreeNode
extends Node


enum Results {
	SUCCESS,
	FAILURE,
	RUNNING
}


var blackboard : Blackboard = null


func tick(_delta : float) -> Results:
	return Results.FAILURE


func abort() -> void:
	pass


func set_blackboard(to : Blackboard) -> void:
	blackboard = to
	for child in get_children():
		child.set_blackboard(to)
