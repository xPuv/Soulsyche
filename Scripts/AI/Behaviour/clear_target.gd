extends BehaviourTreeNode


func tick(_delta : float) -> Results:
	if !blackboard.get_data("CurrentTargetPosition"):
		return Results.FAILURE
	blackboard.remove_data("CurrentTargetPosition")
	blackboard.remove_data("CurrentTargetPositionOwner")
	return Results.SUCCESS
