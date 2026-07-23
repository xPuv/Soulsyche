extends Sprite2D


var aim_component : AimComponent = null
var direction_facing_behaviour : DirectionFacingBehaviour = null


func setup(aim_comp : AimComponent):
	aim_component = aim_comp
	direction_facing_behaviour = DirectionFacingBehaviour.new(aim_component, self)


func tick():
	direction_facing_behaviour.tick()
