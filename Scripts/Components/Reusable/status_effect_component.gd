class_name StatusEffectComponent
extends RefCounted

var current_status_effects : Array[Effect] = []
var current_timed_status_effects : Array[StatusEffectInstance] = []
var owner : Node = null


func _init(_owner : Node) -> void:
	owner = _owner


func add_status_effect(status_effect : Effect, duration : float = 0.0):
	# activate
	if status_effect is TimedEffect:
		var status_effect_instance : StatusEffectInstance = StatusEffectInstance.new(status_effect, duration)
		status_effect_instance.duration_over.connect(remove_timed_status_effect)
		current_timed_status_effects.append(status_effect_instance)
	else:
		current_status_effects.append(status_effect)
	status_effect.apply(owner)
	


func tick(delta : float):
	for timed_effect_instance in current_timed_status_effects:
		timed_effect_instance.tick(delta)
		if timed_effect_instance.inflict_cooldown_timer.ready:
			timed_effect_instance.apply(owner)


func remove_status_effect(status_effect : Effect):
	current_status_effects.erase(status_effect)


func remove_timed_status_effect(status_effect_instance : StatusEffectInstance):
	if status_effect_instance.duration_over.is_connected(remove_timed_status_effect):
		status_effect_instance.duration_over.disconnect(remove_timed_status_effect)
	
	status_effect_instance.revert(owner)
	current_timed_status_effects.erase(status_effect_instance)


func is_effect_active(effect : Effect):
	var effect_found : bool = false
	for timed in current_timed_status_effects:
		if timed.effect == effect:
			effect_found = true
	return current_status_effects.has(effect) or effect_found
