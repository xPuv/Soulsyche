class_name CooldownComponent
extends RefCounted


var ready : bool = true
var cooldown_time : float = 0.0
var current_time : float = 0.0
var paused : bool = false

signal cooldown_over


func _init(new_cooldown_time : float) -> void:
	cooldown_time = new_cooldown_time


func start_cooldown():
	ready = false


func tick(delta : float):
	if paused == true:
		return
	current_time += delta
		
	if current_time >= cooldown_time:
		ready = true
		current_time = 0
		cooldown_over.emit()


func reset():
	ready = false
	current_time = 0 
