class_name HealthComponent
extends RefCounted


signal died 


var health : int = 0 : set = set_health
var max_health : int = 0


func _init(_health : int, _max_health : int) -> void:
	max_health = _max_health
	health = _health
	


func set_health(value):
	health = clamp(value, 0, max_health)
	check_dead()


func increase_health(by : int):
	health += by
	print(health)


func check_dead():
	if health <= 0:
		died.emit()
