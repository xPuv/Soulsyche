extends BehaviourTreeNode



func tick(_delta) -> Results:
	if blackboard.get_data("InvestigationPending") == null: # Avoid crash
		return Results.FAILURE
	var needs_investigation : bool = blackboard.get_data("InvestigationPending")
	if needs_investigation == true:
		return Results.SUCCESS
	return Results.FAILURE
