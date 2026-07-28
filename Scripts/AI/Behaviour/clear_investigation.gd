extends BehaviourTreeNode


func tick(_delta : float) -> Results:
	blackboard.remove_data("InvestigationPending")
	return Results.SUCCESS
