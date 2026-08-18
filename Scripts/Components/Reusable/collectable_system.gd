class_name CollectableSystem
extends RefCounted


var owner : Node2D


func _init(_owner : Node2D) -> void:
	owner = _owner


func collect(what : Collectable):
	if not can_collect(what):
		return
	
	if is_instance_of(what.drop, GunData):
		owner.add_gun(what.drop)
	
	if is_instance_of(what.drop, Item):
		if what.drop.name == "Key":
			owner.player_items.add_key()
	
	what.collect()


@warning_ignore("unused_parameter")
func can_collect(collectable : Collectable) -> bool:
	return true
