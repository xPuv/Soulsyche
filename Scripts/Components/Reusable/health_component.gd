class_name HealthComponent
extends RefCounted


signal died 


var health : int = 0 : set = set_health
var max_health : int = 0

signal health_changed(to : int)
signal max_health_changed(to : int)


func _init(_health : int, _max_health : int) -> void:
	max_health = _max_health
	health = _health
	

func set_health(value):
	health = clamp(value, 0, max_health)
	check_dead()


func increase_health(by : int):
	health += by
	health_changed.emit(health)


func check_dead():
	if health <= 0:
		died.emit()


func set_max_health(to : int):
	max_health = to
	max_health_changed.emit(max_health)
