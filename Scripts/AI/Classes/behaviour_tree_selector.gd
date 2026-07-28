extends BehaviourTreeNode
class_name BehaviourTreeSelector

@export var memory : bool = false


var last_running_child_index : int = -1


func tick(delta : float) -> Results:
	var start_index : int = 0  
	
	if memory and last_running_child_index != -1:
		start_index = last_running_child_index


	for i in range(start_index, get_children().size()):
		var leaf : BehaviourTreeNode = get_children()[i]
		var result = leaf.tick(delta)
		
		
		match result:
			Results.SUCCESS:
				last_running_child_index = -1
				return Results.SUCCESS
			Results.FAILURE:
				continue
			Results.RUNNING:
				if last_running_child_index != i:
					get_children()[last_running_child_index].abort()
				
				last_running_child_index = i
				return Results.RUNNING
	
	last_running_child_index = -1
	return Results.FAILURE



func abort() -> void:
	if last_running_child_index != -1:
		var children : Array = get_children()
		children[last_running_child_index].abort()
		
	last_running_child_index = -1
