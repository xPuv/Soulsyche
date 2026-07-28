extends BehaviourTreeNode


@export var stop_distance : int = 10


var target_position : Vector2 = Vector2.ZERO


func tick(_delta : float) -> Results:
	
	var movement_component : MovementComponent = blackboard.get_data("MovementComponent")
	var statistic_component : StatisticComponent = blackboard.get_data("StatisticComponent")
	var actor : CharacterBody2D = blackboard.get_data("Actor")
	var actor_global_position : Vector2 = actor.global_position
	target_position = blackboard.get_data("CurrentTargetPosition")
	var direction : Vector2 = (target_position - actor_global_position).normalized()
	if actor_global_position.distance_to(target_position) < stop_distance:
		movement_component.move(statistic_component.get_statistic_value("Speed"), Vector2.ZERO)
		return Results.SUCCESS
	
	movement_component.move(statistic_component.get_statistic_value("Speed"), direction)
	return Results.RUNNING
