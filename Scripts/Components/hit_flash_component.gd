class_name HitFlashComponent
extends RefCounted


var flash_colour : Color = Color.BLACK
var duration : float = 0.2
var initial_modulate : Color = Color.BLACK
var hit_flash_tween : Tween = null


func _init(_flash_colour : Color, _duration : float = 0.2) -> void:
	flash_colour = _flash_colour
	duration = _duration


func hit_flash(sprite : Sprite2D):
	if not sprite.material:
		return
	
	if hit_flash_tween and hit_flash_tween.is_running():
		hit_flash_tween.kill()
	
	(sprite.material as ShaderMaterial).set_shader_parameter("desired_colour", flash_colour)
	(sprite.material as ShaderMaterial).set_shader_parameter("lerp_percent", 1.0)
	hit_flash_tween = sprite.create_tween()
	hit_flash_tween.tween_property(sprite.material, "shader_parameter/lerp_percent", 0.0, .25)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
