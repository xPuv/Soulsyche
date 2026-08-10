extends BehaviourTreeNode


func tick(_delta : float) -> Results:
	var line_of_sight_component : LineOfSightComponent = blackboard.get_data("LineOfSightComponent")
	if !line_of_sight_component:
		return Results.FAILURE

	
	if line_of_sight_component.target_in_line_of_sight():
		blackboard.set_data(true, "InvestigationPending")
		return Results.SUCCESS 


	return Results.FAILURE
