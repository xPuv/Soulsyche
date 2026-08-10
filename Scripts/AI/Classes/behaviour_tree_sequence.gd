extends BehaviourTreeNode
class_name BehaviorTreeSequence


@export var memory : bool = false


var last_running_child_index : int = -1


func tick(delta : float) -> Results:
	var start_index : int = 0 
	
	if memory and last_running_child_index != -1:
		start_index = last_running_child_index

	var children : Array = get_children()
	for i in range(start_index, children.size()):
		var leaf : BehaviourTreeNode = children[i]
		var result = leaf.tick(delta)
		
		
		match result:
			Results.SUCCESS:
				continue
			Results.FAILURE:
				last_running_child_index = -1
				return Results.FAILURE
			Results.RUNNING:
				last_running_child_index = i
				return Results.RUNNING
	
	last_running_child_index = -1
	return Results.SUCCESS


func abort() -> void:
	if last_running_child_index != -1:
		var children : Array = get_children()
		children[last_running_child_index].abort()
		
	last_running_child_index = -1
