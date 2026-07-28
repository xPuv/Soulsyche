class_name EffectHandler
extends RefCounted


signal effects_complete 

var effects : Array[Effect] = []


func _init(_effects : Array[Effect]) -> void:
	effects = _effects


func start_effects():
	for effect in effects:
		effect.start_effect()
		await effect.effect_complete
	effects_complete.emit()
