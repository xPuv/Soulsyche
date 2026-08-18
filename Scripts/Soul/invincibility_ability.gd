class_name Invicincibility
extends Ability


func activate(data : Dictionary):
	if not data.has("target"):
		return
	
	var target = data["target"]
	if not target.has_method("get_hurtbox_component"):
		return
	
	var hurtbox_component : HurtboxComponent = target.get_hurtbox_component()
	hurtbox_component.set_can_take_damage(false)


func revert(data : Dictionary):
	if not data.has("target"):
		return
	
	var target = data["target"]
	if not target.has_method("get_hurtbox_component"):
		return
	
	var hurtbox_component : HurtboxComponent = target.get_hurtbox_component()
	hurtbox_component.set_can_take_damage(true)
