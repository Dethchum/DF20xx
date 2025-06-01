extends Node
#declares initial state? dont know what this is really for or why is exported but fucking who cares ig its in every tutorial ive followed
@export var initial_state : State

#makes a var to check current state
var current_state : State

#makes a state dictionary
var states : Dictionary = {}

#checks if child is a state and connects signal to transition between states
func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.transitioned.connect(on_child_transitioned)
	
	if initial_state:
		initial_state.enter()
		current_state = initial_state

#updates physics properies for each state called
func _process(delta):
	if current_state:
		current_state.update(delta)
func _physics_process(delta):
	if current_state:
		current_state.physics_update(delta)

#enters and exits states when transitioning, very loose on this code using multiple tutorials due to no one ever using a state machine for player ever fuck me i hate this stupid chud life
func on_child_transitioned(state, new_state_name):
	if state != current_state:
		return
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return	
	if current_state:
		current_state.exit()
	
	new_state.enter()
