class_name AbilityComponent
extends RefCounted


var current_ability : Ability = null
var cooldown_timer : CooldownComponent = null
var duration_timer : CooldownComponent = null

var target : Node = null


func _setup_timers(_abil : Ability):
	# / 2, so half the cooldown whent he ability is equiped
	cooldown_timer = CooldownComponent.new(_abil.cooldown_time)
	duration_timer = CooldownComponent.new(_abil.duration)
	cooldown_timer.start_cooldown()
	duration_timer.cooldown_over.connect(_on_duration_over)


func set_ability(_abil : Ability):
	current_ability = _abil
	_setup_timers(_abil)
	print("Ability set!")


func tick(delta : float):
	duration_timer.tick(delta)
	cooldown_timer.tick(delta)


func can_use_ability():
	if cooldown_timer == null:
		return false
	return cooldown_timer.ready


func use_ability(on : Variant): #  Might need a better way of handling this but seems ok for now
	target = on
	current_ability.activate({"target" : target})
	duration_timer.start_cooldown()


func _on_duration_over():
	current_ability.revert({"target" : target})
	cooldown_timer.start_cooldown()
