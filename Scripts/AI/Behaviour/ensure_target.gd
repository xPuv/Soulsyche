extends BehaviourTreeNode


func tick(_delta : float) -> Results:
	var waypoint_component : WaypointComponent = blackboard.get_data("WaypointComponent")
	if blackboard.get_data("CurrentTargetPosition") != null and blackboard.get_data("CurrentTargetPositionOwner") == waypoint_component:
		return Results.SUCCESS
	
	
	var actor_global_position : Vector2 = blackboard.get_data("Actor").global_position
	blackboard.set_data(waypoint_component, "CurrentTargetPositionOwner")
	blackboard.set_data(waypoint_component.calculate_random_position(actor_global_position), "CurrentTargetPosition")
	return Results.SUCCESS
