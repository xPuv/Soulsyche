extends BehaviourTreeNode


const GUESS_FACTOR : int = 30


func tick(_delta : float) -> Results:
	var target_position : Vector2 = blackboard.get_data("CurrentTargetPosition")
	var waypoint_component : WaypointComponent = blackboard.get_data("WaypointComponent")
	var guess : Vector2 = target_position + (target_position.normalized() * GUESS_FACTOR)
	blackboard.set_data(waypoint_component.calculate_random_position(guess), "CurrentTargetPosition")
	return Results.SUCCESS
