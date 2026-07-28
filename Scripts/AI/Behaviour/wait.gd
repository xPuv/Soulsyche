extends BehaviourTreeNode



@export var duration : float = 5.0


var cooldown_component : CooldownComponent = null
var waiting : bool = false


func _enter_tree() -> void:
	cooldown_component = CooldownComponent.new(duration)
	waiting = false


func tick(delta : float) -> Results:
	if !waiting:
		cooldown_component.start_cooldown()
		waiting = true
	
	cooldown_component.tick(delta)
	if cooldown_component.ready:
		waiting = false # Reset for next use
		return Results.SUCCESS
	return Results.RUNNING


func abort() -> void:
	cooldown_component.reset()
