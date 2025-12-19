class_name StateMachine extends Node

@export var initial_state: State

var current_state: State
var states: Dictionary = {}

# We pass 'target' (the owner) so states can control it
func init(target: Node) -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			
			# Inject dependencies into the state
			child.entity = target
			child.state_machine = self
	
	if initial_state:
		change_state(initial_state.name)


func physics_update(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)


func update(delta: float) -> void:
	if current_state:
		current_state.update(delta)


func change_state(state_name: String) -> void:
	var new_state = states.get(state_name.to_lower())
	if not new_state:
		push_warning("StateMachine: State not found - " + state_name)
		return
	
	if current_state:
		current_state.exit()
	
	current_state = new_state
	current_state.enter()


func get_state_by_name(state_name: String) -> State:
	return states.get(state_name.to_lower())