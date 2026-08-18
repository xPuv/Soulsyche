class_name StatusEffectInstance
extends RefCounted



# i.e does it active every few ticks or just once ( burning vs slow ) 
var inflict_cooldown_timer : CooldownComponent = null
var lifecycle_timer : CooldownComponent = null


var effect : Effect = null


signal duration_over

func _init(_effect : TimedEffect, _duration : float) -> void:
	effect = _effect
	lifecycle_timer = CooldownComponent.new(_duration)
	lifecycle_timer.cooldown_over.connect(func(): duration_over.emit(self))
	if _effect.inflict_on_cooldown:
		inflict_cooldown_timer = CooldownComponent.new(_effect.inflict_cooldown_time)
		inflict_cooldown_timer.start_cooldown()
	lifecycle_timer.start_cooldown()


func tick(delta : float):
	lifecycle_timer.tick(delta)
	if inflict_cooldown_timer:
		inflict_cooldown_timer.tick(delta)


func apply(target : Node) -> void:
	if inflict_cooldown_timer:
		if inflict_cooldown_timer.ready:
			effect.apply(target)
			inflict_cooldown_timer.start_cooldown()
	effect.apply(target)


func revert(target : Node) -> void:
	effect.revert(target)
