class_name TriggeredEffect
extends Effect


@export var signal_name : String = ""


func should_trigger(data : Dictionary) -> bool:
	return true


func apply_with_data(data : Dictionary) -> void:
	pass
