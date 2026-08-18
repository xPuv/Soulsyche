class_name BurnOnHit
extends "res://Scripts/Soul/inflict_on_hit_effect.gd"

const BURN_EFFECT = preload("uid://ckmmceiwbiqot")


func apply_with_data(data : Dictionary) -> void:
	if not is_instance_valid(data["enemy"]):
		return
	
	var target = data["enemy"]
	if not target.has_method("get_status_effect_component"):
		return
	
	var status_effect_component : StatusEffectComponent = target.get_status_effect_component()
	if not status_effect_component.is_effect_active(BURN_EFFECT) and rng_met():
		status_effect_component.add_status_effect(BURN_EFFECT, BURN_EFFECT.inflict_cooldown_time * 4)


func rng_met() -> bool:
	# 5% chance to burn enemies on hit
	return randi_range(0, 100) < 99
