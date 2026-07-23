class_name ClampedStatistic extends Statistic


var max_value : int = 100
var min_value : int = 0


func _init(initial_value : int , _min_value : int , _max_value : int) -> void:
	base_value = initial_value
	max_value = _max_value
	min_value = _min_value


func increase_value(by_amount  : int):
	base_value += by_amount
	base_value = clamp(base_value, min_value, max_value)


func decrease_value(by_amount : int):
	base_value -= by_amount
	base_value = clamp(base_value, min_value, max_value)


func to_dict() -> Dictionary:
	return {"type" : "clamped", "value" : base_value, "min_value" : min_value, "max_value" : max_value}
