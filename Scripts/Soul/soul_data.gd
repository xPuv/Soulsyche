class_name SoulData
extends Resource


# For now, assuming max level is 3 with 2 effects and 1 abil for each
@export var name : String = ""
@export var max_level : int = 3
@export var texture : Texture = null
@export var soul_effects : Array[Effect]
@export var ability : Ability = null
