extends BehaviourTreeNode


func tick(_delta : float) -> Results:
	var line_of_sight_component : Area2D = blackboard.get_data("LineOfSightArea2D")
	if !line_of_sight_component:
		return Results.FAILURE

	
	if len(line_of_sight_component.get_overlapping_bodies()) != 0:
		blackboard.set_data(true, "InvestigationPending")
		print(blackboard.get_data("InvestigationPending"))
		return Results.SUCCESS 


	return Results.FAILURE
