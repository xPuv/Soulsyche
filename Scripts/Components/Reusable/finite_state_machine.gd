class_name FiniteStateMachine
extends RefCounted


@export var default_state_id : int = -1


var states : Dictionary[int, State] = {}
var current_state : State = null


func _init(_default_state_id : int, _states : Array[State]) -> void:
	default_state_id = _default_state_id
	for state in _states:
		states[state.ID] = state


func change_state(state_id : int):
	var next_state : State = states[state_id]
	
	if next_state == null:
		push_error("Trying to switch to a state that doesnt exist")

	current_state.exit_state()
	current_state = next_state
	current_state.enter_state()


func get_current_state_id() -> int:
	return current_state.id


func tick():
	current_state.tick()
