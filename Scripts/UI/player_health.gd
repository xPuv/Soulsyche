extends GridContainer
const HEART = preload("uid://6hjtip0le77n")
const HEART_EMPTY = preload("uid://dvlpktsywx14m")
const HEART_HALF = preload("uid://blx4kjnuqqqbi")

var max_health : int = 6
var health : int = 6


func setup(player : Player):
	var health_component = player.get_health_component()
	if not health_component:
		return
	
	health_component.health_changed.connect(_update_health)
	health_component.max_health_changed.connect(_update_max_health)
	health = health_component.health
	max_health = health_component.max_health
	display()


func get_current_heart(index : int):
	return get_children()[index]


func display():
	var full_hearts: int = health / 2
	var has_half_heart: bool = health % 2 != 0
	var total_hearts: int = max_health / 2
	
	# Full hearts
	for i in range(full_hearts):
		var heart: TextureRect = get_current_heart(i)
		heart.texture = HEART
	
	# Half heart
	if has_half_heart:
		var heart: TextureRect = get_current_heart(full_hearts)
		heart.texture = HEART_HALF
	
	# Empty hearts
	var first_empty_heart: int = full_hearts + int(has_half_heart)
	for i in range(first_empty_heart, total_hearts):
		var heart: TextureRect = get_current_heart(i)
		heart.texture = HEART_EMPTY


func _update_max_health(to : int):
	max_health = to
	display()


func _update_health(to : int):
	health = to
	display()
