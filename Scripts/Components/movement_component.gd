class_name MovementComponent
extends RefCounted


var movement_velocity : Vector2 = Vector2.ZERO
var final_velocity : Vector2 = Vector2.ZERO
var acting_impusles : Array[Impulse] = []


class Impulse:
	var velocity : Vector2 = Vector2.ZERO
	var decay_strength : float = 200
	
	func _init(_decay_strength : float, _velocity : Vector2) -> void:
		decay_strength = _decay_strength
		velocity = _velocity
	
	
	func decay(delta : float):
		velocity = velocity.move_toward(Vector2.ZERO, delta * decay_strength)
	

func move(speed_value: float, direction : Vector2):
	movement_velocity = speed_value * direction


func smooth_move(speed_value: float, direction : Vector2, delta : float):
	movement_velocity = lerp(movement_velocity, direction * speed_value, 1.0 - exp(-speed_value / 3 * delta))
 

func _get_base_velocity() -> Vector2:
	return movement_velocity


func calculate_final_velocity(delta : float):
	final_velocity = _get_base_velocity()

	for i in range(acting_impusles.size() -1, -1, -1):
		var impulse = acting_impusles[i]
	
		final_velocity += impulse.velocity
		impulse.decay(delta)
		
		if impulse.velocity.is_equal_approx(Vector2.ZERO):
			acting_impusles.remove_at(i)


func get_velocity() -> Vector2:
	return final_velocity


func add_impulse(_decay : float, _velocity : Vector2):
	var velocity_impusle : Impulse = Impulse.new(_decay, _velocity)
	acting_impusles.append(velocity_impusle)


func _on_impusle_over(impulse_to_remove : Impulse):
	acting_impusles.erase(impulse_to_remove)
