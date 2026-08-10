class_name WeightedTable
extends Resource

@export var items : Dictionary[Resource, int] = {}


func get_total_weight() -> int:
	var total := 0
	for weight in items.values():
		total += weight

	return total


func pick_loot() -> Resource:
	var total_weight : int = get_total_weight()
	var random_weight = randi_range(0, total_weight)
	var cumulative_weight : int = 0
	for key in items.keys():
		cumulative_weight += items[key]
		if cumulative_weight >= random_weight:
			return key
	return null
