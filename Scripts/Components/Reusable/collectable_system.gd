class_name CollectableSystem
extends RefCounted


var owner : Player


func _init(_owner : Player) -> void:
	owner = _owner


func collect(what : Collectable):
	if not can_collect(what):
		return
	
	if is_instance_of(what.drop, GunData):
		owner.add_gun(what.drop)
	
	if is_instance_of(what.drop, Item):
		if what.drop.name == "Key":
			owner.player_items.add_key()
		elif what.drop.name == "Half Heart":
			owner.health_component.increase_health(1)
		elif what.drop.name == "Heart":
			owner.health_component.increase_health(2)
		elif what.drop.name == "Current Ammo Refill":
			var ammo_to_add = owner.weapon_component.get_current_gun_data().base_ammo_in_reserve / 2
			var current_gun : GunData = owner.weapon_component.get_current_gun_data()
			var ammo_provider : MagazineAmmoProvider = owner.weapon_component.get_currnet_ammo_provider()
			var ammo_to_add_to_current = current_gun.ammo_per_magazine - ammo_provider.ammo_counter.current_ammo
			ammo_provider.add_to_current_ammo(ammo_to_add_to_current)
			ammo_to_add -= ammo_to_add_to_current
			ammo_provider.add_reserve_ammo(ammo_to_add)
	what.collect()


@warning_ignore("unused_parameter")
func can_collect(collectable : Collectable) -> bool:
	return true
