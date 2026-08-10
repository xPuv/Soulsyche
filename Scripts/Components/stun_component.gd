class_name StunComponent
extends RefCounted


var stunned : bool = false


var cooldown_component : CooldownComponent = null


func _init() -> void:
	cooldown_component = CooldownComponent.new(-1)
	cooldown_component.cooldown_over.connect(_on_stun_over)


func tick(delta):
	cooldown_component.tick(delta)


func start_stun(stun_time : float = 0.1):
	cooldown_component.set_coooldown_time(stun_time)
	stunned = true


func get_stun() -> bool:
	return stunned


func _on_stun_over():
	stunned = false
