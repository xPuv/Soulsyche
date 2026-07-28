extends BehaviourTreeNode


func tick(_delta : float) -> Results:
	var player : CharacterBody2D = Utils.get_player()
	blackboard.set_data((player.global_position), "CurrentTargetPosition")
	if blackboard.get_data("CurrentTargetPositionOwner") == player:
		return Results.SUCCESS
	
	
	blackboard.set_data(player, "CurrentTargetPositionOwner")
	return Results.SUCCESS
