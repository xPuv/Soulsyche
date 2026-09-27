extends TimedEffect

var vfx : VisualEffect = null


func apply(target : Node) -> void:
	if not target.has_method("take_damage"):
		return
	
	target.take_damage(1)
	vfx = BurnVisualEffect.new(target, 3)
	if not target.has_method("get_shader_material"):
		return



func revert(target : Node) ->  void:
	vfx.end_effect()
	vfx = null
