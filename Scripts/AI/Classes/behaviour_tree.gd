class_name BehaviourTree
extends Node


@export var root : BehaviourTreeNode = null


var blackboard : Blackboard = null


func _enter_tree() -> void:
	blackboard = Blackboard.new()


func _ready() -> void:
	root.set_blackboard(blackboard)


func tick(delta : float):
	blackboard.set_data(delta, "delta")
	root.tick(delta)
