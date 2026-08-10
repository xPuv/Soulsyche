extends BehaviourTreeNode


func tick(_delta : float) -> Results:
	var weapon_component : WeaponComponent = blackboard.get_data("WeaponComponent")
	if !weapon_component:
		return Results.FAILURE 
	if weapon_component.can_shoot() == false:
		return Results.FAILURE
	return Results.SUCCESS
