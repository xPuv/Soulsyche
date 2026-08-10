extends BehaviourTreeNode



func tick(_delta : float) -> Results:
	var target : Vector2 = blackboard.get_data("CurrentTargetPosition")
	var weapon_component : WeaponComponent = blackboard.get_data("WeaponComponent")
	if !target or !weapon_component:
		return Results.FAILURE
	
	var commands : WeaponCommands = WeaponCommands.new(true)
	weapon_component.process_commands(commands)
	return Results.SUCCESS
